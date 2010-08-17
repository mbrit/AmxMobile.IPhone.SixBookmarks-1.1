//
//  SixBookmarksAppDelegate.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 09/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//


#import "SixBookmarksAppDelegate.h"
#import "SixBookmarksViewController.h"
#import "MyClasses.h"

@implementation SixBookmarksAppDelegate

@synthesize window;
@synthesize viewController;
@synthesize controllers;

-(id)init
{
	if(self = [super init])
	{
		self.controllers = [NSMutableDictionary dictionary];
	}
	
	// return...
	return self;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions 
{
	// start the runtime…
	[SBRuntime start];
    
	// show the form…
    [self openLogon];
	return YES;
}

-(void)openLogon
{
	// find a preexisting view...
	SBViewController *view = [self getController:[SBLogonView class]];
	if(view == nil)
		view = [[SBLogonView alloc] initWithNibName:@"SBLogonView" bundle:[NSBundle mainBundle]];
	
	// show the view...
	[self showView:view];
}

-(void)openNavigator 
{
	// find a preexisting view...
	SBViewController *view = [self getController:[SBNavigatorView class]];
	if(view == nil)
		view = [[SBNavigatorView alloc] initWithNibName:@"SBNavigatorView" bundle:[NSBundle mainBundle]];
	
	// show the view...
	[self showView:view];
}

-(void)openConfiguration
{
	// find a preexisting view...
	SBViewController *view = [self getController:[SBConfigureView2 class]];
	if(view == nil)
		view = [[SBConfigureView2 alloc] initWithNibName:@"SBConfigureView2" bundle:[NSBundle mainBundle]];
	
	// show the view...
	[self showView:view];
}

-(void)openBookmarkSingleton:(int)theOrdinal
{
	// find a preexisting view...
	SBViewController *view = [self getController:[SBConfigureSingletonView class]];
	if(view == nil)
		view = [[SBConfigureSingletonView alloc] initWithNibName:@"SBConfigureSingletonView" bundle:[NSBundle mainBundle]];
	
	// set...
	[((SBConfigureSingletonView *)view) setOrdinal:theOrdinal];
	
	// show the view...
	[self showView:view];
}

-(SBViewController *)currentController
{
	// find the current view - this is the one that has a superview...
	for(NSString *key in self.controllers)
	{
		SBViewController *controller = [self.controllers objectForKey:key];
		if(controller.view != nil && controller.view.superview != nil)
			return controller;
	}
	
	// none...
	return nil;
}

-(SBViewController *)getController:(Class)theClass
{
	return (SBViewController *)[self.controllers objectForKey:[theClass description]];
}

-(void)showView:(SBViewController *)theController
{
	// is this first?
	SBViewController *current = self.currentController;
	
    // set the owner to be us...
	[theController setOwner:self];

    // do we have it in the collection?
	NSString *key = [theController.class description];
	if([self.controllers objectForKey:key] == nil)
		[self.controllers setValue:theController forKey:key];
	
	// add...
	[window addSubview:theController.view];
	
	// do we have a view?
	if(current == nil)
		[window makeKeyAndVisible];
	else 
	{	
		// remove...
		[current.view removeFromSuperview];
	}
	
	// update it...
	[theController refreshView];
}

- (void)applicationWillTerminate:(UIApplication *)application {

    // Save data if appropriate.

}

- (void)dealloc {

    [window release];
    [viewController release];
    [controllers release];
    [super dealloc];
}

@end

