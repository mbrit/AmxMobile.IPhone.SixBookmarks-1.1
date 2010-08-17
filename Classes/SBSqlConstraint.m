//
//  SBSqlConstraint.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBSqlConstraint.h"

@implementation SBSqlConstraint

-(void)append:(NSMutableString *)builder statement:(SBSqlStatement *)theStatement
{
	@throw [NSException exceptionWithName:[[self class] description] reason:@"Not implemented." userInfo:nil];
}

@end
