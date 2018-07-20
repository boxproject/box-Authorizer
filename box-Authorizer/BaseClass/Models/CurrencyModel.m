//
//  CurrencyModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "CurrencyModel.h"

@implementation CurrencyModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"currency"] isKindOfClass:[NSNull class]]){
            self.currency = [dict objectForKey:@"currency"];
        }
        if(![dict[@"address"] isKindOfClass:[NSNull class]]){
            self.address = [dict objectForKey:@"address"];
        }
        if(![dict[@"select"] isKindOfClass:[NSNull class]]){
            self.select = [[dict objectForKey:@"select"] boolValue];
        }
        if(![dict[@"state"] isKindOfClass:[NSNull class]]){
            self.state = [[dict objectForKey:@"state"] integerValue];
        }
        if(![dict[@"limit"] isKindOfClass:[NSNull class]]){
            self.limit = [dict objectForKey:@"limit"];
        }
    }
    return self;
}

@end

 

