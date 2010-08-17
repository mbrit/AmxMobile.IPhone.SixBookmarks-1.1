//
//  SBHttpHelper.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBHttpHelper.h"
#import "MyClasses.h"

@implementation SBHttpHelper


+(NSString *)buildQueryString:(NSDictionary *)theArgs
{
	NSMutableString *builder = [[NSMutableString alloc] init];
	bool first = true;
	for(NSString *name in theArgs)
	{
		if(first)
			first = false;
		else 
			[builder appendString:@"&"];
		
		[builder appendString:name];
		[builder appendString:@"="];
		[builder appendString:[theArgs objectForKey:name]];
	}
	
	// return...
	return builder;
}

+(NSString *)buildUrl:(NSString *)url args:(NSDictionary *)theArgs
{
	// trim the query string...
	NSRange range = [url rangeOfString:@"?"];
	if(range.length > 0)
		url = [url substringToIndex:range.location];
	
	// build...
	url = [NSString stringWithFormat:@"%@?%@", url, [self buildQueryString:theArgs]];
    
	// return...
	return url;
}

+(void)download:(NSString *)url settings:(SBDownloadSettings *)theSettings callback:(SBDownloadCallback *)theCallback opCode:(int)theOpCode
{
	// create a bucket...
	SBDownloadBucket *bucket = [[SBDownloadBucket alloc] initWithCallback:theCallback opCode:theOpCode];
	
	// run...
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
	
	// add the headers...
	for(NSString *name in theSettings.extraHeaders)
	{
		NSString * value = [theSettings.extraHeaders objectForKey:name];
		[request addValue:value forHTTPHeaderField:name];
	}
	
	// create the connection with the request and start loading the data…
    [NSURLConnection connectionWithRequest:request delegate:bucket];
}

@end
