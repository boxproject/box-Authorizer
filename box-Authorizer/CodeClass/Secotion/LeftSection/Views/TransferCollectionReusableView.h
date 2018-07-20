//
//  TransferCollectionReusableView.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferModel.h"

@interface TransferCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UILabel *rightLable;
@property (nonatomic, strong) UIImageView *img;

@property (nonatomic,strong) TransferModel *model;

- (void)setDataWithModel:(TransferModel *)model index:(NSInteger)index;

@end
