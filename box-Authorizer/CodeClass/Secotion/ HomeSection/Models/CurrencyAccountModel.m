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
        if(![dict[@"TokenName"] isKindOfClass:[NSNull class]]){
            self.TokenName = [dict objectForKey:@"TokenName"];
        }
        if(![dict[@"isType"] isKindOfClass:[NSNull class]]){
            self.isType = [[dict objectForKey:@"isType"] integerValue];
        }
        if(![dict[@"Decimals"] isKindOfClass:[NSNull class]]){
            self.Decimals = [[dict objectForKey:@"Decimals"] integerValue];
        }
        if(![dict[@"ContractAddr"] isKindOfClass:[NSNull class]]){
            self.ContractAddr = [dict objectForKey:@"ContractAddr"];
        }
    }
    return self;
}

@end
