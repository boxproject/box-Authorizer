//
//  NewsModel.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/12.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

/** 动态内容 */
@property (nonatomic,strong) NSString *content;
/** 时间 */
@property (nonatomic,strong) NSString *newsId;
/** 动态类型 */
@property (nonatomic,assign) NSInteger newsType;

- (instancetype)initWithDict:(NSDictionary *)dict;

@end
