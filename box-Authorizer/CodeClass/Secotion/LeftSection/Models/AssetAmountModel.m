//
//  AssetAmountModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/29.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AssetAmountModel.h"

@implementation AssetAmountModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"currency"] isKindOfClass:[NSNull class]]){
            self.currency = [dict objectForKey:@"currency"];
        }
        if(![dict[@"balance"] isKindOfClass:[NSNull class]]){
            self.balance = [dict objectForKey:@"balance"];
        }
        if(![dict[@"freezeAmount"] isKindOfClass:[NSNull class]]){
            self.freezeAmount = [dict objectForKey:@"freezeAmount"];
        }
    }
    return self;
}

@end
