//
//  ApprovalBusApproversModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusApproversModel.h"

@implementation ApprovalBusApproversModel

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
        if(![dict[@"pub_key"] isKindOfClass:[NSNull class]]){
            self.pub_key = [dict objectForKey:@"pub_key"];
        }
        if(![dict[@"itemType"] isKindOfClass:[NSNull class]]){
            self.itemType = [[dict objectForKey:@"itemType"] integerValue];
        }
    }
    return self;
}

- (NSMutableDictionary *)createDictionayFromModelProperties
{
    NSMutableDictionary *propsDic = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    // class:获取哪个类的成员属性列表
    // count:成员属性总数
    // 拷贝属性列表
    objc_property_t *properties = class_copyPropertyList([self class], &outCount);
    
    for (i = 0; i<outCount; i++) {
        objc_property_t property = properties[i];
        const char* char_f = property_getName(property);
        // 属性名
        NSString *propertyName = [NSString stringWithUTF8String:char_f];
        // 属性值
        id propertyValue = [self valueForKey:(NSString *)propertyName];
        // 设置KeyValues
        if (propertyValue) [propsDic setObject:propertyValue forKey:propertyName];
    }
    // 需手动释放 不受ARC约束
    free(properties);
    return propsDic;
}
    

@end
