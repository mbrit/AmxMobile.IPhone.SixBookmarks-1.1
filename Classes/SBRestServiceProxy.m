//
//  SBRestServiceProxy.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBRestServiceProxy.h"
#import "MyClasses.h"

@implementation SBRestServiceProxy

-(id)initWithServiceName:(NSString *)theServiceName
{
	return [super initWithServiceName:theServiceName];
}

-(void)makeRequest:(SBRestRequestArgs *)args opCode:(int)theOpCode
{
	// get the url...
	NSString *url = [SBHttpHelper buildUrl:[self resolvedServiceUrl] args:[args args]];
	
	// download...
	SBDownloadSettings *settings = [self getDownloadSettings];
	[SBHttpHelper download:url settings:settings callback:(SBDownloadCallback *)self opCode:theOpCode];
    
    // start the wheel spinning...
	[SBServiceProxy startSpinning];
}

-(void)downloadComplete:(SBDownloadBucket *)bucket
{
	// did we get a 200?
	NSError *err = nil;
	if(bucket.statusCode == 200) 
	{
		// at this point we have a rest response from the server.  what
		// we need to do now is parse it... thus we`ll create a parser
		// and create an SBFlatXmlBucket to collect the data...
		NSXMLParser *parser = [[NSXMLParser alloc] initWithData:[bucket data]];
        
		// result...
		SBFlatXmlBucket *values = [[SBFlatXmlBucket alloc] init];
		[parser setDelegate:values];
        
		// run...
		[parser parse];
		
		// ok - what did we get?
		int result =  [[values rootName] isEqualToString:@"AmxResponse"];
		if([values rootName] == nil || !(result))
			err = [SBErrorHelper error:self message:[NSString stringWithFormat:@"The REST service `%@` returned a root element with name `%@`, not `AmxResponse`.", [self serviceName], [values rootName]]];
		else
		{
			// did we get an exception?
			BOOL hasException = [values getBooleanValue:@"HasException"];
			if(hasException)
			{
				NSString *message = [values getStringValue:@"Error"];
				err = [SBErrorHelper error:self message:[NSString stringWithFormat:@"The REST service `%@` returned an exception: `%@`.", serviceName, message]];
			}
			else 
			{
				// good - now we can do something with it...
				err = [self processResult:values opCode:[bucket opCode]];
			}
		}	
        
		// cleanup...
		[parser release];
		[values release];
	}
	else
		err = [SBErrorHelper error:self message:[NSString stringWithFormat:@"The server returned HTTP '%d'.", bucket.statusCode]]; 
    
    // stop the wheel spinning...
	[SBServiceProxy stopSpinning];
    
	// done that bit - now send a notification...
	if(err == nil)
		[self requestOk:[bucket opCode]];
	else 
		[self requestFailed:[bucket opCode] error:err];
}

-(NSError *)processResult:(SBFlatXmlBucket *)values opCode:(int)theOpCode
{
	return [SBErrorHelper error:self message:@"processResult handler not implemented."];
}

-(void)requestOk:(int)theOpCode
{
	// no-op by default...
}

-(void)requestFailed:(int)theOpCode error:(NSError *)theError
{
	// show an error...
	[SBMessageBox showError:theError];
} 


@end
