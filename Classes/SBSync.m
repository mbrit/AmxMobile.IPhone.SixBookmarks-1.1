//
//  SBSync.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBSync.h"
#import "MyClasses.h"

@implementation SBSync

@synthesize callback;
@synthesize mode;
@synthesize updates;
@synthesize deletes;
@synthesize workItems;
@synthesize workItemIndex;

-(void)doSync:(SBSyncCallback *)theCallback
{
	self.callback = theCallback;
	
    // start spinning...
	[SBServiceProxy startSpinning];

    // check the database...
	SBDBHelper *db = [[SBRuntime current] getDatabase];
	[db ensureTableExists:[SBEntityType getEntityType:[SBBookmark class]]];
	[db release];
    
	// run...
	[self sendChanges];
}

-(void)sendChanges
{
	// do we have anything to send?
	NSMutableArray *theUpdates = nil;
	NSMutableArray *theDeletes = nil;
	NSError *err = [SBBookmark getBookmarksForServerUpdate:&theUpdates];
	if(err != nil)
	{
		[self.callback syncFailed:err];
		return;
	}
	err = [SBBookmark getBookmarksForServerDelete:&theDeletes];
	if(err != nil)
	{
		[self.callback syncFailed:err];
		return;
	}
	
	// do we have anything to do?
	if(theUpdates.count == 0 && theDeletes.count == 0)
	{
		[self getLatest];
	}
	else
	{
		// store the updates - we're going to come back async later...
		self.updates = theUpdates;
		self.deletes = theDeletes;
		
		// ok - we have to create a delta, get the server items...
		self.mode = SBSMPushChanges;
		SBBookmarksService *service = [[SBBookmarksService alloc] init];
		[service getAll:(SBODataFetchCallback *)self];
		[service release];
	}
}

-(void)getLatest
{
	// connect to the service and get them all...
	self.mode = SBSMGetLatest;
	SBBookmarksService *service = [[SBBookmarksService alloc] init];
	[service getAll:(SBODataFetchCallback *)self];
	[service release];
}

-(void)odataFetchOk:(SBEntityXmlBucket *)bucket opCode:(int)theOpCode
{
	// what's our mode?
	if(theOpCode == OPCODE_ODATAFETCHALL)
	{
		if(self.mode == SBSMGetLatest)
			[self processServerItemsForGetAll:bucket];
		else if(self.mode == SBSMPushChanges)
			[self receiveServerItemsForPushChanges:bucket];
		else
			@throw [NSException exceptionWithName:[[self class] description] reason:@"Cannot handle mode." userInfo:nil];
	}
	else if(theOpCode == OPCODE_ODATACHANGE)
	{
		// fire the next one in the queue...
		self.workItemIndex++;
		[self processWorkItems];
	}
	else
		@throw [NSException exceptionWithName:[[self class] description] reason:@"Cannot handle op code." userInfo:nil];
	
	// stop spinning...
	[SBServiceProxy stopSpinning];
}

-(void)processServerItemsForGetAll:(SBEntityXmlBucket *)entities
{
	// we have them - so clear down the database and insert them...
	[SBBookmark deleteAll];
	
	// walk...
	SBEntityType *et = [SBEntityType getEntityType:[SBBookmark class]];
	for(SBBookmark *server in entities.entities)
	{
		// create a new one, skipping the key...
		SBBookmark *local = [[SBBookmark alloc] init];
		for(SBEntityField *field in et.fields)
		{
			// only do this if we've been set and we're a key...
			if(!([field isKey]) && [server isFieldLoaded:field])
			{
				NSObject *value = [server getValue:field];
				[local setValue:field value:value reason:SBESRUserSet];
			}
		}
		
		// force the special fields...
		local.localModified = FALSE;
		local.localDeleted = FALSE;
		
		// save...
		[local saveChanges];
		
		// release...
		[local release];
	}
	
	// great - we're done...
	[self.callback syncOk];
}

-(void)odataFetchFailed:(NSError *)err opCode:(int)theOpCode
{
    // stop spinning...
	[SBServiceProxy stopSpinning];

    // show...
	[SBMessageBox showError:err];
}

-(void)receiveServerItemsForPushChanges:(SBEntityXmlBucket *)entities
{
	SBEntityType *et = [SBEntityType getEntityType:[SBBookmark class]];
	
	// good - we got this far... build a set of work to do...
	NSMutableArray *theWorkItems = [NSMutableArray array];
	for(SBBookmark *local in self.updates)
	{
		// find it in our set...
		SBBookmark *toUpdate = nil;
		for(SBBookmark *server in entities.entities)
		{
			if(local.ordinal == server.ordinal)
			{
				toUpdate = server;
				break;
			}
		}
		
		// did we have one to change?
		if(toUpdate != nil)
		{
			// walk the fields...
			int serverId = 0;
			for(SBEntityField *field in et.fields)
			{
				if(!(field.isKey))
					[toUpdate setValue:field value:[local getValue:field] reason:SBESRUserSet];
				else
					serverId = toUpdate.bookmarkId;
			}
			
			// send that up...
			[theWorkItems addObject:[[SBSyncWorkItem alloc] initWithData:toUpdate serverId:serverId mode:SBODOUpdate]];
		}
		else
		{
			// we need to insert it...
			[theWorkItems addObject:[[SBSyncWorkItem alloc] initWithData:local serverId:0 mode:SBODOInsert]];
		}
	}
	
	// what about ones to delete?
	for(SBBookmark *local in self.deletes)
	{
		// find a matching ordinal on the server...
		for(SBBookmark *server in entities.entities) 
		{
			if(local.ordinal ==  server.ordinal)
			{
				int serverId = server.bookmarkId;
				[theWorkItems addObject:[[SBSyncWorkItem alloc] initWithData:server serverId:serverId mode:SBODODelete]];
			}
		}
	}
	
	// now we have a list of work, we have to process it... asynchronously...
	self.workItems = theWorkItems;
	self.workItemIndex = 0;
	[self processWorkItems];
}

-(void)processWorkItems
{
	// are we at the end of the list?  if so... time to get latest...
	if(self.workItemIndex == [self.workItems count])
	{
		// return...
		[self getLatest];
		return;
	}
	
	// get the work item...
	SBSyncWorkItem *item = [self.workItems objectAtIndex:self.workItemIndex];
	NSLog(@"Syncing: %d, %d, %@", item.mode, item.serverId, [[item.entity class] description]);
	
	// call the service...
	SBBookmarksService *service = [[SBBookmarksService alloc] init];
	if(item.mode == SBODOInsert)
		[service pushInsert:item.entity callback:(SBODataFetchCallback *)self];        
	else if(item.mode == SBODOUpdate)
		[service pushUpdate:item.entity serverId:item.serverId callback:(SBODataFetchCallback *)self];
	else if(item.mode == SBODODelete)
		[service pushDelete:item.entity serverId:item.serverId callback:(SBODataFetchCallback *)self];
	
	// we now need to wait for something to happen...
}

-(void)dealloc
{
	[callback release];
	[super dealloc];
}

@end
