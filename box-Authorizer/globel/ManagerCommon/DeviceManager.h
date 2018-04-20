//
//  DeviceManager.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceManager : NSObject

//获取Document目录
+ (NSString *)documentPath;

//获取doc目录并添加指定路径
+ (NSString *)documentPathAppendingPathComponent:(NSString *)str;

@end
