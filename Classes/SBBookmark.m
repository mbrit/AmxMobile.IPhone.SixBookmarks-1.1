//
//  SBBookmark.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBBookmark.h"
#import "MyClasses.h"

@implementation SBBookmark

NSString *const BOOKMARK_IDKEY = @"BookmarkId";
NSString *const BOOKMARK_ORDINALKEY = @"Ordinal";
NSString *const BOOKMARK_NAMEKEY = @"Name";
NSString *const BOOKMARK_URLKEY = @"Url";
NSString *const BOOKMARK_LOCALMODIFIEDKEY = @"LocalModified";
NSString *const BOOKMARK_LOCALDELETEDKEY = @"LocalDeleted";

-(int)bookmarkId
{
	return [self getInt32ValueByName:BOOKMARK_IDKEY];
}

-(void)setBookmarkId:(int)theBookmarkId
{
	[self setValueByName:BOOKMARK_IDKEY value:[NSNumber numberWithInt:theBookmarkId] reason:SBESRUserSet];
}

-(int)ordinal
{
	return [self getInt32ValueByName:BOOKMARK_ORDINALKEY];
}

-(void)setOrdinal:(int)theOrdinal
{
	[self setValueByName:BOOKMARK_ORDINALKEY value:[NSNumber numberWithInt:theOrdinal] reason:SBESRUserSet];
}

-(NSString *)name
{
	return [self getStringValueByName:BOOKMARK_NAMEKEY];
}

-(void)setName:(NSString *)theName
{
	[self setValueByName:BOOKMARK_NAMEKEY value:theName reason:SBESRUserSet];
}

-(NSString *)url
{
	return [self getStringValueByName:BOOKMARK_URLKEY];
}

-(void)setUrl:(NSString *)theUrl
{
	[self setValueByName:BOOKMARK_URLKEY value:theUrl reason:SBESRUserSet];
}

-(BOOL)localModified
{
	return [self getBooleanValueByName:BOOKMARK_LOCALMODIFIEDKEY];
}

-(void)setLocalModified:(BOOL)theLocalModified
{
	[self setValueByName:BOOKMARK_LOCALMODIFIEDKEY value:[NSNumber numberWithBool:theLocalModified] reason:SBESRUserSet];
}

-(BOOL)localDeleted
{
	return [self getBooleanValueByName:BOOKMARK_LOCALDELETEDKEY];
}

-(void)setLocalDeleted:(BOOL)theLocalDeleted
{
	[self setValueByName:BOOKMARK_LOCALDELETEDKEY value:[NSNumber numberWithBool:theLocalDeleted] reason:SBESRUserSet];
}

-(NSComparisonResult)ordinalComparer:(id)otherObject
{
	SBBookmark *other = (SBBookmark *)otherObject;
	if(self.ordinal < other.ordinal)
		return NSOrderedAscending;
	else if(self.ordinal > other.ordinal)
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

+(void)deleteAll
{
	SBDBHelper *db = [[SBRuntime current] getDatabase];
	
	// check...
	SBEntityType *et = [SBEntityType getEntityType:[SBBookmark class]];
	[db ensureTableExists:et];
	
	// run...
	SBSqlStatement *sql = [[SBSqlStatement alloc] initWithCommandText:@"delete from bookmark"];
	[db execNonQuery:sql];
	[sql release];
	[db release];
}

+(NSError *)getBookmarksForDisplay:(NSMutableArray **)theBookmarks
{
	SBSqlFilter *filter = [[SBSqlFilter alloc] initWithType:[SBBookmark class]];
	[filter.constraints addObject:[[SBSqlFieldConstraint alloc] initWithFieldAndValue:[filter.entityType getField:@"localdeleted"]
                                                                                value:[NSNumber numberWithBool:FALSE]]];
	
	// return...
	NSError *err = [filter executeEntityCollection:theBookmarks];
	[filter release];
	return err;
}

+(NSError *)getByOrdinal:(int)theOrdinal bookmark:(SBBookmark **)theBookmark
{
	SBSqlFilter *filter = [[SBSqlFilter alloc] initWithType:[SBBookmark class]];
	[filter.constraints addObject:[[SBSqlFieldConstraint alloc] initWithFieldAndValue:[filter.entityType getField:@"ordinal"]
																				value:[NSNumber numberWithInt:theOrdinal]]];
	[filter.constraints addObject:[[SBSqlFieldConstraint alloc] initWithFieldAndValue:[filter.entityType getField:@"localdeleted"]
																				value:[NSNumber numberWithBool:FALSE]]];
	
	// return...
	NSError *err = [filter executeEntity:theBookmark];
	[filter release];
	return err;
}

+(NSError *)getBookmarksForServerUpdate:(NSMutableArray **)theBookmarks
{
	SBSqlFilter *filter = [[SBSqlFilter alloc] initWithType:[SBBookmark class]];
	[filter.constraints addObject:[[SBSqlFieldConstraint alloc] initWithFieldAndValue:[filter.entityType getField:@"localmodified"]
																				value:[NSNumber numberWithBool:TRUE]]];
	[filter.constraints addObject:[[SBSqlFieldConstraint alloc] initWithFieldAndValue:[filter.entityType getField:@"localdeleted"]
																				value:[NSNumber numberWithBool:FALSE]]];
	// return...
	NSError *err = [filter executeEntityCollection:theBookmarks];
	[filter release];
	return err;
}

+(NSError *)getBookmarksForServerDelete:(NSMutableArray **)theBookmarks
{
	SBSqlFilter *filter = [[SBSqlFilter alloc] initWithType:[SBBookmark class]];
	[filter.constraints addObject:[[SBSqlFieldConstraint alloc] initWithFieldAndValue:[filter.entityType getField:@"localdeleted"]
																				value:[NSNumber numberWithBool:TRUE]]];
	// return...
	NSError *err = [filter executeEntityCollection:theBookmarks];
	[filter release];
	return err;
}

@end
