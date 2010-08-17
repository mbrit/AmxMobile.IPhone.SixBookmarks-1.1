//
//  SBUsersService.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBRestServiceProxy.h"

@class SBLogonCallback;

@interface SBUsersService : SBRestServiceProxy {

    SBLogonCallback *callback;
	NSString *username;
	NSString *password;
    
}

@property (nonatomic, retain) SBLogonCallback *callback;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;

-(void)logon:(NSString *)username  password:(NSString *)thePassword callback:(SBLogonCallback *)theCallback;
-(void)doLogon;

@end
