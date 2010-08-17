//
//  SBXmlBucketBase.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBXmlBucketBase : NSObject {

    	NSMutableString *builder;
    
}

@property (nonatomic, retain) NSMutableString *builder;

-(void)resetBuilder;
-(NSString *)trimmedBuilder;

@end
