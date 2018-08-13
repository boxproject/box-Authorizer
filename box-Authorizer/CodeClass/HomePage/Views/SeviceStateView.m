//
//  SeviceStateView.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "SeviceStateView.h"

@interface SeviceStateView ()<UITextFieldDelegate>

@property (nonatomic,strong)UIView *bigView;

@property (nonatomic,strong)UIView *mainView;

@property (nonatomic,strong)UIButton *cancelBtn;

@property (nonatomic,strong)UILabel *titilelab;

@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,assign)NSInteger state;

@end

@implementation SeviceStateView

-(id)initWithFrame:(CGRect)frame state:(NSInteger)state{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView:state];
        _state = state;
    }
    return self;
}


-(void)createView:(NSInteger)state
{
    _bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _bigView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [self addSubview:_bigView];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(105/2, ([UIScreen mainScreen].bounds.size.height - 350/2)/2,  [UIScreen mainScreen].bounds.size.width - 105, 350/2)];
    _mainView.backgroundColor = kWhiteColor;
    _mainView.layer.cornerRadius = 3.f;
    _mainView.layer.masksToBounds = YES;
    [self addSubview:_mainView];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:Cancel forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = Font(13);
    [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(19/2);
        make.right.offset(-5);
        make.width.offset(54);
        make.height.offset(25);
    }];
    
    _titilelab = [[UILabel alloc] init];
    _titilelab.textAlignment = NSTextAlignmentCenter;
    _titilelab.font = Font(16);
    _titilelab.textColor = [UIColor colorWithHexString:@"#444444"];
    _titilelab.numberOfLines = 1;
    [_mainView addSubview:_titilelab];
    [_titilelab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(101/2);
        make.left.offset(34/2);
        make.right.offset(-34/2);
        make.height.offset(46/2);
    }];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _confirmBtn.layer.cornerRadius = 2.f;
    _confirmBtn.layer.masksToBounds = YES;
    _confirmBtn.titleLabel.font = Font(15);
    [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_confirmBtn];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(216/2);
        make.left.offset(34/2);
        make.right.offset(-34/2);
        make.height.offset(74/2);
    }];
    
    if (state == StopServiceOperate) {
        _titilelab.text = HomepageSeverStartLaber;
        [_confirmBtn setTitle:HomepageSeverStartButton forState:UIControlStateNormal];
    }else if(state == StartServiceOperate){
        _titilelab.text = HomepageSeverStopLaber;
        [_confirmBtn setTitle:HomepageSeverStopButton forState:UIControlStateNormal];
    }
}

#pragma mark ----- cancel -----
-(void)cancelAction:(UIButton *)btn
{
    [self removeFromSuperview];
}

#pragma mark ----- confirm -----
-(void)confirmAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(SeviceState:)]) {
        [self.delegate SeviceState:_state];
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
