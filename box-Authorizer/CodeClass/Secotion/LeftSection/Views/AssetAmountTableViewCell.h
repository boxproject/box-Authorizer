//
//  AssetAmountTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/29.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AssetAmountModel.h"

@interface AssetAmountTableViewCell : UITableViewCell

@property (nonatomic,strong) AssetAmountModel *model;

- (void)setDataWithModel:(AssetAmountModel *)model;

@end
