//
//  SBErrorBucket.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBErrorBucket : NSObject {

    NSMutableArray *errors;	
    
}

@property (nonatomic, retain) NSMutableArray *errors;

-(void)addError:(NSString *)error;
-(BOOL)hasErrors;
-(NSString *)errorsAsString;

@end
