//
//  ServiceStartCollectionViewCell.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/11.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServiceStartModel.h"

@interface ServiceStartCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) ServiceStartModel *model;

- (void)setDataWithModel:(ServiceStartModel *)model;

@end
