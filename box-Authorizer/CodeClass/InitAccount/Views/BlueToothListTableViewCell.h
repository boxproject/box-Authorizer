//
//  BlueToothListTableViewCell.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/13.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlueToothListModel.h"

@interface BlueToothListTableViewCell : UITableViewCell

@property (nonatomic,strong) BlueToothListModel *model;

- (void)setDataWithModel:(NSString *)model;

@end
