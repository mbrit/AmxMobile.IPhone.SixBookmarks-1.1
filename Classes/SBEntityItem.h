//
//  SBEntityItem.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBEntityItem : NSObject {

    NSString *name;
	NSString *nativeName;

}

@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *nativeName;

-(id)initWithNameAndNativeName:(NSString *)theName nativeName:(NSString *)theNativeName;

@end
