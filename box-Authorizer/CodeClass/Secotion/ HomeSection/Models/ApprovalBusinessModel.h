//
//  ApprovalBusinessModel.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ApprovalBusinessModel : NSObject

/** 审批流模板编号 */
@property (nonatomic,strong) NSString *Hash;
/**
 HASH_STATUS_0 = "0" //待申请
 HASH_STATUS_1 = "1" //私钥已申请提交
 HASH_STATUS_2 = "2" //私链已同意确认
 HASH_STATUS_3 = "3" //私链已拒绝确认
 HASH_STATUS_4 = "4" //公链已同意
 HASH_STATUS_5 = "5" //公链已拒绝
 */
@property(nonatomic, strong) NSString *Status;
/** 审批流模板名称 */
@property (nonatomic,strong) NSString *Name;
///** 金额上限 */
/** 申请者ID */
@property (nonatomic,strong) NSString *AppId;

- (instancetype)initWithDict:(NSDictionary *)dict;



@end
