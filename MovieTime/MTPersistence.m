//
//  MTPersistence.m
//  MovieTime
//
//  Created by Bruno Tagliani on 5/6/12.
//  Copyright (c) 2012 SmartCode. All rights reserved.
//

#import "MTPersistence.h"
#import <sqlite3.h>
#import "MTMovie.h"

#define kFilename    @"data.sqlite3"

@implementation MTPersistence

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:kFilename];
}

- (NSArray *)dataLoad
{
	// Do any additional setup after loading the view, typically from a nib.
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    
    // Useful C trivia: If two inline strings are separated by nothing
    // but whitespace (including line breaks), they are concatenated into
    // a single string:
    NSString *createSQL = @"CREATE TABLE IF NOT EXISTS movies (id INTEGER PRIMARY KEY, title TEXT, alt_name TEXT, url TEXT, subs INTEGER, sources INTEGER, image BLOB, description TEXT, cast TEXT, genre TEXT, lang TEXT, duration INTEGER, year INTEGER);";
    char *errorMsg;
    if (sqlite3_exec (database, [createSQL UTF8String],
                      NULL, NULL, &errorMsg) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Error creating table: %s", errorMsg);
    }
    NSString *query = @"SELECT ALL FROM movies ORDER BY title";
    sqlite3_stmt *statement;
    NSMutableArray *moviesArray = [[NSMutableArray alloc] init];
    if (sqlite3_prepare_v2(database, [query UTF8String],
                           -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            int movieID = sqlite3_column_int(statement, 0);
            NSString *titulo = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            NSString *alt_name = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
            NSString *url = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            int subs = sqlite3_column_int(statement, 4);
            int sources = sqlite3_column_int(statement, 5);
            const char *raw = sqlite3_column_blob(statement, 6);
            int rawLen = sqlite3_column_bytes(statement, 6);
            NSData *imageData = [NSData dataWithBytes:raw length:rawLen];
            UIImage *moviePoster = [[UIImage alloc] initWithData:imageData];
            NSString *description = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
            NSString *cast = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
            NSString *genre = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 9)];
            NSString *lang = [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 10)];
            int duration = sqlite3_column_int(statement, 11);
            int year = sqlite3_column_int(statement, 12);
            MTMovie *movieToAdd = [[MTMovie alloc] initWithTitle:titulo url:url description:description cast:cast director:nil genre:genre lang:lang duration:duration year:year];
            [moviesArray addObject:movieToAdd];
        }
        sqlite3_finalize(statement);
    }
    sqlite3_close(database);
    
    UIApplication *app = [UIApplication sharedApplication];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:app];
    return [moviesArray copy];
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database)
        != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(0, @"Failed to open database");
    }
    for (int i = 1; i <= 4; i++) {
        NSString *fieldName = [[NSString alloc]
                               initWithFormat:@"field%d", i];
        UITextField *field = [self valueForKey:fieldName];
        
        // Once again, inline string concatenation to the rescue:
        char *update = "INSERT OR REPLACE INTO FIELDS (ROW, FIELD_DATA) "
        "VALUES (?, ?);";
        char *errorMsg;
        sqlite3_stmt *stmt;
        if (sqlite3_prepare_v2(database, update, -1, &stmt, nil)
            == SQLITE_OK) {
            sqlite3_bind_int(stmt, 1, i);
            sqlite3_bind_text(stmt, 2, [field.text UTF8String], -1, NULL);
        }
        if (sqlite3_step(stmt) != SQLITE_DONE)
            NSAssert(0, @"Error updating table: %s", errorMsg);
        sqlite3_finalize(stmt);
        
    }
    sqlite3_close(database);
}

@end
