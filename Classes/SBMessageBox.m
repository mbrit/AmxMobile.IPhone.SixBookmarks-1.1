//
//  SBMessageBox.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBMessageBox.h"
#import "MyClasses.h"

@implementation SBMessageBox

+(void)show:(NSString *)message
{
	UIAlertView *alert = [[UIAlertView alloc] init];
	[alert setTitle:@"Six Bookmarks"];
	[alert setMessage:message];
	[alert addButtonWithTitle:@"OK"];
	[alert show];
	
	// cleanup...
	[alert release];
}

+(void)showError:(NSError *)err
{
	NSString *message = [SBErrorHelper formatError:err];
	NSLog(@"%@", message);
	[self show:message];
}

@end
