//
//  SBEntityChangeProcessor.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBEntityChangeProcessor.h"
#import "MyClasses.h"

@implementation SBEntityChangeProcessor

@synthesize entityType;

-(id)initWithEntityType:(SBEntityType *)et
{
	if(self = [super init])
	{
		[self setEntityType:et];
	}
	
	// return...
	return self;
}

-(void)saveChanges:(SBEntity *)entity
{
	if([entity isNew])
		[self insert:entity];
	else if([entity isModified])
		[self update:entity];
	else if([entity isDeleted])
		[self delete:entity];
}

-(void)insert:(SBEntity *)entity
{
	SBEntityType *et = self.entityType;
	
	// do we have a table?
	SBDBHelper *db = nil;
	SBSqlStatement *sql = nil;
	@try
	{
		db = [[SBRuntime current] getDatabase];
		[db ensureTableExists:et];
		
		// create a statement...
		NSMutableString *builder = [NSMutableString string];
		sql = [[SBSqlStatement alloc] init];
		
		// header...
		[builder appendString:@"INSERT INTO "];
		[builder appendString:et.nativeName];
		[builder appendString:@" ("];
		BOOL first = TRUE;
		for(SBEntityField *field in et.fields)
		{
			if([entity isFieldModified:field])
			{
				if(first)
					first = FALSE;
				else 
					[builder appendString:@", "];
				
				// name...
				[builder appendString:field.nativeName];
			}
		}
		
		// values...
		[builder appendString:@") VALUES ("];
		first = TRUE;
		for(SBEntityField *field in et.fields)
		{
			if([entity isFieldModified:field])
			{
				if(first)
					first = FALSE;
				else 
					[builder appendString:@", "];
				
				// name...
				[builder appendString:@"?"];
				[sql addParameter:[entity getValue:field]];
			}
		}
		[builder appendString:@")"];
		
		// attach...
		sql.commandText = builder;
		
		// run...
		BOOL ok = [db execNonQuery:sql];
		if(!(ok))
		{
			NSError *err = [db getLastError];
			@throw [NSException exceptionWithName:[[self class] description] reason:[SBErrorHelper formatError:err] userInfo:nil];
		}
	}
	@finally 
	{
		// release...
		[sql release];
		[db release];
	}
}

-(void)update:(SBEntity *)entity
{
	// create...
	SBEntityType *et = self.entityType;
	
	// do we have a table?
	SBDBHelper *db = [[SBRuntime current] getDatabase];
	[db ensureTableExists:et];
	
	// create a statement...
	NSMutableString *builder = [NSMutableString string];
	SBSqlStatement *sql = [[SBSqlStatement alloc] init];
	
	// header...
	[builder appendString:@"UPDATE "];
	[builder appendString:et.nativeName];
	[builder appendString:@" SET "];
	BOOL first = TRUE;
	for(SBEntityField *field in et.fields)
	{
		if([entity isFieldModified:field])
		{
			if(first)
				first = FALSE;
			else 
				[builder appendString:@", "];
			
			// name...
			[builder appendString:field.nativeName];
			[builder appendString:@"=?"];
			
			// param...
			[sql addParameter:[entity getValue:field]];
		}
	}
	
	// constrain by the key field...
	SBEntityField *keyField = [et getKeyField];
	[builder appendString:@" WHERE "];
	[builder appendString:keyField.nativeName];
	[builder appendString:@"=?"];
	[sql addParameter:[entity getValue:keyField]];
	
	// attach...
	[sql setCommandText:builder];
	
	// run...
	@try
	{
		BOOL ok = [db execNonQuery:sql];
		if(!(ok))
		{
			NSError *err = [db getLastError];
			@throw [NSException exceptionWithName:[[self class] description] reason:[SBErrorHelper formatError:err] userInfo:nil];
		}
	}
	@finally 
	{
		// release...
		[sql release];
	}
}

-(void)delete:(SBEntity *)entity
{
	// create...
	SBEntityType *et = [self entityType];
	
	// do we have a table?
	SBDBHelper *db = [[SBRuntime current] getDatabase];
	[db ensureTableExists:et];
	
	// create a statement...
	NSMutableString *builder = [NSMutableString string];
	SBSqlStatement *sql = [[SBSqlStatement alloc] init];
	
	// create a statement...
	SBEntityField *keyField = [et getKeyField];
	[builder appendString:@"DELETE FROM "];
	[builder appendString:et.nativeName];
	[builder appendString:@" WHERE "];
	[builder appendString:keyField.nativeName];
	[builder appendString:@"=?"];
	[sql addParameter:[entity getValue:keyField]];
	
	// attach...
	[sql setCommandText:builder];
	
	// run...
	@try
	{
		BOOL ok = [db execNonQuery:sql];
		if(!(ok))
		{
			NSError *err = [db getLastError];
			@throw [NSException exceptionWithName:[[self class] description] reason:[SBErrorHelper formatError:err] userInfo:nil];
		}
	}
	@finally 
	{
		// release...
		[sql release];
	}
}

-(void)dealloc
{
	[entityType release];
	[super dealloc];
}

@end
