//
//  NewsModel.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/12.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "NewsModel.h"

@implementation NewsModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"content"] isKindOfClass:[NSNull class]]){
            self.content = [dict objectForKey:@"content"];
        }
        if(![dict[@"newsId"] isKindOfClass:[NSNull class]]){
            self.newsId = [dict objectForKey:@"newsId"];
        }
        if(![dict[@"newsType"] isKindOfClass:[NSNull class]]){
            self.newsType = [[dict objectForKey:@"newsType"] integerValue];
        }
    }
    return self;
}

@end
