//
//  CoinlistModel.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/12.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "CoinlistModel.h"

@implementation CoinlistModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"Name"] isKindOfClass:[NSNull class]]){
            self.Name = [dict objectForKey:@"Name"];
        }
        if(![dict[@"category"] isKindOfClass:[NSNull class]]){
            self.category = [[dict objectForKey:@"category"] integerValue];
        }
        if(![dict[@"Used"] isKindOfClass:[NSNull class]]){
            self.used = [[dict objectForKey:@"Used"] boolValue];
        }
    }
    return self;
}

@end
