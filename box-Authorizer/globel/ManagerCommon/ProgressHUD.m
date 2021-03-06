//
//  ProgressHUD.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/1.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ProgressHUD.h"

#define NetWorkCode101  @"非法hash前缀"
#define NetWorkCode11  @"JSON处理失败"
#define NetWorkCode12  @"leveldb处理失败"
#define NetWorkCode103  @"非法金额"
#define NetWorkCode10000  @"请求失败"
#define NetWorkCode107  @"密码错误"
#define NetWorkCode112  @"重复请求"

@implementation ProgressHUD

+(void)showProgressHUD
{
    [WSProgressHUD setProgressHUDIndicatorStyle:WSProgressHUDIndicatorBigGray];
    [WSProgressHUD show];
}

+(void)showStatus:(NSInteger)code
{
    if(code == 101){
        [WSProgressHUD showErrorWithStatus:NetWorkCode101];
    }else if (code == 11){
        [WSProgressHUD showErrorWithStatus:NetWorkCode11];
    }else if (code == 12){
        [WSProgressHUD showErrorWithStatus:NetWorkCode12];
    }else if (code == 103){
        [WSProgressHUD showErrorWithStatus:NetWorkCode103];
    }else if (code == 10000){
        [WSProgressHUD showErrorWithStatus:NetWorkCode10000];
    }else if (code == 107){
        [WSProgressHUD showErrorWithStatus:NetWorkCode107];
    }else if (code == 112){
        [WSProgressHUD showErrorWithStatus:NetWorkCode112];
    }
}

@end
