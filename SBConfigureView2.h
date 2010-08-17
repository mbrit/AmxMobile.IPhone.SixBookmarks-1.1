//
//  SBConfigureView2.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 13/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBViewController.h"
#import "SBSync.h"

@interface SBConfigureView2 : SBViewController {

    NSMutableArray *bookmarks;
	UITableView *table;
	SBSync *syncEngine;

}

@property (nonatomic, retain) NSMutableArray *bookmarks;
@property (nonatomic, retain) IBOutlet UITableView *table;
@property (nonatomic, retain) SBSync *syncEngine;

-(IBAction)handleClose:(id)sender;
-(IBAction)handleSync:(id)sender;
-(IBAction)handleEdit:(id)sender;
-(IBAction)handleAdd:(id)sender;

-(void)stopEditing;

@end
