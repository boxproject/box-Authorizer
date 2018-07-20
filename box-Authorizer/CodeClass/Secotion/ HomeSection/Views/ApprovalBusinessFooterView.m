//
//  ApprovalBusinessFooterView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessFooterView.h"

@interface ApprovalBusinessFooterView ()

@property (nonatomic,strong)UILabel *leftLab;
@property (nonatomic,strong)UIButton *button;

@end

@implementation ApprovalBusinessFooterView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"icon_viewLog"];
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.left.offset(15);
        make.width.offset(27);
        make.height.offset(27);
    }];
    
    _leftLab = [[UILabel alloc] init];
    _leftLab.textAlignment = NSTextAlignmentLeft;
    _leftLab.font = Font(14);
    _leftLab.text = viewLog;
    _leftLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:_leftLab];
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.left.equalTo(img.mas_right).offset(8);
        make.width.offset(90);
        make.height.offset(20);
    }];
    
    UIImageView *rightImg = [[UIImageView alloc] init];
    rightImg.image = [UIImage imageNamed:@"right_icon"];
    [self addSubview:rightImg];
    [rightImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-11);
        make.centerY.equalTo(_leftLab);
        make.width.offset(20);
        make.height.offset(22);
    }];
    
    UIButton *viewLogBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [viewLogBtn addTarget:self action:@selector(viewLogBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:viewLogBtn];
    [viewLogBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(40);
    }];
}

-(void)viewLogBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(enterViewLog)]) {
        [self.delegate enterViewLog];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
