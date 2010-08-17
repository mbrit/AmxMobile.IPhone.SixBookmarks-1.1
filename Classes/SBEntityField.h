//
//  SBEntityField.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBDataType.h"
#import "SBEntityItem.h"

@interface SBEntityField : SBEntityItem {

    SBDataType type;
	int size;
	BOOL isKey;
	BOOL isOnServer;
	int ordinal;

}

@property (assign) SBDataType type;
@property (assign) int size;
@property (assign) BOOL isKey;
@property (assign) BOOL isOnServer;
@property (assign) int ordinal;

-(id)initWithDetails:(NSString *)theName nativeName:(NSString *)theNativeName type:(SBDataType)theType size:(int)theSize ordinal:(int)theOrdinal;

@end
