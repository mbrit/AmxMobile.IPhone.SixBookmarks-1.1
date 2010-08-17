//
//  SBFlatXmlBucket.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBFlatXmlBucket.h"
#import "MyClasses.h"

@implementation SBFlatXmlBucket

@synthesize rootName;
@synthesize values;

-(id)init
{
	if(self = [super init])
	{
		// set...
		self.values = [NSMutableDictionary dictionary];
	}
	
	// return...
	return self;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
   attributes:(NSDictionary *)attributeDict 
{
	NSLog(@"Processing Element: %@", elementName);
	
	// do we have a root?
	if(rootName == nil)
		[self setRootName:elementName];
	
	// reset the string builder...
	[self resetBuilder];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName
{
	// the value in the string builder needs to be stored...
	[values setValue:[self trimmedBuilder] forKey:elementName];
	[self resetBuilder];
}

-(NSString*)getStringValue:(NSString *)name
{
	return [values objectForKey:name];
}

-(BOOL)getBooleanValue:(NSString *)name
{
	NSString *buf = [self getStringValue:name];
	if(buf == nil || [buf length] == 0 || [buf isEqualToString:@"0"])
		return FALSE;
	else
		return TRUE;
}

-(void)dealloc
{
	[rootName release];
	[values release];
	[super dealloc];
}

@end
