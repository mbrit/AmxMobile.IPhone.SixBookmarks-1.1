//
//  SBDownloadSettings.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBDownloadSettings.h"


@implementation SBDownloadSettings

@synthesize extraHeaders;

-(id)init
{
	if(self = [super init])
	{
		extraHeaders = [NSMutableDictionary dictionary];
	}
	
	// return...
	return self;
}

-(void)addHeader:(NSString *)value forName:(NSString *)name
{
	[extraHeaders setValue:value forKey:name];
}

-(void)dealloc
{
	[super dealloc];
}

@end
