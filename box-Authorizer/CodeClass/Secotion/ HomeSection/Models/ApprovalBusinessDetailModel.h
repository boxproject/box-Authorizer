//
//  ApprovalBusinessDetailModel.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ApprovalBusApproversModel.h"

@interface ApprovalBusinessDetailModel : NSObject

/** 需要审批的个数 */
@property(nonatomic, assign) NSInteger require;
/** 总数 */
@property(nonatomic, assign) NSInteger total;
@property(nonatomic, strong) NSMutableArray *approvers;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (NSMutableDictionary *)createDictionayFromModelProperties;

@end
