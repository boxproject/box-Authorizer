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
        if(![dict[@"Hash"] isKindOfClass:[NSNull class]]){
            self.Hash = [dict objectForKey:@"Hash"];
        }
        if(![dict[@"Name"] isKindOfClass:[NSNull class]]){
            self.Name = [dict objectForKey:@"Name"];
        }
        if(![dict[@"Status"] isKindOfClass:[NSNull class]]){
            self.Status = [dict objectForKey:@"Status"];
        }
        if(![dict[@"AppId"] isKindOfClass:[NSNull class]]){
            self.AppId = [dict objectForKey:@"AppId"];
        }
    }
    return self;
}

@end
