//
//  SBSqlFilter.m
//  SixBookmarks
//
//  Created by Matthew Baxter-Reynolds on 11/08/2010.
//  Copyright (c) 2010 AMX Software Ltd. All rights reserved.
//

#import "SBSqlFilter.h"
#import "MyClasses.h"

@implementation SBSqlFilter

@synthesize entityType;
@synthesize constraints;

-(id)initWithEntityType:(SBEntityType *)et
{
	if(self = [super init])
	{
		self.entityType = et;
		self.constraints = [NSMutableArray array];
	}
	
	// return...
	return self;
}

-(id)initWithType:(Class)typeToDereference
{
	SBEntityType *et = [SBEntityType getEntityType:typeToDereference];
	return [self initWithEntityType:et];
}

-(SBSqlStatement *)getSqlStatement
{
	SBEntityType *et = [self entityType];
	
	// create...
	NSMutableString *builder = [NSMutableString string];
	SBSqlStatement *sql = [[SBSqlStatement alloc] initWithEntityType:et];
	
	// walk...
	[builder appendString:@"SELECT "];
	BOOL first = true;
	for(SBEntityField *field in et.fields)
	{
		if(first)
			first = FALSE;
		else
			[builder appendString:@", "];
		
		// name...
		[builder appendString:field.nativeName];
		[sql addToSelectMap:field];
	}
	
	// table...
	[builder appendString:@" FROM "];
	[builder appendString:et.nativeName];
	
	// constraints...
	NSMutableArray *items = self.constraints;
	if(items.count > 0)
	{
		[builder appendString:@" WHERE "];
		first = TRUE;
		for(SBSqlConstraint *constraint in items)
		{
			if(first)
				first = FALSE;
			else
				[builder appendString:@" AND "];
			[constraint append:builder statement:sql];
		}
	}
	
	// return...
	sql.commandText = builder;
	return sql;
}

-(NSError *)executeEntityCollection:(NSMutableArray **)theResults;
{
	SBSqlStatement *sql = [self getSqlStatement];
	
	// run...
	SBDBHelper *db = [[SBRuntime current] getDatabase];
	NSError *err = nil;
	BOOL ok = [db executeEntityCollection:sql results:theResults];
	if(!(ok))
		err = [db getLastError];
	
	// cleanup...
	[sql release];
	[db release];
	
	// return...
	return err;
}

-(NSError *)executeEntity:(SBEntity **)theEntity
{
	// reset...
	*theEntity = nil;
	
	// run...
	NSMutableArray *entities = nil;
	NSError *err = [self executeEntityCollection:&entities];
	
	// get...
	if([entities count] > 0)
		*theEntity = [entities objectAtIndex:0];
	
	// return...
	return err;
}

-(void)dealloc
{
	[constraints release];
	[entityType release];
	[super dealloc];
}

@end
