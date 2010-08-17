//
//  SBEntityXmlBucket.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBEntityType.h"
#import "SBXmlBucketBase.h"

typedef enum 
{
	SBERMNone = 0,
	SBERMEntry = 1
	
} SBEntityReadMode;

@interface SBEntityXmlBucket : SBXmlBucketBase {

    SBEntityType *entityType;
	NSMutableDictionary *values;
	NSMutableArray *entities;
	SBEntityReadMode mode;

}

@property (nonatomic, retain) SBEntityType *entityType;
@property (nonatomic, retain) NSMutableDictionary *values;
@property (nonatomic, retain) NSMutableArray *entities;
@property (assign) SBEntityReadMode mode;

// constructor...
-(id)initWithEntityType:(SBEntityType *)et;

// ns...
+(NSString *)atomNamespace;
+(NSString *)msDataNamespace;
+(NSString *)msMetadataNamespace;

// parser...
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
 namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName
   attributes:(NSDictionary *)attributeDict;
-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI 
qualifiedName:(NSString *)qName;

@end
