//
//  SBViewController.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 09/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBViewController.h"

@class SixBookmarksAppDelegate;

@interface SBViewController : UIViewController  {
    
    SixBookmarksAppDelegate *owner;
    
}

@property (nonatomic, retain) SixBookmarksAppDelegate *owner;

-(void)refreshView;

@end
