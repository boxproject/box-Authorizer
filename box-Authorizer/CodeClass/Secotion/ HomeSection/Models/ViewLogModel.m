//
//  ViewLogModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ViewLogModel.h"

@implementation ViewLogModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"ApplyerAccount"] isKindOfClass:[NSNull class]]){
            self.ApplyerAccount = [dict objectForKey:@"ApplyerAccount"];
        }
        if(![dict[@"CaptainId"] isKindOfClass:[NSNull class]]){
            self.CaptainId = [dict objectForKey:@"CaptainId"];
        }
        if(![dict[@"Option"] isKindOfClass:[NSNull class]]){
            self.Option = [dict objectForKey:@"Option"];
        }
        if(![dict[@"Opinion"] isKindOfClass:[NSNull class]]){
            self.Opinion = [dict objectForKey:@"Opinion"];
        }
        if(![dict[@"CreateTime"] isKindOfClass:[NSNull class]]){
            self.CreateTime = [dict objectForKey:@"CreateTime"];
        }
    }
    return self;
}

@end
