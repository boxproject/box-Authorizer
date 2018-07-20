//
//  TransferModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferApproversModel.h"

@interface TransferModel : NSObject
/** 需要审批的个数 */
@property(nonatomic, assign) NSInteger require;
/** 总数 */
@property(nonatomic, assign) NSInteger total;
/** 当前审批状态 1-审批中 2-被驳回 3-审批通过*/
@property(nonatomic, assign) ApprovalState current_progress;
@property(nonatomic, strong) NSMutableArray *approversArray;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
