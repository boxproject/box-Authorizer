//
//  LanguageSwitchModel.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/21.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LanguageSwitchModel : NSObject

@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,assign) BOOL select;
- (instancetype)initWithDict:(NSDictionary *)dict;

@end
