//
//  CoinlistModel.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/12.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoinlistModel : NSObject

/** 币种分类，必输 0-BTC */
@property (nonatomic,assign) NSInteger category;
/** 是否使用 */
@property (nonatomic,assign) BOOL used;
/** 币种名字 */
@property (nonatomic,strong) NSString *Name;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
