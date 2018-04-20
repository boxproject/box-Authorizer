//
//  ApprovalBusinessCollectionReusableView.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalBusinessDetailModel.h"

@interface ApprovalBusinessCollectionReusableView : UICollectionReusableView

@property (nonatomic, strong) UILabel *leftLable;
@property (nonatomic, strong) UILabel *rightLable;
@property (nonatomic, strong) UIImageView *img;

@property (nonatomic,strong) ApprovalBusinessDetailModel *model;

- (void)setDataWithModel:(ApprovalBusinessDetailModel *)model index:(NSInteger)index;

@end
