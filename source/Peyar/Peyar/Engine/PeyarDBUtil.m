//
//  FavDBUtil.m
//  FMDB Test
//
//  Created by Kishore on 24/7/14.
//  Copyright (c) 2014 Kishorek. All rights reserved.
//

#import "PeyarDBUtil.h"
#import <sqlite3.h>
#import "FMDB.h"
#import "Peyar.h"

#define kDBName @"peyar.db"

@interface PeyarDBUtil ()

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) FMDatabaseQueue *dbQueue;

@end

@implementation PeyarDBUtil

+(instancetype)util{
    static PeyarDBUtil *util;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        util = [[PeyarDBUtil alloc] init];
    });
    return util;
}

-(id)init{
    self = [super init];
    if (self) {
        NSString *docsPath = NSTemporaryDirectory();
        NSString *path = [docsPath stringByAppendingPathComponent:kDBName];
        BOOL dbOpened = [self connectQueue:path];
        
        if (!dbOpened) {
            NSAssert(YES, @"Database can not be opened. Fatal error");
        }
    }
    
    return self;
}

#pragma mark - Common DB Operations

-(BOOL) connectQueue:(NSString *) path {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:path]) {
        [self moveDB];
    }
    
    self.dbQueue = [FMDatabaseQueue databaseQueueWithPath:path];
    
    //TEMP
    return YES;
}

-(void) moveDB {
    NSString *docsPath = NSTemporaryDirectory();
    NSString *path = [docsPath stringByAppendingPathComponent:kDBName];
    
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:@"peyar" ofType:@"db"];
    
    NSError *error;
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm copyItemAtPath:resourcePath toPath:path error:&error];
}

#pragma mark - Custom DB Operations

-(NSArray *) listOfLettersWithGender:(NSInteger) gender{
    __block NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //
        FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"SELECT DISTINCT prefix from names where gender=%ld;", gender]];
        while ([res next]) {
            [resultList addObject: [res stringForColumnIndex:0]];
        }
    }];
    
    return resultList;
}

-(NSArray *) listOfNamesWithGender:(NSInteger) gender withStarting:(NSString *) prefix{
    __block NSMutableArray *resultList = [[NSMutableArray alloc] init];
    
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        //
        FMResultSet *res = [db executeQuery:[NSString stringWithFormat:@"SELECT id, name, meaning, gender, source, prefix FROM names WHERE gender=%ld AND prefix = '%@';", gender, prefix]];
        while ([res next]) {
            Peyar *peyar = [Peyar new];
            peyar.peyarId = [res intForColumnIndex:0];
            peyar.name = [res stringForColumnIndex:1];
            peyar.meaning = [res stringForColumnIndex:2];
            peyar.gender = [res intForColumnIndex:3];
            peyar.source = [res stringForColumnIndex:4];
            peyar.prefix = [res stringForColumnIndex:5];
            [resultList addObject:peyar];
        }
    }];
    
    return resultList;
}

@end
