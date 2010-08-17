//
//  ODataServiceProxy.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBServiceProxy.h"
#import "SBEntityType.h"
#import "SBDownloadBucket.h"

@class SBEntityXmlBucket;

@interface SBODataFetchCallback : NSObject
-(void)odataFetchOk:(SBEntityXmlBucket *)bucket opCode:(int)theOpCode;
-(void)odataFetchFailed:(NSError *)err opCode:(int)theOpCode;
@end

typedef enum
{
	SBODOInsert = 0,
	SBODOUpdate = 1,
	SBODODelete = 2
	
} SBODataOperation;

@interface SBODataServiceProxy : SBServiceProxy {

    SBEntityType *entityType;
	SBODataFetchCallback *callback;

}

@property (nonatomic, retain) SBEntityType *entityType;
@property (nonatomic, retain) SBODataFetchCallback *callback;

-(id)initWithTypeAndServiceName:(Class)theType serviceName:(NSString *)theServiceName;

-(NSString *)getServiceUrl:(SBEntityType *)et;
-(void)getAll:(SBODataFetchCallback *)theCallback;

-(void)handleFetchAllComplete:(SBDownloadBucket *)bucket;

-(void)pushInsert:(SBEntity *)entity callback:(SBODataFetchCallback *)theCallback;
-(void)pushUpdate:(SBEntity *)entity serverId:(int)theServerId callback:(SBODataFetchCallback *)theCallback;
-(void)pushDelete:(SBEntity *)entity serverId:(int)theServerId callback:(SBODataFetchCallback *)theCallback;
-(NSString *)getEntityUrlForPush:(SBEntity *)theEntity serverId:(int)theServerId;
-(void)executeODataOperation:(SBODataOperation)opType url:(NSString*)theUrl xml:(NSString *)theXml callback:(SBODataFetchCallback *)theCallback;

@end
