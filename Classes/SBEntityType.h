//
//  SBEntityType.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBEntityItem.h"
#import "SBEntityField.h"

@class SBEntity;

@interface SBEntityType : SBEntityItem {

    Class instanceType;
	NSMutableArray *fields;	
    
}

@property (assign) Class instanceType;
@property (nonatomic, retain) NSMutableArray *fields;

+(NSMutableDictionary *)entityTypes;

-(id)initWithInstanceTypeNativeName:(Class)theInstanceType nativeName:(NSString *)theNativeName;

+(void)registerEntityType:(SBEntityType *)et;
+(SBEntityType *)getEntityType:(Class)theClass;

-(SBEntityField *)addField:(NSString *)name nativeName:(NSString *)theNativeName type:(SBDataType)theType size:(int)theSize;

-(SBEntity *)createInstance;

-(SBEntityField *)getField:(NSString *)theName;
-(SBEntityField *)getKeyField;
-(BOOL)isField:(NSString *)theName;

@end
