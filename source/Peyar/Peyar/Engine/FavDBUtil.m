//
//  FavDBUtil.m
//  FMDB Test
//
//  Created by Kishore on 24/7/14.
//  Copyright (c) 2014 Kishorek. All rights reserved.
//

#import "FavDBUtil.h"
#import <sqlite3.h>
#import "FMDB.h"
#import "Peyar.h"

#define kDBName @"user_fav.db"
#define kDBVersion 1 // Always starts from 1 and keeps increasing and not decreasing

@interface FavDBUtil ()

@property (nonatomic, assign) NSInteger dbVersion;
@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation FavDBUtil

+(instancetype)util{
    static FavDBUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[FavDBUtil alloc] init];
    });
    return util;
}

-(id)init{
    self = [super init];
    if (self) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *docsPath = [paths objectAtIndex:0];
        NSString *path = [docsPath stringByAppendingPathComponent:kDBName];
        BOOL dbOpened = [self connectQueue:path];
        
        if (dbOpened) {
            [self checkForMigration];
        } else {
            NSAssert(YES, @"Database can not be opened. Fatal error");
        }
    }
    
    return self;
}

#pragma mark - Common DB Operations
- (BOOL)connect:(NSString *)path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        //The database is gone or not created yet. Set up table creation parameters here
        self.dbVersion = 0;
    }
    
    self.db = [FMDatabase databaseWithPath:path];
    if (![self.db open]) {
        return NO;
    }
    
    return YES;
}

-(BOOL) connectQueue:(NSString *) path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        //The database is gone or not created yet. Set up table creation parameters here
        self.dbVersion = 0;
    }
    
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    //TEMP
    return YES;
}

- (void)beginTransaction {
    
}

- (void)rollback {
    
}

- (void)commit {
    
}

#pragma mark - Migration related
-(void) checkForMigration {
    NSInteger cachedDBVersion = [[NSUserDefaults standardUserDefaults] integerForKey:@"com.dbVersion"];
    
    BOOL status = YES;
    if (cachedDBVersion == 0) {
        // First initialization
        status = [self createTables];
    } else if (cachedDBVersion < kDBVersion) {
        //Migrate db
        status = [self dropTables];
        if (status) {
            status = [self createTables];
        }
    } else {
        //Same version
    }
    
    //Do only if migration is successful
    if (status) {
        [self setDbVersion:kDBVersion];
    }
}

-(void)setDbVersion:(NSInteger)dbVersion {
    _dbVersion = dbVersion;
    
    [[NSUserDefaults standardUserDefaults] setInteger:dbVersion forKey:@"com.dbVersion"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(BOOL) dropTables {
    __block BOOL status;
    static NSString *creation = @"DROP TABLE favorites;";
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        status = [db executeStatements:creation];
    }];
    
    return status;
}

-(BOOL) createTables {
    __block BOOL status;
    static NSString *creation = @"CREATE TABLE favorites (id integer PRIMARY KEY AUTOINCREMENT NOT NULL,peyar_id integer, name char(128), gender integer, source char(128), prefix char(128));";
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        status = [db executeStatements:creation];
    }];
    
    return status;
}

-(void) moveContents {
    
}

#pragma mark - Custom methods

#pragma mark - Custom DB Operations

-(void) removeFavorite:(NSInteger) peyarId{
    NSString *query = [NSString stringWithFormat: @"DELETE FROM favorites WHERE peyar_id=%ld",peyarId];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:query];
    }];
}

-(BOOL) isFavorite:(NSInteger) peyarId{
    __block BOOL isFavorite = NO;
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"SELECT COUNT(*) FROM favorites WHERE peyar_id = %ld", peyarId]];
        while ([res next]) {
            isFavorite = ([res intForColumnIndex:0]>0);
        }
    }];
    
    return isFavorite;
}

-(void) saveFavorite:(Peyar *)peyar{
    
    NSString *query = [NSString stringWithFormat: @"INSERT INTO favorites(peyar_id, name, gender, source, prefix) VALUES(%ld,'%@',%ld, '%@', '%@');",peyar.peyarId, peyar.name, peyar.gender, peyar.source, peyar.prefix];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:query];
    }];
}

-(NSArray *) fetchFavorites{
    __block NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //
        FMResultSet *res = [db executeQuery:@"select peyar_id, name, gender, source, prefix from favorites"];
        while ([res next]) {
            //retrieve values for each record
            Peyar *peyar = [Peyar new];
            peyar.peyarId = [res intForColumnIndex:0];
            peyar.name = [res stringForColumnIndex:1];
            peyar.gender = [res intForColumnIndex:2];
            peyar.source = [res stringForColumnIndex:3];
            peyar.prefix = [res stringForColumnIndex:4];
            [resultList addObject:peyar];
        }
    }];
    
    
    return resultList;
}


/* Convenient methods */
-(NSString *) stringFromStatement:(sqlite3_stmt *) stmt andIndex:(int) index{
    return ((char *)sqlite3_column_text(stmt, index)) ? [NSString stringWithUTF8String:(char *)sqlite3_column_text(stmt, index)] : nil;
}

@end
