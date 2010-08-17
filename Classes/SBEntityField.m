//
//  SBEntityField.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBEntityField.h"


@implementation SBEntityField

@synthesize type;
@synthesize size;
@synthesize ordinal;
@synthesize isKey;
@synthesize isOnServer;

-(id)initWithDetails:(NSString *)theName nativeName:(NSString *)theNativeName type:(SBDataType)theType size:(int)theSize ordinal:(int)theOrdinal
{
	if(self = [super initWithNameAndNativeName:theName nativeName:theNativeName])
	{
		[self setType:theType];
		[self setSize:theSize];
		[self setOrdinal:theOrdinal];
		self.isOnServer = TRUE;
	}
	
	// return...
	return self;
}

@end
