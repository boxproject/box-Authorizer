//
//  ProgressHUD.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/1.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ProgressHUD.h"

#define NetWorkCode101  @"非法hash前缀"
#define NetWorkCode1002  @"您已提交注册申请，请耐心等待"
#define NetWorkCode2001  @"转账信息有误，请查验后重新提交"
#define NetWorkCode2002  @"未找到对应币种"
#define NetWorkCode2003  @"未找到对应的业务流程"
#define NetWorkCode2004  @"转账申请提交失败，请稍候重试"
#define NetWorkCode2005  @"签名信息错误"
#define NetWorkCode1004  @"指定账号不存在"
#define NetWorkCode1007  @"权限不足"
#define NetWorkCode3001  @"您的账号暂无权限创建审批流模板"
#define NetWorkCode3003  @"业务流模板名称重复"
#define NetWorkCode3004  @"创建审批流模板失败"

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
    }
}

@end
