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
#import "AuthorizerInfoModel.h"
#import "HomepageViewController.h"
#import "LeftMenuViewController.h"

#define BackupVCContentlab  @"私钥App持有者正在连接..."
#define BackupVCbackupButton  @"立即备份"
#define BackupVCSVProgressOne  @"密码备份成功"
#define BackupVCWSProgressTwo  @"请等待下一位私钥App持有者连接..."

@interface BackupViewController ()<BackupViewDelegate>
{
    NSTimer *timer;
}

@property(nonatomic, strong)UILabel *contentlab;
/** 备份 */
@property(nonatomic, strong)UIButton *backupButton;

@property(nonatomic, strong)BackupView *backupView;

@property(nonatomic, strong)NSArray *backupArray;

@property (nonatomic, strong) DDRSAWrapper *aWrapper;

@end

@implementation BackupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createView];
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(getApprovalResult:) userInfo:nil repeats:YES];
}

#pragma mark ------ 私钥APP轮询注册审批结果 -----
-(void)getApprovalResult:(NSTimer *)timer
{
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/status" params:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            NSInteger ServerStatus = [dict[@"Status"][@"ServerStatus"] integerValue];
            if (ServerStatus == 1) {
                if([dict[@"Status"][@"KeyStoreStatus"] isKindOfClass:[NSNull class]]){
                    return ;
                }
                NSArray *array = dict[@"Status"][@"KeyStoreStatus"];
                _backupArray = array;
                for (NSDictionary *dic in array) {
                    AuthorizerInfoModel *model = [[AuthorizerInfoModel alloc] initWithDict:dic];
                    if ([model.ApplyerId isEqualToString:[BoxDataManager sharedManager].app_account_id]) {
                        AuthorizerInfoModel *modell = [[AuthorizerInfoModel alloc] initWithDict:array[array.count - 1]];
                        _contentlab.text = [NSString stringWithFormat:@"第%ld位私钥App持有者%@连接成功", array.count, modell.ApplyerName];
                    }
                }
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)createView
{
    UIImageView *boxIcon = [[UIImageView alloc] init];
    boxIcon.image = [UIImage imageNamed:@"icon_success"];
    [self.view addSubview:boxIcon];
    [boxIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.offset(110);
        make.width.offset(125);
        make.height.offset(100);
    }];
    
    _contentlab = [[UILabel alloc] init];
    _contentlab.text = BackupVCContentlab;
    _contentlab.textAlignment = NSTextAlignmentCenter;
    _contentlab.font = FontBold(17);
    _contentlab.textColor = [UIColor colorWithHexString:@"#444444"];
    _contentlab.numberOfLines = 2;
    [self.view addSubview:_contentlab];
    [_contentlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(boxIcon.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.width.offset(SCREEN_WIDTH - 160);
        make.height.offset(60);
    }];
    
    _backupButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backupButton setTitle:BackupVCbackupButton forState:UIControlStateNormal];
    [_backupButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _backupButton.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _backupButton.titleLabel.font = Font(16);
    _backupButton.layer.masksToBounds = YES;
    _backupButton.layer.cornerRadius = 2.0f;
    [_backupButton addTarget:self action:@selector(backupAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_backupButton];
    [_backupButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contentlab.mas_bottom).offset(58);
        make.left.offset(20);
        make.right.offset(-20);
        make.height.offset(45);
    }];
}

-(void)backupAction:(UIButton *)btn
{
//    if (_backupArray.count < 3) {
//        [WSProgressHUD showErrorWithStatus:BackupVCWSProgressTwo];
//        return;
//    }
    _backupView = [[BackupView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _backupView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_backupView];
    
}

#pragma mark ----- BackupViewDelegate 备份密码确认 -----
- (void)backupViewDelegate:(NSString *)passwordStr
{
    [timer invalidate];
    timer = nil;
    [_backupView removeFromSuperview];
    NSString *aesStr = [FSAES128 AES128EncryptStrig:passwordStr keyStr:[BoxDataManager sharedManager].randomValue];
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:aesStr privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    //BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:aesStr signature:signSHA256 publicStr:[BoxDataManager sharedManager].publicKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:aesStr forKey:@"password"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"applyerid"];
    [paramsDic setObject:@"1" forKey:@"type"];
    
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/agent/operate" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        NSInteger RspNo = [dict[@"RspNo"] integerValue];
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            [WSProgressHUD showSuccessWithStatus:BackupVCSVProgressOne];
            AwaitBackupViewController *awaitBpVC = [[AwaitBackupViewController alloc] init];
            [self presentViewController:awaitBpVC animated:YES completion:nil];
            NSString *backUpStr = [JsonObject dictionaryToarrJson:_backupArray];
            [[BoxDataManager sharedManager] saveDataWithCoding:@"KeyStoreStatus" codeValue:backUpStr];
            [[BoxDataManager sharedManager] saveDataWithCoding:@"codePassWord" codeValue:passwordStr];
        }else{
            [ProgressHUD showStatus:RspNo];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
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
