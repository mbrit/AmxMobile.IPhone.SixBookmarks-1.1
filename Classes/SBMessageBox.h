//
//  SBMessageBox.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBMessageBox : NSObject {

}

+(void)show:(NSString *)message;
+(void)showError:(NSError *)err;

@end
