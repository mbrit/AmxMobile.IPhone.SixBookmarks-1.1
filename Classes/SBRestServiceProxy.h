//
//  SBRestServiceProxy.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBServiceProxy.h"
#import "SBRestRequestArgs.h"
#import "SBFlatXmlBucket.h"

@interface SBRestServiceProxy : SBServiceProxy {

}

-(id)initWithServiceName:(NSString *)theServiceName;

-(void)makeRequest:(SBRestRequestArgs *)args opCode:(int)theOpCode;
-(NSError *)processResult:(SBFlatXmlBucket *)values opCode:(int)theOpCode;
-(void)requestOk:(int)theOpCode;
-(void)requestFailed:(int)theOpCode error:(NSError *)theError;

@end
