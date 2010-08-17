//
//  SBApiService.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBRestServiceProxy.h"

@interface SBLogonCallback : NSObject
-(void)logonOk;
-(void)logonFailed:(NSError *)theError;
@end

@interface SBApiService : SBRestServiceProxy {

   	SBLogonCallback *callback;
    
}

@property (nonatomic, retain) SBLogonCallback *callback;

-(void)logon:(NSString *)apiPassword callback:(SBLogonCallback *)theCallback;

@end
