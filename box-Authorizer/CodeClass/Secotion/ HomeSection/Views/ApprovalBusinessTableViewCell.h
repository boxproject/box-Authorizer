//
//  ApprovalBusinessTableViewCell.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ApprovalBusinessModel.h"

@interface ApprovalBusinessTableViewCell : UITableViewCell

@property (nonatomic,strong) ApprovalBusinessModel *model;

- (void)setDataWithModel:(ApprovalBusinessModel *)model;

@end
