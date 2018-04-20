//
//  AuthorizerInfoModel.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/9.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AuthorizerInfoModel.h"

@implementation AuthorizerInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"ApplyerId"] isKindOfClass:[NSNull class]]){
            self.ApplyerId = [dict objectForKey:@"ApplyerId"];
        }
        if(![dict[@"ApplyerName"] isKindOfClass:[NSNull class]]){
            self.ApplyerName = [dict objectForKey:@"ApplyerName"];
        }
    }
    return self;
}

@end
