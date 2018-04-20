//
//  MenberInfoManager.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/7.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "MenberInfoManager.h"
@interface MenberInfoManager()

@property (nonatomic,strong) NSMutableArray *menberInfoArray;

@end

@implementation MenberInfoManager

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static MenberInfoManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[MenberInfoManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}


- (NSMutableArray *)loadMenberInfo:(NSString *)menberId
{
    _menberInfoArray = [[NSMutableArray alloc] init];
    FMResultSet *rs = [[DBHelp dataBase]executeQuery:@"select * from menberInfoTable where menber_id = ?;" withArgumentsInArray:@[menberId]];
    while ([rs next]) {
        MenberInfoModel *model = [[MenberInfoModel alloc]init];
        model.menber_id = [rs stringForColumn:@"menber_id"];
        model.menber_account = [rs stringForColumn:@"menber_account"];
        model.publicKey = [rs stringForColumn:@"publicKey"];
        model.menber_random = [rs stringForColumn:@"menber_random"];
        model.directIdentify = [rs intForColumn:@"directIdentify"];
        [_menberInfoArray addObject:model];
    }
    return _menberInfoArray;
}

/*
 * 根据menber_id从数据库中删除一条数据
 */
- (BOOL)deleteMenberInfoModel:(MenberInfoModel *)model
{
    BOOL isOk = [[DBHelp dataBase]executeUpdate:@"delete from menberInfoTable where menber_id = ?;" withArgumentsInArray:@[model.menber_id]];
    return isOk;
}

/*
 * 根据menber_id修改数据库中的字段
 */
- (BOOL)updateMenberInfoModel:(MenberInfoModel *)model;
{
    BOOL isOK = [[DBHelp dataBase]executeUpdate:@"update menberInfoTable set menber_account = ?,publicKey = ?,menber_random = ?,directIdentify = ? where menber_id = ?"
                           withArgumentsInArray:@[model.menber_account,model.publicKey,model.menber_random,@(model.directIdentify),model.menber_id]];
    return isOK;
}

/*
 * 往数据库中插入一条数据
 */
- (BOOL)insertMenberInfoModel:(MenberInfoModel *)model
{
    BOOL isOK = [[DBHelp dataBase]executeUpdate:@"insert into menberInfoTable (menber_account,publicKey,menber_random,directIdentify,menber_id) values(?,?,?,?,?);"
                           withArgumentsInArray:@[model.menber_account,model.publicKey,model.menber_random,@(model.directIdentify),model.menber_id]];
    return isOK;
}

/*
 * createMenberInfoTable
 */
- (BOOL)createMenberInfoTable
{
    NSString *menberInfSql = @"CREATE TABLE menberInfoTable (menberInfoIndex INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , menber_id TEXT ,menber_account TEXT ,publicKey TEXT ,menber_random TEXT ,directIdentify TEXT);";
    BOOL isOK = [DBHelp createTableHelp:menberInfSql];
    if (isOK) {
        NSLog(@"menberInfoTable Table Crate complete !");
    }
    return isOK;
}

@end
