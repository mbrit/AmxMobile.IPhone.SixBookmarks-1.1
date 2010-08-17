//
//  SBRuntime.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBRuntime.h"
#import "MyClasses.h"

@implementation SBRuntime

@synthesize username;

static SBRuntime *theCurrent = nil;

+(SBRuntime *)current
{
	return theCurrent;
}

+(void)setCurrent:(SBRuntime *)rt
{
	theCurrent = rt;
	[theCurrent retain];
}

+(void)start
{
	// create...
	SBRuntime *rt = [[SBRuntime alloc] init];
	[SBRuntime setCurrent:rt];
	
	// type...
	SBEntityType *et = [[SBEntityType alloc] initWithInstanceTypeNativeName:[SBBookmark class] nativeName:@"Bookmark"];
	[[et addField:BOOKMARK_IDKEY nativeName:BOOKMARK_IDKEY type:SBDT_INT32 size:-1] setIsKey:TRUE];
	[et addField:BOOKMARK_ORDINALKEY nativeName:BOOKMARK_ORDINALKEY type:SBDT_INT32 size:-1];
	[et addField:BOOKMARK_NAMEKEY nativeName:BOOKMARK_NAMEKEY type:SBDT_STRING size:128];
	[et addField:BOOKMARK_URLKEY nativeName:BOOKMARK_URLKEY type:SBDT_STRING size:256];
	[[et addField:BOOKMARK_LOCALMODIFIEDKEY nativeName:BOOKMARK_LOCALMODIFIEDKEY type:SBDT_INT32 size:-1] setIsOnServer:FALSE];
	[[et addField:BOOKMARK_LOCALDELETEDKEY nativeName:BOOKMARK_LOCALDELETEDKEY type:SBDT_INT32 size:-1] setIsOnServer:FALSE];
	[SBEntityType registerEntityType:et];
	[et release];
}

-(void)showUrl:(NSString *)theUrl
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:theUrl]]; 
}

-(SBDBHelper *)getDatabase
{
	// name...
	NSString *name = [NSString stringWithFormat:@"SixBookmarks-%@", self.username];
	SBDBHelper *db = [[SBDBHelper alloc] initWithDatabaseName:name];
	
	// return...
	return db;
}

// Override dealloc…
-(void)dealloc
{
	[username release];
	[super dealloc];
}

@end
