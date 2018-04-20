//
//  ApprovalBusinessDetailModel.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessDetailModel.h"

@implementation ApprovalBusinessDetailModel

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
        if(![dict[@"approvers"] isKindOfClass:[NSNull class]]){
            _approvers = [[NSMutableArray alloc] init];
            NSArray *array = dict[@"approvers"];
            for (NSDictionary *dic in array) {
                ApprovalBusApproversModel *model = [[ApprovalBusApproversModel alloc] initWithDict:dic];
                [_approvers addObject:model];
            }
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
