//
//  SBDownloadBucket.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBDownloadBucket.h"
#import "MyClasses.h"

@implementation SBDownloadBucket

@synthesize data;
@synthesize callback;
@synthesize opCode;
@synthesize statusCode;

-(id)initWithCallback:(SBDownloadCallback *)theCallback opCode:(int)theOpCode;
{
	// set...
	if(self = [super init])
	{
		self.callback = theCallback;
		self.opCode = theOpCode;		
		self.data = [NSMutableData data];
	}
	
	// return...
	return self;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
	// what did we get?
	if([response isKindOfClass:[NSHTTPURLResponse class]])
		self.statusCode = [(NSHTTPURLResponse *)response statusCode];
	
	// ensure out bucket is clear...
	[data setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)theData
{
    // append the data that we got...
    [data appendData:theData];
}

-(NSString *)dataAsString
{
	return [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] autorelease];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	// log it...
	NSLog(@"%@", self.dataAsString);
	
	// callback...
	[callback downloadComplete:self];
}

@end
