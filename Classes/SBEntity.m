//
//  SBEntity.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBEntity.h"
#import "MyClasses.h"

@implementation SBEntity

@synthesize entityType;
@synthesize values;
@synthesize flags;

static NSObject *theNullValue;

+(NSObject *)nullValue
{
	if(theNullValue == nil)
	{
		theNullValue = [NSObject alloc];
		[theNullValue retain];
	}
	return theNullValue;
}

-(id)init
{
	if(self = [super init])
	{
		// get...
		SBEntityType *et = [SBEntityType getEntityType:self.class];
		self.entityType = et;
		
		// setup...
		NSMutableArray *theValues = [NSMutableArray array];
		NSMutableArray *theFlags = [NSMutableArray array];
		for(int index = 0; index < entityType.fields.count; index++)
		{
			[theValues addObject:[SBEntity nullValue]];
			[theFlags addObject:[NSNumber numberWithInt:SBEFFNone]];
		}
		
		// set...
		self.values = theValues;
		self.flags = theFlags;
	}
	
	// return...
	return self;
}

-(void)setValueByName:(NSString *)name value:(NSObject *)theValue reason:(SBEntitySetReason)theReason
{
	SBEntityField *field = [self.entityType getField:name];
	[self setValue:field value:theValue reason:theReason];
}

-(void)setValue:(SBEntityField *)field value:(NSObject *)theValue reason:(SBEntitySetReason)theReason
{
	[self.values replaceObjectAtIndex:field.ordinal withObject:theValue];
	
	// flag...
	[self setFieldFlags:field flags:SBEFFLoaded setOn:TRUE];
	if(theReason == SBESRUserSet)
		[self setFieldFlags:field flags:SBEFFModified setOn:TRUE];		
}

-(void)setFieldFlags:(SBEntityField *)field flags:(SBEntityFieldFlags)theFlags setOn:(BOOL)doSetOn
{
	// get...
	int existing = [(NSNumber *)[self.flags objectAtIndex:field.ordinal] intValue];
	existing |= theFlags;
	if(!(doSetOn))
		existing ^= theFlags;
	
	// set...
	[self.flags replaceObjectAtIndex:field.ordinal withObject:[NSNumber numberWithInt:existing]];
}

-(BOOL)isFieldLoaded:(SBEntityField *)field
{
	return [self getFieldFlags:field flags:SBEFFLoaded];
}

-(BOOL)isFieldModified:(SBEntityField *)field
{
	return [self getFieldFlags:field flags:SBEFFModified];
}

-(BOOL)getFieldFlags:(SBEntityField *)field flags:(SBEntityFieldFlags)theFlags 
{
	int existing = [(NSNumber *)[self.flags objectAtIndex:field.ordinal] intValue];
	if((int)(existing & theFlags) != 0)
		return TRUE;
	else 
		return FALSE;
}

-(BOOL)isNew
{
	SBEntityField *keyField = [entityType getKeyField];
	
	// if...
	if([self getFieldFlags:keyField flags:SBEFFLoaded])
		return FALSE;
	else 
		return TRUE;
}

-(BOOL)isModified
{
	for(SBEntityField *field in [entityType fields])
	{
		if([self isFieldModified:field])
			return TRUE;
	}
	
	// nope...
	return FALSE;
}

-(BOOL)isDeleted
{
    // just say "no" for now - we'll sort this later...
	return FALSE;
}

-(NSObject *)getValue:(SBEntityField *)field
{
	return [self.values objectAtIndex:field.ordinal];
}

// <…> Needs declaration in header
-(NSObject *)getValueByName:(NSString *)name
{
	SBEntityField *field = [self.entityType getField:name];
	return [self getValue:field];
}

-(int)getInt32Value:(SBEntityField *)field
{
	NSObject *obj = [self.values objectAtIndex:field.ordinal];
	if(obj == nil || obj == [SBEntity nullValue])
		return 0;
	else if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber *num = (NSNumber *)obj;
		return [num intValue];
	}
	else
		@throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"An instance of '%@' could not be converted to a Boolean value.", [[obj class] description]] userInfo:nil];
}

-(int)getInt32ValueByName:(NSString *)name
{
	SBEntityField *field = [self.entityType getField:name];
	return [self getInt32Value:field];
}

-(BOOL)getBooleanValue:(SBEntityField *)field
{
	NSObject *obj = [self.values objectAtIndex:field.ordinal];
	if(obj == nil || obj == [SBEntity nullValue])
		return FALSE;
	else if([obj isKindOfClass:[NSNumber class]])
	{
		NSNumber *num = (NSNumber *)obj;
		return [num boolValue];
	}
	else
		@throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"An instance of '%@' could not be converted to a Boolean value.", [[obj class] description]] userInfo:nil];
}

-(BOOL)getBooleanValueByName:(NSString *)name
{
	SBEntityField *field = [self.entityType getField:name];
	return [self getBooleanValue:field];
}

-(NSString *)getStringValue:(SBEntityField *)field
{
	NSObject *obj = [self.values objectAtIndex:field.ordinal];
	if(obj == nil || obj == [SBEntity nullValue])
		return nil;
	else if([obj isKindOfClass:[NSString class]])
	{
		NSString *buf = (NSString *)obj;
		return buf;
	}
	else
		@throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"An instance of '%@' could not be converted to a Boolean value.", [[obj class] description]] userInfo:nil];
}

-(NSString *)getStringValueByName:(NSString *)name
{
	SBEntityField *field = [self.entityType getField:name];
	return [self getStringValue:field];
}

-(void)populateFromValues:(NSMutableDictionary *)theValues
{
	SBEntityType *et = [self entityType];
	for(NSString *name in theValues)
	{
		// do we support this field?
		if([et isField:name])
		{
			// find the field...
			SBEntityField *field = [et getField:name];
			
			// get...
			NSString *value = [theValues valueForKey:name];
			NSLog(@"Value: '%@'", value);
			
			// what to do...
			SBDataType type = [field type];
			if(type == SBDT_STRING)
				[self setValue:field value:value reason:SBESRLoad];
			else if(type == SBDT_INT32)
			{
				NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
				NSNumber *theNumber = [formatter numberFromString:value];
				[formatter release];
				[self setValue:field value:theNumber reason:SBESRLoad];
			}
			else
				@throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"Cannot handle '%d'.", type] userInfo:nil];
		}
	}
}

-(void)saveChanges
{
	SBEntityChangeProcessor *processor = [[SBEntityChangeProcessor alloc] initWithEntityType:[self entityType]];
	[processor saveChanges:self];
	[processor release];
}

-(void)dealloc
{
	[entityType release];
	[values release];
	[flags release];
	[super dealloc];
}

@end
