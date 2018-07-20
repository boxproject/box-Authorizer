//
//  TransferCollectionViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferModel.h"
#import "TransferApproversModel.h"

@interface TransferCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) TransferApproversModel *model;

- (void)setDataWithModel:(TransferApproversModel *)model;

@end
