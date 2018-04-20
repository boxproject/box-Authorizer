//
//  MenberInfoModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/7.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "MenberInfoModel.h"

@implementation MenberInfoModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init])
    {
        if(![dict[@"menber_id"] isKindOfClass:[NSNull class]]){
            self.menber_id = [dict objectForKey:@"menber_id"];
        }
        if(![dict[@"menber_account"] isKindOfClass:[NSNull class]]){
            self.menber_account = [dict objectForKey:@"menber_account"];
        }
        if(![dict[@"publicKey"] isKindOfClass:[NSNull class]]){
            self.publicKey = [dict objectForKey:@"publicKey"];
        }
        if(![dict[@"menber_random"] isKindOfClass:[NSNull class]]){
            self.menber_random = [dict objectForKey:@"menber_random"];
        }
        if(![dict[@"directIdentify"] isKindOfClass:[NSNull class]]){
            self.directIdentify = [[dict objectForKey:@"directIdentify"] integerValue];
        }
    }
    return self;
}

@end
