//
//  SBSqlConstraint.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBSqlStatement.h"

@interface SBSqlConstraint : NSObject {

}

-(void)append:(NSMutableString *)builder statement:(SBSqlStatement *)theStatement;

@end
