//
//  SBSyncWorkItem.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 13/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBSyncWorkItem.h"
#import "MyClasses.h"

@implementation SBSyncWorkItem

@synthesize entity;
@synthesize serverId;
@synthesize mode;

-(id)initWithData:(SBEntity *)theEntity serverId:(int)theServerId mode:(SBODataOperation)theMode
{
	if(self = [super init])
	{
		self.entity = theEntity;
		self.serverId = theServerId;
		self.mode = theMode;
	}
	
	// return...
	return self;
}

-(void)dealloc
{
	[entity release];
	[super dealloc];
}

@end
