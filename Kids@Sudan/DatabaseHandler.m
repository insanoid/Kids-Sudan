				//
//  DatabaseHandler.m
//  Version 1.1
//
//  Created  on 9/11/08.
//  Copyright 2008. All rights reserved.
//

#import "DatabaseHandler.h"

@implementation DatabaseHandler
@synthesize delegate;
@synthesize dbh;
@synthesize dynamic;

// Map Related Queries
#define DEG2RAD(degrees) (degrees * 0.01745327) // degrees * pi over 180


- (id)initWithFile:(NSString *)dbFile {
	if ((self = [super init])) {
	
		NSString *paths = [[NSBundle mainBundle] resourcePath];
		NSString *path = [paths stringByAppendingPathComponent:dbFile];
		
		int result = sqlite3_open([path UTF8String], &dbh);
		if (result){
		
		} 
			
	
		NSAssert1(SQLITE_OK == result, NSLocalizedStringFromTable(@"Unable to open the sqlite database (%@).", @"Database", @""), [NSString stringWithUTF8String:sqlite3_errmsg(dbh)]);	
		self.dynamic = NO;
	}

	
	return self;	
}

- (id)initWithDynamicFile:(NSString *)dbFile {
	if ((self = [super init])) {
		
		NSArray *docPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *docDir = [docPaths objectAtIndex:0];
		NSString *docPath = [docDir stringByAppendingPathComponent:dbFile];
		
		NSFileManager *fileManager = [NSFileManager defaultManager];
		
		if (![fileManager fileExistsAtPath:docPath]) {

			NSString *origPaths = [[NSBundle mainBundle] resourcePath];
			NSString *origPath = [origPaths stringByAppendingPathComponent:dbFile];
		
			NSError *error;
			int success = [fileManager copyItemAtPath:origPath toPath:docPath error:&error];
			if (success) {
			
			}
			NSAssert1(success,@"Failed to copy database into dynamic location",error);
		}
		int result = sqlite3_open([docPath UTF8String], &dbh);
		if (result){ }
		
		NSAssert1(SQLITE_OK == result, NSLocalizedStringFromTable(@"Unable to open the sqlite database (%@).", @"Database", @""), [NSString stringWithUTF8String:sqlite3_errmsg(dbh)]);	
		self.dynamic = YES;
	}

//	sqlite3_create_function(dbh, "distance", 4, SQLITE_UTF8, NULL, distanceFunc, NULL, NULL);
	return self;	
}

// Users should never need to call prepare
 
- (sqlite3_stmt *)prepare:(NSString *)sql {
	

	const char *utfsql = [sql UTF8String];
	
	sqlite3_stmt *statement;
	
		if (sqlite3_prepare([self dbh],utfsql,-1,&statement,NULL) == SQLITE_OK) {
		return statement;
	} else {
		return 0;
	}
}

// Three ways to lookup results: for a variable number of responses, for a full row
// of responses, or for a singular bit of data

- (NSArray *)lookupAllForSQL:(NSString *)sql {
	sqlite3_stmt *statement;
	id result;
	NSMutableArray *thisArray = [NSMutableArray arrayWithCapacity:4];
	if ((statement = [self prepare:sql])) {
		while (sqlite3_step(statement) == SQLITE_ROW) {	
			NSMutableDictionary *thisDict = [NSMutableDictionary dictionaryWithCapacity:4];
			for (int i = 0 ; i < sqlite3_column_count(statement) ; i++) {
				if (sqlite3_column_decltype(statement,i) != NULL &&
					strcasecmp(sqlite3_column_decltype(statement,i),"Boolean") == 0) {
					result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement, i) == SQLITE_TEXT) {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
					result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
					result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];					
				} else {					
					if(sqlite3_column_text(statement,i)!=NULL)
						result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
					else {
						result = @"";
					}
				}
				if (result) {
					[thisDict setObject:result
								 forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
				}
			}
			[thisArray addObject:[NSDictionary dictionaryWithDictionary:thisDict]];
		}
	}
	sqlite3_finalize(statement);
	return thisArray;
}

- (NSDictionary *)lookupRowForSQL:(NSString *)sql {
	sqlite3_stmt *statement;
	id result;
	NSMutableDictionary *thisDict = [NSMutableDictionary dictionaryWithCapacity:4];
	if ((statement = [self prepare:sql])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {	
			for (int i = 0 ; i < sqlite3_column_count(statement) ; i++) {
				if (strcasecmp(sqlite3_column_decltype(statement,i),"Boolean") == 0) {
					result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement, i) == SQLITE_TEXT) {
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_INTEGER) {
					result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,i)];
				} else if (sqlite3_column_type(statement,i) == SQLITE_FLOAT) {
					result = [NSNumber numberWithFloat:(float)sqlite3_column_double(statement,i)];					
				} else {
					
					if(sqlite3_column_text(statement,i)!=NULL)
						result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,i)];
					else
						result = @"";
				}
				if (result) {
					[thisDict setObject:result
								 forKey:[NSString stringWithUTF8String:sqlite3_column_name(statement,i)]];
				}
			}
		}
	}
	sqlite3_finalize(statement);
	return thisDict;
}
	
- (id)lookupColForSQL:(NSString *)sql {
	
	sqlite3_stmt *statement;
	id result=0;
	if ((statement = [self prepare:sql])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {		
			if (strcasecmp(sqlite3_column_decltype(statement,0),"Boolean") == 0) {
				result = [NSNumber numberWithBool:(BOOL)sqlite3_column_int(statement,0)];
			} else if (sqlite3_column_type(statement, 0) == SQLITE_TEXT) {
				result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
			} else if (sqlite3_column_type(statement,0) == SQLITE_INTEGER) {
				result = [NSNumber numberWithInt:(int)sqlite3_column_int(statement,0)];
			} else if (sqlite3_column_type(statement,0) == SQLITE_FLOAT) {
				result = [NSNumber numberWithDouble:(double)sqlite3_column_double(statement,0)];					
			} else {
				if(sqlite3_column_text(statement,0)!=NULL)
					result = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,0)];
				else 
					result = @"";
				}
		}
	}
	sqlite3_finalize(statement);
	return result;
	
}

// Simple use of COUNTS, MAX, etc.

- (int)lookupCountWhere:(NSString *)where forTable:(NSString *)table {

	int tableCount = 0;
	NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM %@ WHERE %@",
					 table,where];    	
	sqlite3_stmt *statement;

	if ((statement = [self prepare:sql])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {		
			tableCount = sqlite3_column_int(statement,0);
		}
	}
	sqlite3_finalize(statement);
	return tableCount;
				
}

- (int)lookupMax:(NSString *)key Where:(NSString *)where forTable:(NSString *)table {
	
	int tableMax = 0;
	NSString *sql = [NSString stringWithFormat:@"SELECT MAX(%@) FROM %@ WHERE %@",
					 key,table,where];    	
	sqlite3_stmt *statement;
	if ((statement = [self prepare:sql])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {		
			tableMax = sqlite3_column_int(statement,0);
		}
	}
	sqlite3_finalize(statement);
	return tableMax;
	
}

- (int)lookupSum:(NSString *)key Where:(NSString *)where forTable:(NSString *)table {
	
	int tableSum = 0;
	NSString *sql = [NSString stringWithFormat:@"SELECT SUM(%@) FROM %@ WHERE %@",
					 key,table,where];    	
	sqlite3_stmt *statement;
	if ((statement = [self prepare:sql])) {
		if (sqlite3_step(statement) == SQLITE_ROW) {		
			tableSum = sqlite3_column_int(statement,0);
		}
	}
	sqlite3_finalize(statement);
	return tableSum;
	
}

// INSERTing and UPDATing

- (void)insertArray:(NSArray *)dbData forTable:(NSString *)table {

	NSMutableString *sql = [NSMutableString stringWithCapacity:16];
	[sql appendFormat:@"INSERT INTO %@ (",table];
	
	for (int i = 0 ; i < [dbData count] ; i++) {
		[sql appendFormat:@"%@",[[dbData objectAtIndex:i] objectForKey:@"key"]];
		if (i + 1 < [dbData count]) {
			[sql appendFormat:@", "];
		}
	}
	[sql appendFormat:@") VALUES("];
	for (int i = 0 ; i < [dbData count] ; i++) {
		if ([[[dbData objectAtIndex:i] objectForKey:@"value"] intValue]) {
			[sql appendFormat:@"%d",[[[dbData objectAtIndex:i] objectForKey:@"value"] intValue]];
		} else {
			[sql appendFormat:@"'%@'",[[dbData objectAtIndex:i] objectForKey:@"value"]];
		}
		if (i + 1 < [dbData count]) {
			[sql appendFormat:@", "];
		}
	}
	[sql appendFormat:@")"];
	 NSLog(@"QUERY EXECUTED: %@",sql);
	[self runDynamicSQL:sql forTable:table];
}

- (void)insertDictionary:(NSMutableDictionary *)dbData forTable:(NSString *)table {
	
	NSMutableString *sql = [NSMutableString stringWithCapacity:16];
	[sql appendFormat:@"INSERT INTO %@ (",table];

	NSArray *dataKeys = [dbData allKeys];
	for (int i = 0 ; i < [dataKeys count] ; i++) {
		[sql appendFormat:@"%@",[dataKeys objectAtIndex:i]];
		if (i + 1 < [dbData count]) {
			[sql appendFormat:@", "];
		}
	}

	[sql appendFormat:@") VALUES("];
	for (int i = 0 ; i < [dataKeys count] ; i++) {
		
		if ([[NSString stringWithFormat:@"%@",[dbData objectForKey:[dataKeys objectAtIndex:i]]] isEqualToString:@"<null>"]) {
			[sql appendString:@"''"];
		}else if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] intValue] || [[NSString stringWithFormat:@"%@",[dbData objectForKey:[dataKeys objectAtIndex:i]]] isEqualToString:@"0"]) {
			[sql appendFormat:@"'%@'",[dbData objectForKey:[dataKeys objectAtIndex:i]]];
		} else {
			
		
			
			[sql appendFormat:@"'%@'",[[dbData objectForKey:[dataKeys objectAtIndex:i]] stringByReplacingOccurrencesOfString:@"'" withString:@"''"]];
		}
		if (i + 1 < [dbData count]) {
			[sql appendFormat:@", "];
		}
	}

	[sql appendFormat:@")"];
    NSLog(@"QUERY EXECUTED: %@",sql);
	[self runDynamicSQL:sql forTable:table];
}

- (void)updateArray:(NSArray *)dbData forTable:(NSString *)table { 
	[self updateArray:dbData forTable:table where:NULL];
}

- (void)updateArray:(NSArray *)dbData forTable:(NSString *)table where:(NSString *)where {
	
	NSMutableString *sql = [NSMutableString stringWithCapacity:16];
	[sql appendFormat:@"UPDATE %@ SET ",table];
	
	for (int i = 0 ; i < [dbData count] ; i++) {
		if ([[[dbData objectAtIndex:i] objectForKey:@"value"] intValue]) {
			[sql appendFormat:@"%@=%@",
			 [[dbData objectAtIndex:i] objectForKey:@"key"],
			 [[dbData objectAtIndex:i] objectForKey:@"value"]];
		} else {
			[sql appendFormat:@"%@='%@'",
			 [[dbData objectAtIndex:i] objectForKey:@"key"],
			 [[dbData objectAtIndex:i] objectForKey:@"value"]];
		}		
		if (i + 1 < [dbData count]) {
			[sql appendFormat:@", "];
		}
	}
	if (where != NULL) {
		[sql appendFormat:@" WHERE %@",where];
	} else {
		[sql appendString:@" WHERE 1"];
	}		
	[self runDynamicSQL:sql forTable:table];
}

- (void)updateDictionary:(NSDictionary *)dbData forTable:(NSString *)table { 
	[self updateDictionary:dbData forTable:table where:NULL];
}

- (void)updateDictionary:(NSDictionary *)dbData forTable:(NSString *)table where:(NSString *)where {
	
	NSMutableString *sql = [NSMutableString stringWithCapacity:16];
	[sql appendFormat:@"UPDATE %@ SET ",table];

	NSArray *dataKeys = [dbData allKeys];
	for (int i = 0 ; i < [dataKeys count] ; i++) {
		if ([[dbData objectForKey:[dataKeys objectAtIndex:i]] intValue]) {
			[sql appendFormat:@"%@=%@",
			 [dataKeys objectAtIndex:i],
			 [dbData objectForKey:[dataKeys objectAtIndex:i]]];
		} else {
			[sql appendFormat:@"%@='%@'",
			 [dataKeys objectAtIndex:i],
			 [dbData objectForKey:[dataKeys objectAtIndex:i]]];
		}		
		if (i + 1 < [dbData count]) {
			[sql appendFormat:@", "];
		}
	}
	if (where != NULL) {
		[sql appendFormat:@" WHERE %@",where];
	}
	[self runDynamicSQL:sql forTable:table];
}

- (void)updateSQL:(NSString *)sql forTable:(NSString *)table {
	[self runDynamicSQL:sql forTable:table];
}

- (void)deleteWhere:(NSString *)where forTable:(NSString *)table {

	NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@",
					 table,where];
	[self runDynamicSQL:sql forTable:table];
}

// INSERT/UPDATE/DELETE Subroutines

- (BOOL)runDynamicSQL:(NSString *)sql forTable:(NSString *)table {

    NSLog(@"QUERY EXECUTED: %@",sql);
	int result;
	result = 0;
	NSAssert1(self.dynamic == 1,@"Tried to use a dynamic function on a static database",NULL);
	sqlite3_stmt *statement;
	if ((statement = [self prepare:sql])) {
		result = sqlite3_step(statement);
    }		
	sqlite3_finalize(statement);
	if (result) {
		if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(databaseTableWasUpdated:)]) {
			[delegate databaseTableWasUpdated:table];
		}	
		return YES;
	} else {
		return NO;
	}
	
}



// requirements for closing things down

- (void)dealloc {
	[self close];
	[delegate release];
	[super dealloc];
}

- (void)close {
	
	if (dbh) {
		sqlite3_close(dbh);
	}
}

@end
