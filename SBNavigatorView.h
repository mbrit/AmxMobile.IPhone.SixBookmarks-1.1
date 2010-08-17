//
//  SBNavigatorView.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBViewController.h"
#import "SBBookmark.h"

@interface SBNavigatorView : SBViewController {
    
    UIButton *buttonNavigate1;
	UIButton *buttonNavigate2;
	UIButton *buttonNavigate3;
	UIButton *buttonNavigate4;
	UIButton *buttonNavigate5;
	UIButton *buttonNavigate6;
	NSMutableArray *bookmarks;

}

@property (nonatomic, retain) IBOutlet UIButton *buttonNavigate1;
@property (nonatomic, retain) IBOutlet UIButton *buttonNavigate2;
@property (nonatomic, retain) IBOutlet UIButton *buttonNavigate3;
@property (nonatomic, retain) IBOutlet UIButton *buttonNavigate4;
@property (nonatomic, retain) IBOutlet UIButton *buttonNavigate5;
@property (nonatomic, retain) IBOutlet UIButton *buttonNavigate6;
@property (nonatomic, retain) NSMutableArray *bookmarks;

-(IBAction)handleLogoff:(id)sender;
-(IBAction)handleConfigure:(id)sender;
-(IBAction)handleNavigate:(id)sender;
-(IBAction)handleAbout:(id)sender;

-(UIButton *)getButton:(int)ordinal;
-(void)resetButton:(int)ordinal;
-(void)setupButton:(SBBookmark *)bookmark;
-(void)showBookmarks:(NSMutableArray *)theBookmarks;

-(SBBookmark *)getBookmarkByOrdinal:(int)ordinal;
-(void)doNavigate:(int)ordinal;

@end
