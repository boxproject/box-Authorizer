//
//  ServiceStartModel.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/11.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceStartModel : NSObject

/** ID */
@property (nonatomic,strong) NSString *ApplyerId;
/** 名字 */
@property(nonatomic, strong) NSString *ApplyerName;
/** 是否授权 */
@property(nonatomic, assign) BOOL Authorized;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
