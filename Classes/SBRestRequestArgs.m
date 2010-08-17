//
//  SBRestRequestArgs.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBRestRequestArgs.h"


@implementation SBRestRequestArgs

@synthesize args;

-(id)initWithOperation:(NSString*)theOperation
{
	if(self = [super init])
	{
		self.args = [NSMutableDictionary dictionary];
		[self setValue:theOperation forKey:@"operation"];
	}
	
	// return...
	return self;
}

-(void)setValue:(id)value forKey:(NSString *)key
{
	[args setValue:value forKey:key];
}

-(void)dealloc
{
	[args release];
	[super dealloc];
}

@end
