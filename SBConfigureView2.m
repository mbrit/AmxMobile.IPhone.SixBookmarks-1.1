//
//  SBConfigureView2.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 13/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBConfigureView2.h"
#import "MyClasses.h"

@implementation SBConfigureView2

@synthesize bookmarks;
@synthesize table;
@synthesize syncEngine;

-(IBAction)handleClose:(id)sender
{
	// are we editing?
	if(self.table.editing)
		[self stopEditing];
    else
		[self.owner openNavigator];
}

-(void)stopEditing
{
	[self.table setEditing:FALSE animated:TRUE];
}

-(IBAction)handleSync:(id)sender
{
	if(self.syncEngine == nil)
		self.syncEngine = [[SBSync alloc] init];
	[self.syncEngine doSync:(SBSyncCallback *)self];
}

-(void)syncOk
{
	[self refreshView];
	[SBMessageBox show:@"Sync OK."];
}

-(void)syncFailed:(NSError *)err
{
	// nope...
	[SBMessageBox showError:err];
}

-(IBAction)handleEdit:(id)sender
{
	[self.table setEditing:TRUE animated:TRUE];
}

-(void)refreshView
{
	// do we have bookmarks?
	BOOL doReload = FALSE;
	if(self.bookmarks != nil)
		doReload = TRUE;
	
	// get our bookmarks...
	NSMutableArray *theBookmarks = nil;
	NSError *err = [SBBookmark  getBookmarksForDisplay:&theBookmarks];
	if(err != nil)
		[SBMessageBox showError:err];
	else
	{
		// keep track...
		self.bookmarks = theBookmarks;
        
        // sort by ordinal...
		[theBookmarks sortUsingSelector:@selector(ordinalComparer:)];
	}
	
	// reload...
	if(doReload)
		[self.table reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return [self.bookmarks count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *cellId = @"BookmarkKey";
	
	// find one...
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	if(cell == nil)
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId] autorelease];
	
	// set...
	NSUInteger row = [indexPath row];
	cell.textLabel.text = [[self.bookmarks objectAtIndex:row] name];
    
    // set the disclosure indicator...
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    // return...
	return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	// find it...
	SBBookmark *bookmark = [self.bookmarks objectAtIndex:[indexPath row]];
	[self.owner openBookmarkSingleton:[bookmark ordinal]];
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)style forRowAtIndexPath:(NSIndexPath *)indexPath
{
	// great - get rid of it...
	SBBookmark *bookmark = [self.bookmarks objectAtIndex:[indexPath row]];
	[bookmark setLocalDeleted:TRUE];
	[bookmark saveChanges];
	
	// update...
	[self stopEditing];
	[self refreshView];
}

-(int)getOrdinalToAdd
{
	NSMutableArray *array = [NSMutableArray array];
	for(int index = 0; index < 6; index++)
		[array addObject:[NSNumber numberWithBool:FALSE]];
	for(SBBookmark  *bookmark in self.bookmarks)
		[array replaceObjectAtIndex:[bookmark ordinal] withObject:[NSNumber numberWithBool:TRUE]];
    
	// walk...
	for(int index = 0; index < 6; index++)
	{
		NSNumber *value = [array objectAtIndex:index];
		if([value boolValue] == FALSE)
			return index;
	}
	
	// return...
	return -1;
}

-(IBAction)handleAdd:(id)sender
{
	int ordinal = [self getOrdinalToAdd];
	if(ordinal != -1)
		[self.owner openBookmarkSingleton:ordinal];
	else
		[SBMessageBox show:@"No more bookmarks can be added."];
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
	[syncEngine release];
	[bookmarks release];
	[table release];
    [super dealloc];
}

@end
