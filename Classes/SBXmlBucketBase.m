//
//  SBXmlBucketBase.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBXmlBucketBase.h"


@implementation SBXmlBucketBase

@synthesize builder;

-(id)init
{
	if(self = [super init])
	{
		[self resetBuilder];
	}
	
	// return...
	return self;
}

-(void)resetBuilder
{
	[self setBuilder:[NSMutableString string]];
}

-(NSString *)trimmedBuilder
{
	NSString *trimmed = [[self builder] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return trimmed;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)buf
{
	// store it...
	[builder appendString:buf];
}

-(void)dealloc
{
	[builder release];
	[super dealloc];
}

@end
