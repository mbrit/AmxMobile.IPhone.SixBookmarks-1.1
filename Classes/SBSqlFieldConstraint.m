//
//  SBFieldConstraint.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBSqlFieldConstraint.h"
#import "MyClasses.h"

@implementation SBSqlFieldConstraint

@synthesize field;
@synthesize value;

-(id)initWithFieldAndValue:(SBEntityField *)theField value:(NSObject *)theValue
{
	if(self = [super init])
	{
		self.field = theField;
		self.value = theValue;
	}
	
	// return...
	return self;
}

-(void)append:(NSMutableString *)builder statement:(SBSqlStatement *)theStatement
{
	[builder appendString:[[self field] nativeName]];
	[builder appendString:@"=?"];
	
	// arg...
	[theStatement addParameter:[self value]];
}

-(void)dealloc
{
	[value release];
	[field release];
	[super dealloc];
}

@end
