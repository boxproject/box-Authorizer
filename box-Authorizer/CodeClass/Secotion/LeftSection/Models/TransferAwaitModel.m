//
//  TransferAwaitModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferAwaitModel.h"

@implementation TransferAwaitModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"tx_info"] isKindOfClass:[NSNull class]]){
            self.tx_info = [dict objectForKey:@"tx_info"];
        }
        if(![dict[@"progress"] isKindOfClass:[NSNull class]]){
            self.progress = [[dict objectForKey:@"progress"] integerValue];
        }
        if(![dict[@"order_number"] isKindOfClass:[NSNull class]]){
            self.order_number = [dict objectForKey:@"order_number"];
        }
        if(![dict[@"amount"] isKindOfClass:[NSNull class]]){
            self.amount = [dict objectForKey:@"amount"];
        }
        if(![dict[@"currency"] isKindOfClass:[NSNull class]]){
            self.currency = [dict objectForKey:@"currency"];
        }
        if(![dict[@"apply_at"] isKindOfClass:[NSNull class]]){
            self.apply_at = [[dict objectForKey:@"apply_at"] integerValue];
        }
        if(![dict[@"arrived"] isKindOfClass:[NSNull class]]){
            self.arrived = [[dict objectForKey:@"arrived"] integerValue];
        }
        if(![dict[@"type"] isKindOfClass:[NSNull class]]){
            self.type = [[dict objectForKey:@"type"] integerValue];
        }
        
    }
    return self;
}

@end
