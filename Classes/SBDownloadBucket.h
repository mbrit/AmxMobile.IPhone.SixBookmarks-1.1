//
//  SBDownloadBucket.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 10/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class SBDownloadCallback;

@interface SBDownloadBucket : NSObject {
	NSMutableData * data;
	SBDownloadCallback *callback;
	int opCode;
	int statusCode;
}

@property (nonatomic, retain) NSMutableData *data;
@property (nonatomic, retain) SBDownloadCallback *callback;
@property (assign) int opCode;
@property (assign) int statusCode;

-(id)initWithCallback:(SBDownloadCallback *)theCallback opCode:(int)theOpCode;

-(NSString *)dataAsString;

@end
