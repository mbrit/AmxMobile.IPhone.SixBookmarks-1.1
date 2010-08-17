//
//  SBConfigureSingletonView.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 13/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBViewController.h"
#import "SBBookmark.h"

@interface SBConfigureSingletonView : SBViewController {
    
    SBBookmark *bookmark;
	UITextField *textName;
	UITextField *textUrl;

}

@property (nonatomic, retain) SBBookmark *bookmark;
@property (nonatomic, retain) IBOutlet UITextField *textName;
@property (nonatomic, retain) IBOutlet UITextField *textUrl;

-(void)setOrdinal:(int)theOrdinal;

-(IBAction)handleCancel:(int)sender;
-(IBAction)handleSave:(int)sender;

@end
