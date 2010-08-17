//
//  SBBoomarksService.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBBookmarksService.h"
#import "MyClasses.h"

@implementation SBBookmarksService

-(id)init
{
	return [super initWithTypeAndServiceName:[SBBookmark class] serviceName:@"Bookmarks.svc"];
}

@end
