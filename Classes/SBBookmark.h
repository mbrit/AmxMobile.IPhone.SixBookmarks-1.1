//
//  SBBookmark.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBEntity.h"

extern NSString * const BOOKMARK_IDKEY;
extern NSString * const BOOKMARK_ORDINALKEY;
extern NSString * const BOOKMARK_NAMEKEY;
extern NSString * const BOOKMARK_URLKEY;
extern NSString * const BOOKMARK_LOCALMODIFIEDKEY;
extern NSString * const BOOKMARK_LOCALDELETEDKEY;

@interface SBBookmark : SBEntity {

}

-(int)bookmarkId;
-(void)setBookmarkId:(int)theBookmarkId;

-(int)ordinal;
-(void)setOrdinal:(int)theOrdinal;

-(NSString *)name;
-(void)setName:(NSString *)theName;

-(NSString *)url;
-(void)setUrl:(NSString *)theUrl;

-(BOOL)localModified;
-(void)setLocalModified:(BOOL)theLocalModified;

-(BOOL)localDeleted;
-(void)setLocalDeleted:(BOOL)theLocalDeleted;

+(void)deleteAll;
+(NSError *)getBookmarksForDisplay:(NSMutableArray **)theBookmarks;
+(NSError *)getByOrdinal:(int)theOrdinal bookmark:(SBBookmark **)theBookmark;
+(NSError *)getBookmarksForServerUpdate:(NSMutableArray **)theBookmarks;
+(NSError *)getBookmarksForServerDelete:(NSMutableArray **)theBookmarks;

@end
