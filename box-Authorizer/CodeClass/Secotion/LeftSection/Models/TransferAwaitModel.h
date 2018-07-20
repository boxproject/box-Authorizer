//
//  TransferAwaitModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferAwaitModel : NSObject

/** 申请理由 */
@property (nonatomic,strong) NSString *tx_info;
/** 审批进度 0待审批 1审批中 2被驳回 3审批成功 */
@property(nonatomic, assign) ApprovalState progress;
/** -1-失败 1-转账中 2-转账成功*/
@property(nonatomic, assign) NSInteger arrived;
/** 转账记录编号 */
@property (nonatomic,strong) NSString *order_number;
/** 转账金额 */
@property (nonatomic,strong) NSString *amount;
/** 币种 */
@property (nonatomic,strong) NSString *currency;
/** 该笔转账申请时间戳 */
@property(nonatomic, assign) NSInteger apply_at;
/** 交易类型 0充值 1转账 */
@property(nonatomic, assign) NSInteger type;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
