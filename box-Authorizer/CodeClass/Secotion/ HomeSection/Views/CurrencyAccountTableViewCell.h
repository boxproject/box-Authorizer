//
//  CurrencyAccountTableViewCell.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/18.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyAccountModel.h"
#import "CoinlistModel.h"

@interface CurrencyAccountTableViewCell : UITableViewCell

@property (nonatomic,strong) CurrencyAccountModel *model;

- (void)setDataWithModel:(CurrencyAccountModel *)model;

@property (nonatomic,strong) CoinlistModel *coinlistModel;

- (void)setDataWithCoinlistModel:(CoinlistModel *)model;

@end
