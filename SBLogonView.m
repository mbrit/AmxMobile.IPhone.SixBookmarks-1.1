//
//  SBLogonView.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 09/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBLogonView.h"
#import "MyClasses.h"

@implementation SBLogonView

@synthesize textUsername;
@synthesize textPassword;
@synthesize checkRememberMe;
@synthesize buttonLogon;
@synthesize loggingOnUser;

-(IBAction)handleLogonClick:(id)sender
{
	// get the values...
	NSString *username = self.textUsername.text;
	NSString *password = self.textPassword.text;
	
	// valdiate...
	SBErrorBucket *bucket = [[SBErrorBucket alloc] init];
	if(username == nil || username.length == 0)
		[bucket addError:@"Username is required"];
	if(password == nil || password.length == 0)
		[bucket addError:@"Password is required"];
	
	// now what?
	if(!(bucket.hasErrors))
	{
        // store for future use...
		self.loggingOnUser = username;
        
		// we'll do the logon operation in here...
		SBUsersService *users = [[SBUsersService alloc] init];
		[users logon:username password:password callback:(SBLogonCallback *)self];
		[users release];
	}
	else
		[SBMessageBox show:bucket.errorsAsString];
	
	// cleanup...
	[bucket release];
}

-(void)logonOk
{
    // store the username...
	[[SBRuntime current] setUsername:self.loggingOnUser];
	self.loggingOnUser = nil;
    
	// do a sync...
	SBSync *sync = [[[SBSync alloc] init] autorelease];
	[sync doSync:(SBSyncCallback *)self];
}

-(void)syncOk
{
	[self.owner openNavigator];
}

-(void)syncFailed:(NSError *)error
{
	[SBMessageBox showError:error];
}

-(void)logonFailed:(NSError *)theError
{
    [SBMessageBox showError:theError];
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


- (void)dealloc 
{
    [textUsername release];
    [textPassword release];
    [checkRememberMe release];
    [buttonLogon release];
    [loggingOnUser release];
    [super dealloc];
}


@end
