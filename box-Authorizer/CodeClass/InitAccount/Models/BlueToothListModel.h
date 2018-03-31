//
//  BlueToothListModel.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/13.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLBLEManager.h"

@interface BlueToothListModel : NSObject
/** 蓝牙名称 */
@property (nonatomic,strong) NSString *blueTooth;
/** 连接状态 */
@property(nonatomic, assign) BOOL isSelect;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
