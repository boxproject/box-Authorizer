//
//  LeftMenuTableViewCell.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/21.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftMenuModel.h"

@interface LeftMenuTableViewCell : UITableViewCell

@property (nonatomic,strong) LeftMenuModel *model;

- (void)setDataWithModel:(LeftMenuModel *)model;

@end
