//
//  SBApiService.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBApiService.h"
#import "MyClasses.h"

@implementation SBApiService

@synthesize callback;

-(id)init
{
	return [super initWithServiceName:@"apirest.aspx"];
}

-(void)logon:(NSString *)apiPassword callback:(SBLogonCallback *)theCallback
{
	// store...
	self.callback = theCallback;
	
	// settings...
	SBDownloadSettings *settings = [self getDownloadSettings];
    
	// create some args...
	SBRestRequestArgs *args = [[SBRestRequestArgs alloc] initWithOperation:@"logon"];
	[args setValue:apiPassword forKey:@"password"];
    
	// download...
	[self makeRequest:args opCode:OPCODE_APILOGON];
	
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
		// set the global token...
		NSString *token = [values getStringValue:@"Token"];
		[SBServiceProxy setToken:token];
		
		// ok...
		return nil;
	}
	else
		return [SBErrorHelper error:self message:[NSString stringWithFormat:@"An error occurred on logon: '%@'.", result]];
}

-(void)requestOk:(int)theOpCode
{
	if(theOpCode == OPCODE_APILOGON)
		[self.callback logonOk];
	else
		[NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"Cannot handle '%d'.", theOpCode] userInfo:nil];
}

-(void)requestFailed:(int)theOpCode error:(NSError *)theError
{
	if(theOpCode == OPCODE_APILOGON)
		[self.callback logonFailed:theError];
	else
    {
		[NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"Cannot handle '%d'.", theOpCode] userInfo:nil];       
    }
}

-(void)dealloc
{
	[callback release];
	[super dealloc];
}

@end
