//
//  CurrencyAccountModel.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/18.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "CurrencyAccountModel.h"

@implementation CurrencyAccountModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"currency"] isKindOfClass:[NSNull class]]){
            self.currency = [dict objectForKey:@"currency"];
        }
        if(![dict[@"isType"] isKindOfClass:[NSNull class]]){
            self.isType = [[dict objectForKey:@"isType"] integerValue];
        }
         
    }
    return self;
}

@end
