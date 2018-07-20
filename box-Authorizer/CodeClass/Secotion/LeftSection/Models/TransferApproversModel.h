//
//  TransferApproversModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>
 
@interface TransferApproversModel : NSObject

/** 账户 */
@property(nonatomic, strong) NSString *account;
/** 账户唯一标识 */
@property(nonatomic, strong) NSString *app_account_id;
/** 签名 */
@property(nonatomic, strong) NSString *sign;
/** 审批状态 */
@property(nonatomic, assign) ApprovalState progress;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
