//
//  SBEntityChangeProcessor.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBEntity.h"

@interface SBEntityChangeProcessor : NSObject {

    SBEntityType *entityType;
    
}

@property (nonatomic, retain) SBEntityType *entityType;

-(id)initWithEntityType:(SBEntityType *)et;

-(void)saveChanges:(SBEntity *)entity;

-(void)insert:(SBEntity *)entity;
-(void)update:(SBEntity *)entity;
-(void)delete:(SBEntity *)entity;

@end
