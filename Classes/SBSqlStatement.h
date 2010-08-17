//
//  SBSqlStatement.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBEntityType.h"

@interface SBSqlStatement : NSObject {

    NSString *commandText;
	NSMutableArray *params;
    NSMutableArray *selectMap;
    SBEntityType *entityType;
    
}

@property (nonatomic, retain) NSString *commandText;
@property (nonatomic, retain) NSMutableArray *params;
@property (nonatomic, retain) NSMutableArray *selectMap;
@property (nonatomic, retain) SBEntityType *entityType;

-(id)initWithCommandText:(NSString *)theCommandText;
-(id)initWithEntityType:(SBEntityType *)theEntityType;

-(void)addParameter:(NSObject *)value;
-(void)addToSelectMap:(SBEntityField *)field;

@end
