//
//  SBSqlFilter.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBSqlStatement.h"
#import "SBEntityType.h"
#import "SBEntity.h"

@interface SBSqlFilter : NSObject {

    SBEntityType *entityType;
	NSMutableArray *constraints;

}

@property (nonatomic, retain) SBEntityType *entityType;
@property (nonatomic, retain) NSMutableArray *constraints;

-(id)initWithType:(Class)typeToDereference;
-(id)initWithEntityType:(SBEntityType *)et;

-(SBSqlStatement *)getSqlStatement;

-(NSError *)executeEntityCollection:(NSMutableArray **)theResults;
-(NSError *)executeEntity:(SBEntity **)theEntity;

@end
