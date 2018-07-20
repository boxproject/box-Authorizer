//
//  TransferCollectionViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferCollectionViewCell.h"


@interface TransferCollectionViewCell()

@property (nonatomic,strong) UIView *view;

@property (nonatomic,strong) UILabel *nameLab;

@end

@implementation TransferCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
    }
    return self;
}


-(void)createView
{
    _view = [[UIView alloc] init];
    _view.backgroundColor = [UIColor colorWithHexString:@"#e3ecff"];
    _view.layer.cornerRadius = 3.f;
    _view.layer.masksToBounds = YES;
    [self.contentView addSubview:_view];
    [_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.offset(0);
    }];
    
    _nameLab = [[UILabel alloc]init];
    _nameLab.font = Font(13);
    _nameLab.textAlignment = NSTextAlignmentCenter;
    _nameLab.textColor = [UIColor colorWithHexString:@"#4380fa"];
    [_view addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.left.right.bottom.offset(0);
    }];
}

- (void)setDataWithModel:(TransferApproversModel *)model
{
    _nameLab.text = model.account;
    if (model.progress == ApprovalFail) {
        _view.backgroundColor = [UIColor colorWithHexString:@"#fcefed"];
        _nameLab.textColor = [UIColor colorWithHexString:@"#f74a48"];
    }else{
        _view.backgroundColor = [UIColor colorWithHexString:@"#e3ecff"];
        _nameLab.textColor = [UIColor colorWithHexString:@"#4380fa"];
    }
}

@end
