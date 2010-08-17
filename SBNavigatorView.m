//
//  SBNavigatorView.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBNavigatorView.h"
#import "MyClasses.h"

@implementation SBNavigatorView

@synthesize buttonNavigate1;
@synthesize buttonNavigate2;
@synthesize buttonNavigate3;
@synthesize buttonNavigate4;
@synthesize buttonNavigate5;
@synthesize buttonNavigate6;
@synthesize bookmarks;

-(IBAction)handleLogoff:(id)sender
{
	[SBMessageBox show:@"TBD"];
}

-(IBAction)handleConfigure:(id)sender
{
	[self.owner openConfiguration];
}

-(IBAction)handleAbout:(id)sender
{
	[SBMessageBox show:@"TBD"];
}

-(void)refreshView
{
	// get them...
	NSMutableArray *theBookmarks = nil;
	NSError *err = [SBBookmark getBookmarksForDisplay:&theBookmarks];
	if(err != nil)
	{
		[SBMessageBox showError:err];
        return;
	}
	
	// show...
	[self showBookmarks:theBookmarks];
}

-(UIButton *)getButton:(int)ordinal
{
	if(ordinal == 0)
		return self.buttonNavigate1;
	else if(ordinal == 1)
		return self.buttonNavigate2;
	else if(ordinal == 2)
		return self.buttonNavigate3;
	else if(ordinal == 3)
		return self.buttonNavigate4;
	else if(ordinal == 4)
		return self.buttonNavigate5;
	else if(ordinal == 5)
		return self.buttonNavigate6;
	else
		return nil;
}

// <…> Needs declaration in header
-(void)resetButton:(int)ordinal
{
	// get...
	UIButton *button = [self getButton:ordinal];
	[button setTitle:@"..." forState:UIControlStateNormal];
}

// <…> Needs declaration in header
-(void)setupButton:(SBBookmark *)bookmark
{
	// get...
	UIButton *button = [self getButton:[bookmark ordinal]];
	[button setTitle:[bookmark name] forState:UIControlStateNormal];
}

// <…> Needs declaration in header
-(void)showBookmarks:(NSMutableArray *)theBookmarks
{
	// reset all buttons...
	for(int index = 0; index < 6; index++)
		[self resetButton:index];
	
	// show the buttons...
	for(SBBookmark *bookmark in theBookmarks)
		[self setupButton:bookmark];
    
	// store the bookmarks...
	self.bookmarks = theBookmarks;
}

-(IBAction)handleNavigate:(id)sender
{
	if(sender == self.buttonNavigate1)
		[self doNavigate:0];
	else if(sender == self.buttonNavigate2)
		[self doNavigate:1];
	else if(sender == self.buttonNavigate3)
		[self doNavigate:2];
	else if(sender == self.buttonNavigate4)
		[self doNavigate:3];
	else if(sender == self.buttonNavigate5)
		[self doNavigate:4];
	else if(sender == self.buttonNavigate6)
		[self doNavigate:5];
}

-(SBBookmark *)getBookmarkByOrdinal:(int)ordinal
{
	for(SBBookmark *bookmark in self.bookmarks)
	{
		if([bookmark ordinal] == ordinal)
			return bookmark;
	}
	
	// nope...
	return nil;
}

-(void)doNavigate:(int)ordinal
{
	SBBookmark *bookmark = [self getBookmarkByOrdinal:ordinal];
	if(bookmark != nil)
		[[SBRuntime current] showUrl:bookmark.url];
	else
		[self handleConfigure:self];
}

-(void)dealloc 
{
	[buttonNavigate1 release];
	[buttonNavigate2 release];
	[buttonNavigate3 release];
	[buttonNavigate4 release];
	[buttonNavigate5 release];
	[buttonNavigate6 release];
	[bookmarks release];
    [super dealloc];
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


@end
