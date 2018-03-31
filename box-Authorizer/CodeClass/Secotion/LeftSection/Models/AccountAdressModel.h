//
//  AccountAdressModel.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountAdressModel : NSObject

@property (nonatomic,strong) NSString *titleName;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
