//
//  SBServiceProxy.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SBDownloadSettings.h"

typedef enum
{
	OPCODE_APILOGON = 1000,
    OPCODE_USERSLOGON = 2000,
	OPCODE_ODATAFETCHALL = 3000,
   	OPCODE_ODATACHANGE = 3001
	
} SBOpCodes;

extern const NSString *APIUSERNAME;
extern const NSString *APIPASSWORD;

@interface SBServiceProxy : NSObject {
	NSString *serviceName;
}

@property (nonatomic, retain) NSString *serviceName;

+(NSString *)token;
+(void)setToken:(NSString *)theToken;
+(BOOL)hasToken;

+(void)startSpinning;
+(void)stopSpinning;

-(id)initWithServiceName:(NSString *)theServiceName;

-(NSString *)resolvedServiceUrl;
-(SBDownloadSettings *)getDownloadSettings;

@end
