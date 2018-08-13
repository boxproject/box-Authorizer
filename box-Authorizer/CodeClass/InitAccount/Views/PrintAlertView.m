//
//  PrintAlertView.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/13.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "PrintAlertView.h"

@interface PrintAlertView ()

@property (nonatomic,strong)UIView *bigView;

@property (nonatomic,strong)UIView *mainView;

@property (nonatomic,strong)UIView *mainPrintView;

@property (nonatomic,strong)UILabel *printState;

@property (nonatomic,strong)UIButton *printBtn;

@property (nonatomic,strong)UIButton *printAgainBtn;

@property (nonatomic,strong)UIButton *contractBtn;

@property (nonatomic,strong)UIImageView *imgOne;

@property (nonatomic,strong)UIImageView *imgTwo;

@property (nonatomic,strong)UIImageView *imgThree;

@end

@implementation PrintAlertView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    _bigView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _bigView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [self addSubview:_bigView];
    
    _mainView = [[UIView alloc] initWithFrame:CGRectMake(40, ([UIScreen mainScreen].bounds.size.height - 220)/2,  [UIScreen mainScreen].bounds.size.width - 80, 220)];
    _mainView.backgroundColor = kWhiteColor;
    _mainView.layer.cornerRadius = 3.f;
    _mainView.layer.masksToBounds = YES;
    [self addSubview:_mainView];
    
    _imgOne = [[UIImageView alloc] init];
    _imgOne.image = [UIImage imageNamed:@"connectPrintImg"];
    [_mainView addSubview:_imgOne];
    [_imgOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
        make.centerX.equalTo(_mainView);
        make.width.offset(100);
        make.height.offset(100);
    }];
    
    _imgTwo = [[UIImageView alloc] init];
    _imgTwo.image = [UIImage imageNamed:@"printingImg"];
    [_mainView addSubview:_imgTwo];
    [_imgTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
        make.centerX.equalTo(_mainView);
        make.width.offset(160);
        make.height.offset(100);
    }];
    _imgTwo.hidden = YES;
    
    _printState = [[UILabel alloc]init];
    _printState.text = PrintAlertViewPrinting;
    _printState.textAlignment = NSTextAlignmentCenter;
    _printState.font = Font(15);
    _printState.textColor = kBlackColor;
    [_mainView addSubview:_printState];
    [_printState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(160);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(25);
    }];
    
    _printBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_printBtn setTitle:PrintImmediately forState:UIControlStateNormal];
    [_printBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _printBtn.layer.cornerRadius = 2.f;
    _printBtn.layer.masksToBounds = YES;
    _printBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _printBtn.titleLabel.font = Font(15);
    [_printBtn addTarget:self action:@selector(printAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainView addSubview:_printBtn];
    [_printBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top .offset(160);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(35);
        
    }];
    _printBtn.hidden = YES;
}


-(void)createPrintView
{
    _mainPrintView = [[UIView alloc] initWithFrame:CGRectMake(40, ([UIScreen mainScreen].bounds.size.height - 330)/2,  [UIScreen mainScreen].bounds.size.width - 80, 330)];
    _mainPrintView.backgroundColor = kWhiteColor;
    _mainPrintView.layer.cornerRadius = 3.f;
    _mainPrintView.layer.masksToBounds = YES;
    [self addSubview:_mainPrintView];
    
    _imgThree = [[UIImageView alloc] init];
    _imgThree.image = [UIImage imageNamed:@"icon_success"];
    [_mainPrintView addSubview:_imgThree];
    [_imgThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35);
        make.centerX.equalTo(_mainPrintView);
        make.width.offset(130);
        make.height.offset(100);
    }];
    
    _printAgainBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_printAgainBtn setTitle:Reprint forState:UIControlStateNormal];
    [_printAgainBtn setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    _printAgainBtn.titleLabel.font = Font(13);
    [_printAgainBtn addTarget:self action:@selector(printAgainAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainPrintView addSubview:_printAgainBtn];
    [_printAgainBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top .offset(6);
        make.right.offset(-12);
        make.width.offset(70);
        make.height.offset(28);
    }];
    
    UILabel *printedLab = [[UILabel alloc]init];
    printedLab.text = PrintSuccessfully;
    printedLab.textAlignment = NSTextAlignmentCenter;
    printedLab.font = Font(16);
    printedLab.textColor = [UIColor colorWithHexString:@"#444444"];
    [_mainPrintView addSubview:printedLab];
    [printedLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(160);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(25);
    }];
    
    UIView *alertBackground = [[UIView alloc] init];
    alertBackground.backgroundColor = RGB(251, 238, 237);
    alertBackground.layer.borderWidth = 1.0f;
    alertBackground.layer.borderColor = RGB(220, 83, 55).CGColor;
    alertBackground.layer.cornerRadius = 3.f;
    alertBackground.layer.masksToBounds = YES;
    [_mainPrintView addSubview:alertBackground];
    [alertBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(printedLab.mas_bottom).offset(10);
        make.height.offset(60);
    }];
    
    
    UIImageView *imgAlert = [[UIImageView alloc] init];
    imgAlert.image = [UIImage imageNamed: @"icon_warning"];
    [alertBackground addSubview:imgAlert];
    [imgAlert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.top.offset(10);
        make.width.offset(12);
        make.height.offset(12);
    }];
    
    UILabel *aleartLab = [[UILabel alloc]init];
    aleartLab.text = PrintAlertViewAlertLabText;
    aleartLab.textAlignment = NSTextAlignmentLeft;
    aleartLab.font = Font(12);
    aleartLab.textColor = [UIColor colorWithHexString:@"#d94122"];
    aleartLab.numberOfLines = 0;
    [alertBackground addSubview:aleartLab];
    [aleartLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgAlert.mas_right).offset(5);
        make.right.offset(-6);
        make.top.offset(5);
        make.height.offset(50);
        
    }];
    
    _contractBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contractBtn setTitle:GenerateContract forState:UIControlStateNormal];
    [_contractBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _contractBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _contractBtn.titleLabel.font = Font(15);
    _contractBtn.layer.cornerRadius = 2.f;
    _contractBtn.layer.masksToBounds = YES;
    [_contractBtn addTarget:self action:@selector(contracAction:) forControlEvents:UIControlEventTouchUpInside];
    [_mainPrintView addSubview:_contractBtn];
    [_contractBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alertBackground.mas_bottom).offset(20);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(35);
    }];
}


#pragma mark ----- 立即打印 -----
-(void)printAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(printRightNow)]) {
        [self.delegate printRightNow];
    }
}

#pragma mark ----- 重新打印 -----
-(void)printAgainAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(printNew)]) {
        [self.delegate printNew];
    }
}

#pragma mark ----- 生成合约 -----
-(void)contracAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(generateContract)]) {
        [self.delegate generateContract];
    }
}

#pragma mark ----- 打印状态 -----
-(void)changePrintState:(NSInteger)state
{
    switch (state) {
        case BTConnectFail:
        {
            _printState.text = PrintAlertViewBTConnectFail;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
            break;
        }
        case BTConnectSuccess:
        {
            _imgOne.image = [UIImage imageNamed:@"connectSuccessImg"];
            _printState.hidden = YES;
            _printBtn.hidden = NO;
            break;
        }
        case BTPrinting:
        {
            _mainView.hidden = NO;
            _mainPrintView.hidden = YES;
            _imgOne.hidden = YES;
            _imgTwo.hidden = NO;
            _imgTwo.image = [UIImage imageNamed:@"printingImg"];
            _printState.hidden = NO;
            _printBtn.hidden = YES;
            _printState.text = PrintAlertViewBTPrinting;
            break;
        }
        case BTPrintSuccess:
        {
            _mainView.hidden = YES;
            [self createPrintView];
            break;
        }
        case BTPrintFail:
        {
             
            break;
        }
        default:
            break;
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
