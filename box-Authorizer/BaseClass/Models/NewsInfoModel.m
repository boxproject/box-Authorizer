//
//  NewsInfoModel.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/12.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "NewsInfoModel.h"
@interface NewsInfoModel()

@property (nonatomic,strong) NSMutableArray *newsInfoArray;

@end



@implementation NewsInfoModel

+(instancetype)sharedManager{
    static dispatch_once_t onceToken;
    static NewsInfoModel *instance;
    dispatch_once(&onceToken, ^{
        instance = [[NewsInfoModel alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if(self = [super init]){
        
    }
    return self;
}


- (NSMutableArray *)loadNewsInfo
{
    _newsInfoArray = [[NSMutableArray alloc] init];
    FMResultSet *rs = [[DBHelp dataBase]executeQuery:@"select * from newsInfoTable order by newsId desc;"];
    while ([rs next]) {
        NewsModel *model = [[NewsModel alloc]init];
        model.content = [rs stringForColumn:@"content"];
        model.newsId = [rs stringForColumn:@"newsId"];
        model.newsType = [rs intForColumn:@"newsType"];
        [_newsInfoArray addObject:model];
    }
    return _newsInfoArray;
}

/*
 * createNewsInfoTable
 */
- (BOOL)createNewsInfoTable
{
    NSString *newsInfSql = @"CREATE TABLE newsInfoTable (newsInfoIndex INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL , content TEXT ,newsId TEXT ,newsType TEXT);";
    BOOL isOK = [DBHelp createTableHelp:newsInfSql];
    if (isOK) {
        NSLog(@"newsInfoTable Table Crate complete !");
    }
    return isOK;
}

/*
 * 往数据库中插入一条数据
 */
- (BOOL)insertNewsInfoNews:(NSString *)news
{
    NewsModel *newsModel = [[NewsModel alloc] init];
    newsModel.content = news;
    NSInteger timestampIn = [[NSDate date]timeIntervalSince1970] * 1000;
    newsModel.newsId = [NSString stringWithFormat:@"%ld", timestampIn];
    BOOL isOK = [[DBHelp dataBase]executeUpdate:@"insert into newsInfoTable (content,newsId,newsType) values(?,?,?);"
                           withArgumentsInArray:@[newsModel.content,newsModel.newsId,@(newsModel.newsType)]];
    return isOK;
}



@end
