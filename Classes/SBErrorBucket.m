//
//  SBErrorBucket.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBErrorBucket.h"
#import "MyClasses.h"

@implementation SBErrorBucket

@synthesize errors;

-(id)init
{
	if(self = [super init])
	{
		self.errors = [NSMutableArray array];
	}
	
	// return...
	return self;
}

-(void)addError:(NSString *)error
{
	[self.errors addObject:error];
}

-(BOOL)hasErrors
{
	if(self.errors.count > 0)
		return TRUE;
	else
		return FALSE;
}

-(NSString *)errorsAsString
{
	NSMutableString * builder = [NSMutableString string];
	for(NSString *error in self.errors)
	{
		if([builder length] > 0)
			[builder appendString:@"\n"];
		[builder appendString:error];
	}
	
	// return...
	return builder;
}

-(void)dealloc
{
	[errors release];
	[super dealloc];
}

@end
