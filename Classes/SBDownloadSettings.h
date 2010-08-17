//
//  SBDownloadSettings.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBDownloadSettings : NSObject {

    	NSMutableDictionary *extraHeaders;
    
}

@property (nonatomic, retain) NSMutableDictionary *extraHeaders;

-(void)addHeader:(NSString *)value forName:(NSString *)name;

@end
