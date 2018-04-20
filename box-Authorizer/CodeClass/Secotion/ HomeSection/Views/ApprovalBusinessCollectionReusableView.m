//
//  ApprovalBusinessCollectionReusableView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessCollectionReusableView.h"

#define ApprovalMenber  @"审批人员"
#define ApprovalMenberAmount  @"需审批人数"

@implementation ApprovalBusinessCollectionReusableView

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self createView];
    }
    return self;
}

-(void)createView
{
    //icon_wait2
    _img = [[UIImageView alloc] init];
    _img.image = [UIImage imageNamed:@""];
    _img.layer.cornerRadius = 12.0/2.0;
    _img.layer.masksToBounds = YES;
    [self addSubview:_img];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self);
        make.height.offset(12);
        make.width.offset(12);
    }];
    
    _leftLable = [[UILabel alloc]init];
    _leftLable.font = Font(14);
    _leftLable.textColor = [UIColor colorWithHexString:@"#2b3350"];
    [self addSubview:_leftLable];
    [_leftLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_img.mas_right).offset(11);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    
    _rightLable = [[UILabel alloc]init];
    _rightLable.font = Font(13);
    _rightLable.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:_rightLable];
    [_rightLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-14);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
}



- (void)setDataWithModel:(ApprovalBusinessDetailModel *)model index:(NSInteger)index
{
    _img.image = [UIImage imageNamed:@"icon_pass"];
    _leftLable.text = [NSString stringWithFormat:@"第%ld步%@(%ld)", index + 1, ApprovalMenber, model.total];
    _rightLable.text = [NSString stringWithFormat:@"%@%ld/%ld", ApprovalMenberAmount, model.require, model.total];
}



@end
