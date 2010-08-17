//
//  SBEntity.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBEntityType.h"
#import "SBEntitySetReason.h"
#import "SBEntityFieldFlags.h"

@interface SBEntity : NSObject {

    SBEntityType *entityType;
	NSMutableArray *values;
	NSMutableArray *flags;

}

@property (nonatomic, retain) SBEntityType *entityType;
@property (nonatomic, retain) NSMutableArray *values;
@property (nonatomic, retain) NSMutableArray *flags;

-(void)setValueByName:(NSString *)name value:(NSObject *)theValue reason:(SBEntitySetReason)theReason;
-(void)setValue:(SBEntityField *)field value:(NSObject *)theValue reason:(SBEntitySetReason)theReason;
-(void)setFieldFlags:(SBEntityField *)field flags:(SBEntityFieldFlags)theFlags setOn:(BOOL)doSetOn;

-(BOOL)isFieldLoaded:(SBEntityField *)field;
-(BOOL)isFieldModified:(SBEntityField *)field;
-(BOOL)getFieldFlags:(SBEntityField *)field flags:(SBEntityFieldFlags)theFlags;

-(BOOL)isNew;
-(BOOL)isModified;
-(BOOL)isDeleted;

-(int)getInt32Value:(SBEntityField *)field;
-(int)getInt32ValueByName:(NSString *)name;
-(BOOL)getBooleanValue:(SBEntityField *)field;
-(BOOL)getBooleanValueByName:(NSString *)name;
-(NSString *)getStringValue:(SBEntityField *)field;
-(NSString *)getStringValueByName:(NSString *)name;

-(void)populateFromValues:(NSMutableDictionary *)theValues;

-(void)saveChanges;

@end
