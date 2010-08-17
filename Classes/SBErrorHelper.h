//
//  SBErrorHelper.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBErrorHelper : NSObject {

}

+(NSError *)error:(NSObject *)caller message:(NSString *)theMessage;
+(NSString *)formatError:(NSError *)err;
+(NSError *)wrapError:(NSError *)theError caller:(NSObject *)theCaller message:(NSString *)theMessage;

@end
