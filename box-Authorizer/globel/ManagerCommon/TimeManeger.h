//
//  TimeManeger.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/15.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManeger : NSObject

+ (NSString *)minutesFormatString:(int)totalSeconds;
//根据时间戳计算已过时间
+ (NSString *)getElapseTimeToStringHelp:(NSInteger)second;

@end
