//
//  CurrencyAccountModel.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/18.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, IsType) {
    NoAddCurrency,
    AddCurrency,
};

@interface CurrencyAccountModel : NSObject
/** 币种／代币名称 */
@property (nonatomic,strong) NSString *currency;
@property(nonatomic, assign) BOOL isSelect;
@property (nonatomic, assign)IsType isType;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
