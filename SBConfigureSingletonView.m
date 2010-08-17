//
//  SBConfigureSingletonView.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 13/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBConfigureSingletonView.h"
#import "MyClasses.h"

@implementation SBConfigureSingletonView

@synthesize bookmark;
@synthesize textName;
@synthesize textUrl;

-(void)setOrdinal:(int)theOrdinal
{
	// try and load it...
	SBBookmark *theBookmark = nil;
	NSError *err = [SBBookmark getByOrdinal:theOrdinal bookmark:&theBookmark];
	if(err != nil)
		[SBMessageBox showError:err];
	else
	{
		// create...
		if(theBookmark == nil)
		{
			theBookmark = [[[SBBookmark alloc] init] autorelease];
			
			// set the ordinal (so that we save into the right place)...
			theBookmark.ordinal = theOrdinal;
		}
		
		// set...
		self.bookmark = theBookmark;
	}
	
	// update...
	self.refreshView;
}
    
-(IBAction)handleCancel:(int)sender
{
	[self.owner openConfiguration];
}

-(IBAction)handleSave:(int)sender
{
	// get the values...
	NSString *name = self.textName.text;
	NSString *url = self.textUrl.text;
	
	// can we?
	SBErrorBucket *errors = [[SBErrorBucket alloc] init];
	if(name == nil || [name length] == 0)
		[errors addError:@"Name is required."];
	if(url == nil || [url length] == 0)
		[errors addError:@"URL is required."];
	
	// ok...
	if(!([errors hasErrors]))
	{
		// save the regular bits...
		[self.bookmark setName:name];
		[self.bookmark setUrl:url];
		
		// set the flags...
		[self.bookmark setLocalModified:TRUE];
		[self.bookmark setLocalDeleted:FALSE];
		
		// save...
		[self.bookmark saveChanges];
		
		// ok...
		[self.owner openConfiguration];
	}
	else
		[SBMessageBox show:[errors errorsAsString]];
	
	// release...
	[errors release];
}

-(void)refreshView
{	
	// set...
	if(self.bookmark != nil)
	{
		[self.textName setText:[self.bookmark name]];
		[self.textUrl setText:[self.bookmark url]];
	}
	else 
	{
		[self.textName setText:nil];
		[self.textUrl setText:nil];
	}
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


-(void)dealloc 
{
	[bookmark release];
	[textName release];
	[textUrl release];
    [super dealloc];
}

@end
