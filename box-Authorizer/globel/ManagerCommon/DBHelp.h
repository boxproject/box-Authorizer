//
//  DBHelp.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/1.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"

static FMDatabase *dataBase = nil;
@interface DBHelp : NSObject

+(BOOL)openDataBase:(NSString *)dbPath;

+(BOOL)createTableHelp:(NSString*)sql;

+(BOOL)insertDataBase:(NSString*)sql;

+(FMResultSet*)selectDataBase:(NSString *)sql;

+ (FMDatabase *)dataBase;

+(BOOL)closeDataBase;

@end
