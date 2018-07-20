//
//  ViewLogTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewLogModel.h"

@interface ViewLogTableViewCell : UITableViewCell

@property (nonatomic,strong) ViewLogModel *model;

- (void)setDataWithModel:(ViewLogModel *)model;

+ (CGFloat)defaultHeight:(ViewLogModel *)model;

@end
