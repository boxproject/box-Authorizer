//
//  AuthorizerInfoModel.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/9.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthorizerInfoModel : NSObject
/** ID */
@property (nonatomic,strong) NSString *ApplyerId;
/** 名字 */
@property(nonatomic, strong) NSString *ApplyerName;

- (instancetype)initWithDict:(NSDictionary *)dict;
@end
