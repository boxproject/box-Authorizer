//
//  NewsInfoModel.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/12.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NewsModel.h"

@interface NewsInfoModel : NSObject

+(instancetype)sharedManager;
- (NSMutableArray *)loadNewsInfo;
- (BOOL)createNewsInfoTable;
- (BOOL)insertNewsInfoNews:(NSString *)news;

@end
