//
//  SBSqlStatement.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBSqlStatement.h"


@implementation SBSqlStatement

@synthesize selectMap;
@synthesize entityType;
@synthesize commandText;
@synthesize params;

-(id)init
{
	if(self = [super init])
	{
		self.params = [NSMutableArray array];
        self.selectMap = [NSMutableArray array];
	}
	
	// return...
	return self;
}

-(id)initWithEntityType:(SBEntityType *)theEntityType
{
	if(self = [self init])
	{
		self.entityType = theEntityType;
	}
	
	// return...
	return self;
}

-(id)initWithCommandText:(NSString *)theCommandText
{
	if(self = [self init])
	{
		self.commandText = theCommandText;
	}
	
	// return...
	return self;
}

-(void)addToSelectMap:(SBEntityField *)field
{
	[self.selectMap addObject:field];
}

-(void)addParameter:(NSObject *)value
{
	[self.params addObject:value];
}

-(void)dealloc
{
    [entityType release];
	[selectMap release];
	[params release];
	[commandText release];
	[super dealloc];
}

@end
