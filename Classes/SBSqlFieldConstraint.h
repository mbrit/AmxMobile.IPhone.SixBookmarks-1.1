//
//  SBFieldConstraint.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBSqlConstraint.h"
#import "SBEntityField.h"

@interface SBSqlFieldConstraint : SBSqlConstraint {

    SBEntityField *field;
	NSObject *value;

}

@property (nonatomic, retain) SBEntityField *field;
@property (nonatomic, retain) NSObject *value;

-(id)initWithFieldAndValue:(SBEntityField *)theField value:(NSObject *)theValue;

@end
