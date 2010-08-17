//
//  SBRuntime.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBDBHelper.h"

@interface SBRuntime : NSObject {

    NSString *username;
    
}

@property (nonatomic, retain) NSString *username;

+(SBRuntime *)current;

+(void)start;

-(void)showUrl:(NSString *)theUrl;
-(SBDBHelper *)getDatabase;

@end
