//
//  JsonObject.h
//  box-Staff-Manager
//
//  Created by Rony on 2018/3/5.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonObject : NSObject

/** Json字符串转字典 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/** Json字符串转数组 */
+ (NSArray *)dictionaryWithJsonStringArr:(NSString *)jsonString;

/** 字典转Json字符串 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/** 数组转Json字符串 */
+ (NSString*)dictionaryToarrJson:(NSArray *)arr;

/** 生成指定位数的数字+字母的随机数 */
+ (NSString *)getRandomStringWithNum:(NSInteger)num;

@end
