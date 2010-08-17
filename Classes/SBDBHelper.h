//
//  SBDBHelper.h
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "SBEntityType.h"
#import "SBSqlStatement.h"

@interface SBDBHelper : NSObject {

    sqlite3 *db;
	int theLastError;
	int initError;
	NSString *lastErrorMessage;

}

@property (assign) sqlite3 *db;
@property (assign) int initError;
@property (assign) int theLastError;
@property (nonatomic, retain) NSString *lastErrorMessage;

+(NSMutableArray *)loadMap;

-(id)initWithDatabaseName:(NSString *)dbName;

-(void)setLastError:(int)theError;
-(void)setLastErrorWithMessage:(int)error message:(NSString *)theMessage;
-(NSError *)getLastError;

-(void)ensureTableExists:(SBEntityType *)et;

-(SBSqlStatement *)getCreateScript:(SBEntityType *)et;
-(void)appendCreateSnippet:(NSMutableString *)builder field:(SBEntityField *)theField;

-(BOOL)execNonQuery:(SBSqlStatement *)sql;
-(BOOL)executeEntityCollection:(SBSqlStatement *)sql results:(NSMutableArray **)theResults;

-(void)handleResult:(int)result;
-(int)bindParams:(sqlite3_stmt *)statement statement:(SBSqlStatement *)sql;

@end
