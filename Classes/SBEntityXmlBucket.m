//
//  SBEntityXmlBucket.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBEntityXmlBucket.h"
#import "MyClasses.h"

@implementation SBEntityXmlBucket

@synthesize entityType;
@synthesize values;
@synthesize mode;
@synthesize entities;

NSString * const AtomNamespace = @"http://www.w3.org/2005/Atom";
NSString * const MsMetadataNamespace = @"http://schemas.microsoft.com/ado/2007/08/dataservices/metadata";
NSString * const MsDataNamespace = @"http://schemas.microsoft.com/ado/2007/08/dataservices";

-(id)initWithEntityType:(SBEntityType *)et
{
	if(self = [super init])
	{
		self.entityType = et;
		self.entities = [NSMutableArray array];
	}
	
	// return...
	return self;
}

+(NSString *)atomNamespace
{
    return AtomNamespace;
}

+(NSString *)msDataNamespace
{
    return MsDataNamespace;
}

+(NSString *)msMetadataNamespace
{
    return MsMetadataNamespace;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
   attributes:(NSDictionary *)attributeDict
{
	// what's our read mode?
	if(self.mode == SBERMNone)
	{
		// do we have an entity?
		if([namespaceURI isEqualToString:AtomNamespace] && [elementName isEqualToString:@"entry"])
		{
			// we're in an entry...
			if(values == nil)
			{
				self.values = [NSMutableDictionary dictionary];
				self.mode = SBERMEntry;
			}
		}
	}
	
	// reset the builder...
	[self resetBuilder];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName
{
	// did we get to the end of an entity...
	if(self.mode == SBERMEntry)
	{
		// is this the end of an entity?
		if([namespaceURI isEqualToString:AtomNamespace] && [elementName isEqualToString:@"entry"])
		{
			// patch it in...
			SBEntity *theEntity = [self.entityType createInstance];
			[theEntity populateFromValues:self.values];
			[self.entities addObject:theEntity];
			
			// clear it...
			[values removeAllObjects];
			self.values = nil;
			
			// none...
			self.mode = SBERMNone;
		}
		else if([namespaceURI isEqualToString:MsDataNamespace])
		{
			// add...
			[self.values setObject:self.trimmedBuilder forKey:elementName];
			[self resetBuilder];
		}
	}
}

-(void)dealloc
{
	[values release];
	[entities release];
	[entityType release];
	[super dealloc];
}

@end
