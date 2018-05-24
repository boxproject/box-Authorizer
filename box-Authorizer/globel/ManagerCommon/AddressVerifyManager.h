//
//  AddressVerifyManager.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/5/21.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

#define AddressVerifyETHError  @"ETH地址格式无效"

@interface AddressVerifyManager : NSObject

+(BOOL)checkAddressVerify:(NSString *)address type:(NSString *)type;

@end
