//
//  ApprovalBusinessCollectionViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalBusApproversModel.h"

@interface ApprovalBusinessCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong) ApprovalBusApproversModel *model;

- (void)setDataWithModel:(ApprovalBusApproversModel *)model;

@end
