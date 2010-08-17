//
//  SBHttpHelper.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBDownloadSettings.h"

#import "SBDownloadSettings.h"

@class SBDownloadBucket;  // alternative forward declaration c.f. #import

@interface SBDownloadCallback : NSObject
-(void)downloadComplete:(SBDownloadBucket *)data;
@end

@interface SBHttpHelper : NSObject {

}

+(void)download:(NSString *)url settings:(SBDownloadSettings *)theSettings callback:(SBDownloadCallback *)theCallback opCode:(int)theOpCode;

+(NSString *)buildQueryString:(NSDictionary *)theArgs;

+(NSString *)buildUrl:(NSString *)url args:(NSDictionary *)theArgs;

@end
