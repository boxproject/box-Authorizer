//
//  LanguageSwitchModel.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/21.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "LanguageSwitchModel.h"

@implementation LanguageSwitchModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"titleName"] isKindOfClass:[NSNull class]]){
            self.titleName = [dict objectForKey:@"titleName"];
        }
        if(![dict[@"select"] isKindOfClass:[NSNull class]]){
            self.select = [[dict objectForKey:@"select"] boolValue];
        }
    }
    return self;
}

@end
