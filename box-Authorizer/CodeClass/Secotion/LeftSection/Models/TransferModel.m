//
//  TransferModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferModel.h"

@implementation TransferModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"require"] isKindOfClass:[NSNull class]]){
            self.require = [[dict objectForKey:@"require"] integerValue];
        }
        if(![dict[@"total"] isKindOfClass:[NSNull class]]){
            self.total = [[dict objectForKey:@"total"] integerValue];
        }
        if(![dict[@"current_progress"] isKindOfClass:[NSNull class]]){
            self.current_progress = [[dict objectForKey:@"current_progress"] integerValue];
        }
        if(![dict[@"approvers"] isKindOfClass:[NSNull class]]){
            _approversArray = [[NSMutableArray alloc] init];
            NSArray *array = dict[@"approvers"];
            for (NSDictionary *dic in array) {
                TransferApproversModel *model = [[TransferApproversModel alloc] initWithDict:dic];
                [_approversArray addObject:model];
            }
        }
    }
    return self;
}


@end
