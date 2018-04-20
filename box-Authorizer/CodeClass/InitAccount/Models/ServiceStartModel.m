//
//  ServiceStartModel.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/11.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ServiceStartModel.h"

@implementation ServiceStartModel

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
        if(![dict[@"Authorized"] isKindOfClass:[NSNull class]]){
            self.Authorized = [[dict objectForKey:@"Authorized"] boolValue];
        }
    }
    return self;
}

@end
