//
//  TransferRecordTableViewCell.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransferAwaitModel.h"

@interface TransferRecordTableViewCell : UITableViewCell

@property (nonatomic,strong) TransferAwaitModel *model;

- (void)setDataWithModel:(TransferAwaitModel *)model;

@end
