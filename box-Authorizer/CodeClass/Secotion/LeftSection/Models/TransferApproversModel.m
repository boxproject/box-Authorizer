//
//  TransferApproversModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferApproversModel.h"

@implementation TransferApproversModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"account"] isKindOfClass:[NSNull class]]){
            self.account = [dict objectForKey:@"account"];
        }
        if(![dict[@"app_account_id"] isKindOfClass:[NSNull class]]){
            self.app_account_id = [dict objectForKey:@"app_account_id"];
        }
        if(![dict[@"sign"] isKindOfClass:[NSNull class]]){
            self.sign = [dict objectForKey:@"sign"];
        }
        if(![dict[@"progress"] isKindOfClass:[NSNull class]]){
            self.progress = [[dict objectForKey:@"progress"] integerValue];
        }
    }
    return self;
}

@end
