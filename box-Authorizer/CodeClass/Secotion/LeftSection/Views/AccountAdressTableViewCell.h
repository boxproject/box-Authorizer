//
//  AccountAdressTableViewCell.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountAdressModel.h"

@interface AccountAdressTableViewCell : UITableViewCell

@property (nonatomic,strong) AccountAdressModel *model;

- (void)setDataWithModel:(AccountAdressModel *)model;

@end
