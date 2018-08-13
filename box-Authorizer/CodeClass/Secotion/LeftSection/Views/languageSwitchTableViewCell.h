//
//  languageSwitchTableViewCell.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/7/24.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LanguageSwitchModel.h"

@interface languageSwitchTableViewCell : UITableViewCell

@property (nonatomic,strong) LanguageSwitchModel *model;

- (void)setDataWithModel:(LanguageSwitchModel *)model;

@end
