//
//  SBSyncWorkItem.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 13/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBODataServiceProxy.h"

@interface SBSyncWorkItem : NSObject {

    SBEntity *entity;
	int serverId;
	SBODataOperation mode;

}

@property (nonatomic, retain) SBEntity *entity;
@property (assign) int serverId;
@property (assign) SBODataOperation mode;

-(id)initWithData:(SBEntity *)theEntity serverId:(int)theServerId mode:(SBODataOperation)theMode;

@end
