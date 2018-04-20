//
//  DeviceManager.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "DeviceManager.h"

@implementation DeviceManager

//获取Document目录
+ (NSString *)documentPath{
    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return docPath;
}

//获取doc目录并添加指定路径
+ (NSString *)documentPathAppendingPathComponent:(NSString *)str{
    NSString *path = [[self documentPath]stringByAppendingPathComponent:str];
    return path;
}

@end
