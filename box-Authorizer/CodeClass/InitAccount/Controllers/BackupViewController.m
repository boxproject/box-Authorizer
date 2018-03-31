//
//  BackupViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/8.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "BackupViewController.h"
#import "BackupView.h"
#import "AwaitBackupViewController.h"

@interface BackupViewController ()<BackupViewDelegate>

@property(nonatomic, strong)UILabel *contentlab;
/** 备份 */
@property(nonatomic, strong)UIButton *backupButton;

@property(nonatomic, strong)BackupView *backupView;

@end

@implementation BackupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createView];
    
}


-(void)createView
{
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = kWhiteColor;
    //contentView.userInteractionEnabled = YES;
    [self.view addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.offset(0);
        make.top.offset(100);
        make.height.offset(400);
    }];
    
    UIImageView *boxIcon = [[UIImageView alloc] init];
    boxIcon.image = [UIImage imageNamed:@"boxIcon"];
    [contentView addSubview:boxIcon];
    [boxIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView);
        make.top.offset(50);
        make.width.offset(70);
        make.height.offset(70);
    }];
    
    _contentlab = [[UILabel alloc] init];
    _contentlab.text = @"第一个私钥App持有者尚维斯连接成功";
    _contentlab.textAlignment = NSTextAlignmentCenter;
    _contentlab.font = FontBold(17);
    _contentlab.textColor = kBlackColor;
    _contentlab.numberOfLines = 2;
    [contentView addSubview:_contentlab];
    [_contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boxIcon.mas_bottom).offset(15);
        make.centerX.equalTo(contentView);
        make.width.offset(SCREEN_WIDTH - 160);
        make.height.offset(60);
    }];
    
    _backupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backupButton setTitle:@"立即备份" forState:UIControlStateNormal];
    [_backupButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    //@"#50b4ff"
    _backupButton.backgroundColor = RGB(76, 122, 253);
//    _backupButton.layer.borderWidth = 1.0f;
//    _backupButton.layer.borderColor = kLightGrayColor.CGColor;
    _backupButton.titleLabel.font = Font(17);
    
//    _backupButton.layer.masksToBounds = YES;
//    _backupButton.layer.cornerRadius = 5.0f;
    [_backupButton addTarget:self action:@selector(backupAction:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:_backupButton];
    [_backupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentlab.mas_bottom).offset(40);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(45);
        
    }];
    
    
    
    
    
}

-(void)backupAction:(UIButton *)btn
{
    _backupView = [[BackupView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backupView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_backupView];
    
}

#pragma mark ----- BackupViewDelegate 备份密码确认 -----
- (void)backupViewDelegate:(NSString *)passwordStr
{
    [_backupView removeFromSuperview];
    //显示遮盖
    [SVProgressHUD showWithStatus:@"正在备份"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    //当前延迟
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //隐藏遮盖
        [SVProgressHUD dismiss];
        AwaitBackupViewController *awaitBpVC = [[AwaitBackupViewController alloc] init];
        [self presentViewController:awaitBpVC animated:YES completion:nil];
    });
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
