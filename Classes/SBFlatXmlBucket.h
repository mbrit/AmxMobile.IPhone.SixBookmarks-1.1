//
//  SBFlatXmlBucket.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBXmlBucketBase.h"

@interface SBFlatXmlBucket : SBXmlBucketBase {
	NSString *rootName;
	NSMutableDictionary *values;
}

@property (nonatomic, retain) NSString *rootName;
@property (nonatomic, retain) NSMutableDictionary *values;

// extraction...
-(NSString*)getStringValue:(NSString *)name;
-(BOOL)getBooleanValue:(NSString *)name;

@end
