//
//  SixBookmarksAppDelegate.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 09/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "SBViewController.h"

@class SixBookmarksViewController;

@interface SixBookmarksAppDelegate : NSObject <UIApplicationDelegate> {

    UIWindow *window;
	SBViewController *viewController;   
    NSMutableDictionary *controllers;
    
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet SBViewController *viewController;
@property (nonatomic, retain) IBOutlet NSMutableDictionary *controllers;

-(void)openLogon;
-(void)openNavigator;
-(void)openConfiguration;
-(void)openBookmarkSingleton:(int)theOrdinal;

-(SBViewController *)currentController;
-(SBViewController *)getController:(Class)theClass;
-(void)showView:(SBViewController *)theController;

@end

