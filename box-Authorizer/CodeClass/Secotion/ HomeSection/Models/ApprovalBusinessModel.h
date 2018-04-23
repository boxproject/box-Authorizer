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
/** 审批流模板状态 */
@property(nonatomic, strong) NSString *Status;
/** 审批流模板名称 */
@property (nonatomic,strong) NSString *Name;
/** 申请者ID */
@property (nonatomic,strong) NSString *AppId;

- (instancetype)initWithDict:(NSDictionary *)dict;



@end
