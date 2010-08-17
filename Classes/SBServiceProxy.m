//
//  SBServiceProxy.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBServiceProxy.h"
#import "MyClasses.h"

@implementation SBServiceProxy

@synthesize serviceName;

// YOU MUST CHANGE THIS IN ORDER TO USE THE SAMPLE...
const NSString *APIUSERNAME = @"amxmobile";
const NSString *APIPASSWORD = @"password";

static NSString *_token;

-(id)initWithServiceName:(NSString *)theServiceName
{
	if(self = [super init])
	{
		self.serviceName = theServiceName;
	}
	
	// return...
	return self;
}

+(NSString *)token
{
	return _token;
}

+(void)setToken:(NSString *)theToken
{
	[_token release];
	_token = [theToken retain];
}

+(BOOL)hasToken
{
	if(_token != nil && _token.length > 0)
		return TRUE;
	else
		return FALSE;
}

-(NSString*)resolvedServiceUrl
{
	return [NSString stringWithFormat:@"%@%@", @"http://services.multimobiledevelopment.com/", self.serviceName];
}

-(SBDownloadSettings *)getDownloadSettings
{
	SBDownloadSettings *settings = [[SBDownloadSettings alloc] init];
	
	// set...
	[settings addHeader:(NSString *)APIUSERNAME forName:@"x-amx-apiusername"];
	NSString *theToken = [SBServiceProxy token];
	if(theToken != nil && theToken.length > 0)
		[settings addHeader:theToken forName:@"x-amx-token"];
	
	// return...
	return settings;
}

+(void)startSpinning
{
	// start spinning...
	[UIApplication sharedApplication].networkActivityIndicatorVisible = TRUE;
}

+(void)stopSpinning
{
	// stop spinning...
	[UIApplication sharedApplication].networkActivityIndicatorVisible = FALSE;
} 

-(void)dealloc
{
	[serviceName release];
	[super dealloc];
}

@end
