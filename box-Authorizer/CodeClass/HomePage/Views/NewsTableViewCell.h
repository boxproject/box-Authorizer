//
//  NewsTableViewCell.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/12.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NewsModel.h"

@interface NewsTableViewCell : UITableViewCell

@property (nonatomic,strong) NewsModel *model;

- (void)setDataWithModel:(NewsModel *)model;

@end
