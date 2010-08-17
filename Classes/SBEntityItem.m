//
//  SBEntityItem.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBEntityItem.h"


@implementation SBEntityItem

@synthesize name;
@synthesize nativeName;

-(id)initWithNameAndNativeName:(NSString *)theName nativeName:(NSString *)theNativeName
{
	if(self = [super init])
	{
		[self setName:theName];
		[self setNativeName:theNativeName];
	}
	
	// return...
	return self;
}

-(void)dealloc
{
	[name release];
	[nativeName release];
	[super dealloc];
}

@end
