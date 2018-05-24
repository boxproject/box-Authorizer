//
//  PassWordManager.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/5/9.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "PassWordManager.h"

@implementation PassWordManager

/*
 不能全部为数字
 不能全部为字母
 必须包含字母和数字
 */
+(BOOL)checkPassWord:(NSString *)pwd
{
    //这里设置为6-12位数字和字母组成
    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,12}$";
    NSPredicate *  pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([pred evaluateWithObject:pwd]) {
        return YES ;
    }else
        return NO;
}

@end
