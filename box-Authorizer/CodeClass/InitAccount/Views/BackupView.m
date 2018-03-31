//
//  BackupView.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/8.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "BackupView.h"


@interface BackupView ()<UITextFieldDelegate>
/** 密码 */
@property (nonatomic,strong)UITextField *passwordTf;
/** 取消 */
@property (nonatomic,strong)UIButton *cancelBtn;
/** 确认 */
@property (nonatomic,strong)UIButton *confirmBtn;

@property (nonatomic,strong)UIView *topView;

@property (nonatomic,strong)UIView *footView;

@end

@implementation BackupView

-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)createView
{
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH, SCREEN_HEIGHT - 350)];
    _topView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    [self addSubview:_topView];
    
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTopViewAction:)];
    _topView.userInteractionEnabled = YES;
    [_topView addGestureRecognizer:tapOne];
    
    _footView = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 350,  SCREEN_WIDTH, 350)];
    _footView.backgroundColor = [UIColor colorWithHexString:@"#f7f8f9"];
    [self addSubview:_footView];
    
    UITapGestureRecognizer *tapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchFootViewAction:)];
    _footView.userInteractionEnabled = YES;
    [_footView addGestureRecognizer:tapTwo];
    
    UILabel *backupLab = [[UILabel alloc] init];
    backupLab.text = @"备份密码";
    backupLab.textAlignment = NSTextAlignmentCenter;
    backupLab.font = Font(17);
    backupLab.textColor = kBlackColor;
    backupLab.numberOfLines = 1;
    [_footView addSubview:backupLab];
    [backupLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(15);
        make.centerX.equalTo(self);
        make.height.offset(30);
    }];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:kDarkGrayColor forState:UIControlStateNormal];
    _cancelBtn.titleLabel.font = Font(17);
  
    [_cancelBtn addTarget:self action:@selector(cancelAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:_cancelBtn];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backupLab);
        make.right.offset(-18);
        make.width.offset(50);
        make.height.offset(40);
    }];
    
    _passwordTf = [[UITextField alloc] init];
    _passwordTf.backgroundColor = [UIColor colorWithHexString:@"#f7f8f9"];
    _passwordTf.delegate = self;
    NSString *backupText = @"请输入备份密码";
    NSMutableAttributedString *backupHolder = [[NSMutableAttributedString alloc] initWithString:backupText];
    [backupHolder addAttribute:NSForegroundColorAttributeName
                       value:kDarkGrayColor
                       range:NSMakeRange(0, backupText.length)];
    [backupHolder addAttribute:NSFontAttributeName
                       value:Font(15)
                       range:NSMakeRange(0, backupText.length)];
    _passwordTf.attributedPlaceholder = backupHolder;
    _passwordTf.keyboardType = UIKeyboardTypeAlphabet;
    _passwordTf.secureTextEntry = YES;
    [_footView addSubview:_passwordTf];
    [_passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backupLab).offset(65);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(49);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    [_footView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTf.mas_bottom).offset(0);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(1);
    }];
    
    UIImageView *imgAlert = [[UIImageView alloc] init];
    imgAlert.image = [UIImage imageNamed: @""];
    imgAlert.backgroundColor = kRedColor;
    [_footView addSubview:imgAlert];
    [imgAlert mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(30);
        make.top.equalTo(line.mas_bottom).offset(12);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    UILabel *aleartLab = [[UILabel alloc]init];
    aleartLab.text = @"重要提示：此备份密码需要所有私钥App持有者私下协商决定";
    aleartLab.textAlignment = NSTextAlignmentLeft;
    aleartLab.font = Font(13);
    aleartLab.textColor = kLightGrayColor;
    aleartLab.numberOfLines = 0;
    [_footView addSubview:aleartLab];
    [aleartLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imgAlert.mas_right).offset(5);
        make.width.offset(SCREEN_WIDTH - 30 - 55);
        make.top.equalTo(line.mas_bottom).offset(10);
        make.height.offset(40);
        
    }];
    
    _confirmBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_confirmBtn setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _confirmBtn.backgroundColor = RGB(76, 122, 253);
    //_confirmBtn.layer.borderWidth = 1.0f;
    //_confirmBtn.layer.borderColor = kLightGrayColor.CGColor;
    _confirmBtn.titleLabel.font = Font(17);
    [_confirmBtn addTarget:self action:@selector(confirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_footView addSubview:_confirmBtn];
    [_confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aleartLab.mas_bottom).offset(45);
        make.left.offset(30);
        make.right.offset(-30);
        make.height.offset(45);
        
    }];
    
    
}


-(void)touchTopViewAction:(UITapGestureRecognizer *)tap
{
   [self removeFromSuperview];
}

-(void)touchFootViewAction:(UITapGestureRecognizer *)tap
{
    [self endEditing:YES];
}

#pragma mark ----- 取消 -----
-(void)cancelAction:(UIButton *)btn
{
    [self removeFromSuperview];
    
}

#pragma mark ----- 备份密码确认 -----
-(void)confirmAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(backupViewDelegate:)]) {
        [self.delegate backupViewDelegate:_passwordTf.text];
    }
    
}

#pragma mark ----- KeyboardWillShow -----
- (void)keyboardWillShow:(NSNotification*)notification
{
    NSTimeInterval duration = [(notification.userInfo)[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [(notification.userInfo)[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    //获取用户信息
    //NSDictionary *userInfo = [NSDictionary dictionaryWithDictionary:notification.userInfo];
    //获取键盘高度
    //CGRect keyBoardBounds  = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    //CGFloat keyBoardHeight = keyBoardBounds.size.height;
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationCurveToAnimationOptions(curve) animations:^{
        self.footView.frame = CGRectMake(0, SCREEN_HEIGHT - 350 - 145,  SCREEN_WIDTH, 350);
        
    } completion:nil];
}

#pragma mark ----- KeyboardWillShow -----
-(void)keyboardWillHide:(NSNotification *)notification
{
    NSTimeInterval duration = [(notification.userInfo)[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [(notification.userInfo)[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationCurveToAnimationOptions(curve) animations:^{
 
        self.footView.frame = CGRectMake(0, SCREEN_HEIGHT - 350,  SCREEN_WIDTH, 350);
        
    } completion:nil];
 
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
