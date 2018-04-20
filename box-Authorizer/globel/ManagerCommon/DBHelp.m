//
//  DBHelp.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/1.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "DBHelp.h"

static BOOL isOpen = NO;
@implementation DBHelp

#pragma mark ----- 创建数据库表 -----
+(BOOL)createTableHelp:(NSString*)sql
{
    if (!dataBase || !isOpen) {
        NSLog(@"DB is not open");
        return NO;
    }
    BOOL s = [dataBase executeUpdateWithFormat:sql,nil];
    if (!s) {
        NSLog(@"crate error %@", sql);
        return NO;
    }
    return YES;
}

+(BOOL)openDataBase:(NSString *)dbPath
{
    dataBase = [[FMDatabase alloc]initWithPath:dbPath];
    isOpen = [dataBase open];
    return isOpen;
}

+(BOOL)insertDataBase:(NSString*)sql
{
    if (dataBase == nil || !isOpen) {
        NSLog(@"DB is not open");
        return NO;
    }
    BOOL s = [dataBase executeUpdateWithFormat:sql,nil];
    return s;
}

+(FMResultSet*)selectDataBase:(NSString *)sql
{
    if (!dataBase || !isOpen) {
        NSLog(@"DB is not open");
        return nil;
    }
    FMResultSet *result = [dataBase executeQuery:sql];
    return result;
}

+(BOOL)closeDataBase
{
    if (dataBase && isOpen) {
        return [dataBase close];
    }
    return NO;
}

+ (FMDatabase *)dataBase{
    if (dataBase && isOpen) {
        return dataBase;
    }
    return nil;
}

+(NSString *)documentPath
{
    NSString *dbPath = [DeviceManager documentPathAppendingPathComponent:@"Message.db"];
    return dbPath;
}


@end
