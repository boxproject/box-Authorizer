//
//  ApprovalBusApproversModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ItemType) {
    ItemTypeNormal,   //显示成员
    ItemTypeAdd      //添加成员
};

@interface ApprovalBusApproversModel : NSObject

/** 账户 */
@property(nonatomic, strong) NSString *account;
/** 账户唯一标识 */
@property(nonatomic, strong) NSString *app_account_id;
/** 审批者公钥 */
@property(nonatomic, strong) NSString *pub_key;
/** 0:显示成员  1:添加成员 */
@property(nonatomic, assign) ItemType itemType;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSMutableDictionary *)createDictionayFromModelProperties;

@end
