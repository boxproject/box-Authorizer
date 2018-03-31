//
//  ApprovalBusinessModel.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessModel.h"

@implementation ApprovalBusinessModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"approvalTitle"] isKindOfClass:[NSNull class]]){
            self.approvalTitle = [dict objectForKey:@"approvalTitle"];
        }
        if(![dict[@"approvalTitle"] isKindOfClass:[NSNull class]]){
            self.approvalState = [[dict objectForKey:@"approvalState"] integerValue];
        }
    }
    return self;
}

@end
