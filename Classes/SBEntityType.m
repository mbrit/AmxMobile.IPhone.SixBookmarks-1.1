//
//  SBEntityType.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBEntityType.h"
#import "MyClasses.h"

@implementation SBEntityType

@synthesize instanceType;
@synthesize fields;

static NSMutableDictionary *theEntityTypes = nil;

-(id)initWithInstanceTypeNativeName:(Class)theInstanceType nativeName:(NSString *)theNativeName;
{
	if(self = [super initWithNameAndNativeName:[theInstanceType description] nativeName:theNativeName])
	{
		// set...
		[self setInstanceType:theInstanceType];
		[self setFields:[NSMutableArray array]];
	}
	
	// return...
	return self;
}

-(SBEntityField *)addField:(NSString *)theName nativeName:(NSString *)theNativeName type:(SBDataType)theType size:(int)theSize
{
	// create a field...
	SBEntityField *field = [[SBEntityField alloc]initWithDetails:theName nativeName:theNativeName type:theType size:theSize ordinal:[fields count]];
	
	// store it...
	[fields addObject:field];
	
	// return it...
	return field;
}

-(SBEntity *)createInstance
{
	// create it using a generic method and then manually call init...
	SBEntity *newEntity = (SBEntity *)class_createInstance(self.instanceType);
	[newEntity init];
	
	// return...
	return newEntity;
}

-(SBEntityField *)getField:(NSString *)theName
{
	for(SBEntityField *field in [self fields])
	{
		NSComparisonResult result = [[field name] compare:theName options:NSCaseInsensitiveSearch];
		if(result == NSOrderedSame)
			return field;
	}
	
	// nope...
	@throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"A field with name '%@' was not found on '%@'.", theName, [self name]] userInfo:nil];
}

-(SBEntityField *)getKeyField
{
	for(SBEntityField *field in [self fields])
	{
		if([field isKey])
			return field;
	}
	
	// nope...
	@throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"A key field was not found on '%@'.", [self name]] userInfo:nil];
}

-(BOOL)isField:(NSString *)theName
{
	for(SBEntityField *field in [self fields])
	{
		NSComparisonResult result = [[field name] compare:theName options:NSCaseInsensitiveSearch];
		if(result == NSOrderedSame)
			return TRUE;		
	}
	
	// nope...
	return FALSE;
}

+(NSMutableDictionary *)entityTypes
{
	if(theEntityTypes == nil)
		theEntityTypes = [[NSMutableDictionary dictionary] retain];
	return theEntityTypes;
}

+(void)registerEntityType:(SBEntityType *)et
{
	[[self entityTypes] setValue:et forKey:[[et instanceType] description]];
}

+(SBEntityType *)getEntityType:(Class)theClass
{
	SBEntityType *et = [[self entityTypes] objectForKey:[theClass description]];
	if(et != nil)
		return et;
	else 
		@throw [NSException exceptionWithName:[[SBEntityType class] description] reason:[NSString stringWithFormat:@"Failed to get entity type for '%@'.", [theClass description]] userInfo:nil];
}

-(void)dealloc
{
	[instanceType release];
	[fields release];
	[super dealloc];
}

@end
