//
//  SBSync.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBEntityXmlBucket.h"

@interface SBSyncCallback : NSObject
-(void)syncOk;
-(void)syncFailed:(NSError *)err;
@end

typedef enum
{
	SBSMGetLatest,
   	SBSMPushChanges
    
} SBSyncMode;

@interface SBSync : NSObject {

    SBSyncCallback *callback;
	SBSyncMode mode;
    NSMutableArray *updates;
    NSMutableArray *deletes;
    NSMutableArray *workItems;
    int workItemIndex;
    
}

@property (nonatomic, retain) SBSyncCallback *callback;
@property (assign) SBSyncMode mode;
@property (nonatomic, retain) NSMutableArray *updates;
@property (nonatomic, retain) NSMutableArray *deletes;
@property (nonatomic, retain) NSMutableArray *workItems;
@property (assign) int workItemIndex;

-(void)doSync:(SBSyncCallback *)theCallback;
-(void)getLatest;

-(void)processServerItemsForGetAll:(SBEntityXmlBucket *)entities;
-(void)receiveServerItemsForPushChanges:(SBEntityXmlBucket *)entities;
-(void)processWorkItems;

@end
