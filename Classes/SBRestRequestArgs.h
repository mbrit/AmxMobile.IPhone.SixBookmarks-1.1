//
//  SBRestRequestArgs.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBRestRequestArgs : NSObject {

    	NSMutableDictionary *args;
    
}

@property (nonatomic, retain) NSMutableDictionary *args;

-(id)initWithOperation:(NSString*)theOperation;
-(void) setValue:(id)value forKey:(NSString *)key;

@end
