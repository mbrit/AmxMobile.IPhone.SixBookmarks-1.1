//
//  SBDBHelper.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBDBHelper.h"
#import "MyClasses.h"

@implementation SBDBHelper

@synthesize db;
@synthesize initError;
@synthesize theLastError;
@synthesize lastErrorMessage;

static NSMutableArray *loadMap;

-(id)initWithDatabaseName:(NSString *)dbName
{
	if(self = [super init])
	{
        // find the path...
		NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES); 
		NSString* documentsFolder = [paths objectAtIndex:0];
		NSString* filePath = [documentsFolder stringByAppendingPathComponent:dbName];
		NSLog(@"Database path: %@", filePath);
        
		// create the database...
		sqlite3 *theDb = nil;
		int result = sqlite3_open([filePath UTF8String], &theDb);
		if(result == SQLITE_OK)
			self.db = theDb;
		
		// clear...
		[self setLastError:result];
		self.initError = result;
	}
	
	// return...
	return self;
}

-(void)setLastError:(int)theError
{
	[self setLastErrorWithMessage:theError message:nil];
}

-(void)setLastErrorWithMessage:(int)error message:(NSString *)theMessage
{
	self.theLastError = error;
	self.lastErrorMessage = theMessage;
}

-(NSError *)getLastError
{
	// do we have a database?
	if(db == nil)
		return [SBErrorHelper error:self message:[NSString stringWithFormat:@"Database creation failed with code '%d'.", self.initError]];
	else if(theLastError != SQLITE_OK)
	{
		if([self lastErrorMessage] != nil)
			return [SBErrorHelper error:self message:[NSString stringWithFormat:@"Last error was '%d', with message '%@'.", theLastError, self.lastErrorMessage]];		
		else
			return [SBErrorHelper error:self message:[NSString stringWithFormat:@"Last error '%d'.  (No error provided.)", theLastError]];		
	}
	else
		return nil;
}

-(SBSqlStatement *)getCreateScript:(SBEntityType *)et
{
	// builder...
	NSMutableString *builder = [NSMutableString string];
	[builder appendString:@"CREATE TABLE IF NOT EXISTS "];
	[builder appendString:[et nativeName]];
	[builder appendString:@" ("];
	
	// walk the fields...
	BOOL first = TRUE;
	for(SBEntityField *field in [et fields])
	{
		if(first)
			first = FALSE;
		else
			[builder appendString:@", "];
		
		// snippet...
		[self appendCreateSnippet:builder field:field]; 
	}
	
	// end...
	[builder appendString:@")"];
	
	// return...
	SBSqlStatement *sql = [[SBSqlStatement alloc] initWithCommandText:builder];
	return sql;
}

-(void)appendCreateSnippet:(NSMutableString *)builder field:(SBEntityField *)theField
{
	[builder appendString:[theField nativeName]];
	[builder appendString:@" "];
	
	// type...
	SBDataType type = theField.type;
	if(type == SBDT_STRING)
	{
		[builder appendString:@"varchar("];
		[builder appendFormat:@"%d", theField.size];
		[builder appendString:@")"];
	}
	else if(type == SBDT_INT32)
	{
		[builder appendString:@"integer"];
		
		// key?
		if(theField.isKey)
			[builder appendString:@" primary key autoincrement"];
	}
	else
		@throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"Cannot handle '%d'.", type, nil] userInfo:nil];
}

+(NSMutableArray *)loadMap
{
	if(loadMap == nil)
	{
		// create one, and manage the memory…
		loadMap = [NSMutableArray array];
		[loadMap retain];
	}
	return loadMap;
}

-(void)ensureTableExists:(SBEntityType *)et
{
	// have we already done this one?
	if([[SBDBHelper loadMap] containsObject:et])
		return;
	
	// get create script...
	SBSqlStatement *sql = [self getCreateScript:et];
    [self execNonQuery:sql];
	[sql release];
	
	// set...
	[[SBDBHelper loadMap] addObject:et];
}

-(void)handleResult:(int)result
{
	self.theLastError = result;
	if(result != SQLITE_OK)
	{
		const char *cError = sqlite3_errmsg(self.db);
		if(cError != nil)
		{
			NSString *buf = [NSString stringWithCString:cError encoding:NSUTF8StringEncoding];
			self.lastErrorMessage = buf;
		}
		else
			self.lastErrorMessage = nil;
	}
	else
		self.lastErrorMessage = nil;
}

-(BOOL)execNonQuery:(SBSqlStatement *)sql
{
	// check that we have a database...
	if(self.db == nil)
		return FALSE;
	
	// expand the statement...
	const char *sqlString = [sql.commandText UTF8String];
	
	// prep...
	sqlite3_stmt *statement = nil;
	int result = sqlite3_prepare_v2(self.db, sqlString, -1, &statement, nil);
	if(result == SQLITE_OK)
	{	
		// bind...
		result = [self bindParams:statement statement:sql];
		if(result == SQLITE_OK)
		{		
			// actually run it...
			result = sqlite3_step(statement);
			
			// did we do ok?  fudge it so that we don't have to worry about it in the next bit...
			if(result == SQLITE_DONE)
				result = SQLITE_OK;
		}
	}
	
	// set the last error...
	[self handleResult:result];
	
	// release...
	if(statement != nil)
		sqlite3_finalize(statement);
	
	// return...
	if(result == SQLITE_OK)
		return TRUE;
	else
		return FALSE;
}

-(BOOL)executeEntityCollection:(SBSqlStatement *)sql results:(NSMutableArray **)theResults
{
	// reset...
	*theResults = nil;
	
	// check that we have a database...
	if(db == nil)
		return FALSE;
	
	// set the entity type...
	SBEntityType *et = [sql entityType];
	if(et == nil)
		@throw [NSException exceptionWithName:[[self class] description] reason:@"The provided SQL statement did not have an entity type." userInfo:nil];

    // ensure...
	[self ensureTableExists:et];
	
	// expand the statement...
	const char *sqlString = [[sql commandText] UTF8String];
	NSLog(@"Executing: %s", sqlString);
	
	// create somewhere to put the results...
	NSMutableArray *results = [NSMutableArray array];

    // prep...
	sqlite3_stmt *statement = nil;
	int result = sqlite3_prepare_v2(db, sqlString, -1, &statement, nil);
	if(result == SQLITE_OK)
	{	
		result = [self bindParams:statement statement:sql];
		if(result == SQLITE_OK)
		{

            while(TRUE)
			{
				// step...
				result = sqlite3_step(statement);
				if(result == SQLITE_ROW)
				{
					// create an instance...
					SBEntity *entity = [et createInstance];
					
					// load the values out...
					NSArray *map = [sql selectMap];
					for(int index = 0; index < [map count]; index++)
					{
						SBEntityField *field = (SBEntityField *)[map objectAtIndex:index];
						int columnIndex = index;
						
						// get the value...
						NSObject *value = nil;
						SBDataType type = [field type];
						if(type == SBDT_STRING)
						{
							const char *cString = (const char *)sqlite3_column_text(statement, columnIndex);
							value = [NSString stringWithCString:cString encoding:NSUTF8StringEncoding];
						}
						else if(type == SBDT_INT32)
							value = [NSNumber numberWithInt:sqlite3_column_int(statement, columnIndex)];
						else
							@throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"Cannot handle '%d'.", type, nil] userInfo:nil];
						
                        // Once we have the value, we set the value on the entity and add it to the collection.
						// set (with a 'load' set reason)...
						[entity setValue:field value:value reason:SBESRLoad];
					}
					
					// add...
					[results addObject:entity];
				}
				else if(result == SQLITE_DONE)
				{
					// reset and stop...
					result = SQLITE_OK;
					break;
				}
				else
					break;
			}
		}
	}
	// set the last error...
	[self handleResult:result];
	
	// release...
	if(statement != nil)
		sqlite3_finalize(statement);
	
	// return...
	if(result == SQLITE_OK)
	{
		*theResults = results;
		return TRUE;
	}
	else
	{
		// trash the results and return nil...
		[results release];
		return FALSE;
	}
}

-(int)bindParams:(sqlite3_stmt *)statement statement:(SBSqlStatement *)sql
{
	int result = SQLITE_OK;
	
	// args...
	int index = 1; // param bindings are 1-based, not 0-based...
	for(NSObject *param in sql.params)
	{
		if([param isKindOfClass:[NSString class]])
			result = sqlite3_bind_text(statement, index, [((NSString*)param) UTF8String], -1, nil);
		else if([param isKindOfClass:[NSNumber class]])
		{
			int theInt = [((NSNumber*)param) intValue];
			result = sqlite3_bind_int(statement, index, theInt);
		}
		else
			@throw [NSException exceptionWithName:[[self class] description] reason:[NSString stringWithFormat:@"Cannot handle '%@'.", [[param class] description], nil] userInfo:nil];
		
		// did something go wrong?
		if(result != SQLITE_OK)
			break;
		
		// next...
		index++;
	}
	
	// handle the result...
	[self handleResult:result];
	
	// return...
	return result;
}

-(void)disposeDb
{
	// do we have one?
	if(self.db != nil)
	{
		sqlite3_close(self.db);
		self.db = nil;
	}
}

-(void)dealloc
{
	[self disposeDb];
	[super dealloc];
}

@end
