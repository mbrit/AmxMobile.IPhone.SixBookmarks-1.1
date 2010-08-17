//
//  SBUsersService.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBUsersService.h"
#import "MyClasses.h"

@implementation SBUsersService

@synthesize callback;
@synthesize username;
@synthesize password;

-(id)init
{
	return [super initWithServiceName:@"usersrest.aspx"];
}

-(void)logon:(NSString *)theUsername password:(NSString *)thePassword callback:(SBLogonCallback *)theCallback
{
	// store...
	self.callback = theCallback;
	self.username = theUsername;
	self.password = thePassword;
	
	// do we need to logon to the API?
	if([SBServiceProxy hasToken])
		[self doLogon];
	else
	{
		// authenticate the API first...
		SBApiService *api = [[SBApiService alloc] init];
		[api logon:(NSString *)APIPASSWORD callback:(SBLogonCallback *)self];
		[api release];
	}
}

-(void)logonOk
{
	// we did it - our original logon method will now work...
	[self doLogon];
}

-(void)logonFailed:(NSError *)theError
{
	[self.callback logonFailed:theError];
}

-(void)doLogon
{
	// settings...
	SBDownloadSettings *settings = [self getDownloadSettings];
	
	// create some args...
	SBRestRequestArgs *args = [[SBRestRequestArgs alloc] initWithOperation:@"logon"];
	[args setValue:self.username forKey:@"username"];
	[args setValue:self.password forKey:@"password"];
	
	// download...
	[self makeRequest:args opCode:OPCODE_USERSLOGON];
	
	// cleanup...
	[args release];
	[settings release];
}

-(NSError *)processResult:(SBFlatXmlBucket *)values opCode:(int)theOpCode
{
	// what happened?
	NSString *result = [values getStringValue:@"Result"];
	if([result isEqualToString:@"LogonOk"])
	{
		// ok...
		return nil;
	}
	else
		return [SBErrorHelper error:self message:[NSString stringWithFormat:@"An error occurred on logon: '%@'.", result]];
}

-(void)requestOk:(int)theOpCode
{
	if(theOpCode == OPCODE_USERSLOGON)
		[callback logonOk];
	else
		[NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"Cannot handle '%d'.", theOpCode] userInfo:nil];
}

-(void)requestFailed:(int)theOpCode error:(NSError *)theError
{
	if(theOpCode == OPCODE_USERSLOGON)
		[callback logonFailed:theError];
	else
		[NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"Cannot handle '%d'.", theOpCode] userInfo:nil];
}

-(void)dealloc
{
	[username release];
	[password release];
	[callback release];
	[super dealloc];
}

@end
