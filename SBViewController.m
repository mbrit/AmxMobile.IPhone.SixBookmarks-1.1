//
//  SBViewController.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 09/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBViewController.h"


@implementation SBViewController

@synthesize owner;

-(void)bumpView
{
	//manually adjust the frame of the main view to prevent it from appearing under the status bar.
    UIApplication *app = [UIApplication sharedApplication];
    if(!app.statusBarHidden) 
	{
        [self.view setFrame:CGRectMake(0.0,app.statusBarFrame.size.height, self.view.bounds.size.width, self.view.bounds.size.height)];
    }	
}

-(void)viewDidAppear:(BOOL)animated 
{
	// bump...
	[self bumpView];
	
	// background...
	self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
	
	// do the base’s implementation...
	[super viewDidAppear:animated];
}

-(void)refreshView
{
	// we'll override this on each view...
}

-(void)dealloc
{
    [owner release];
    [super dealloc];
}

@end
