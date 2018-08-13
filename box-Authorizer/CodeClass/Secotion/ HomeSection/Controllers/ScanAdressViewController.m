//
//  ScanAdressViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ScanAdressViewController.h"

@interface ScanAdressViewController ()<UIScrollViewDelegate, UITextFieldDelegate,MBProgressHUDDelegate>
{
    NSTimer *registTimer;
    NSTimer *codeTimer;
}
@property(nonatomic, strong)UIScrollView *contentView;
/** 授权码 */
@property(nonatomic, strong)UIImageView *accountQRCodeImg;
@property(nonatomic, strong)UILabel *detailLab;
@property(nonatomic, strong)UIButton *authorizeBtn;
@property(nonatomic, strong)MBProgressHUD *progressHUD;
@property(nonatomic, strong)UIView *aleartView;
@property(nonatomic, strong)NSString *randomStr;
@property(nonatomic, strong)NSString *ipPort;

@end

@implementation ScanAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    self.title = ScanAdressVCTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#292e40"];
    [self createBarItem];
    [self createView];
    [self initProgressHUD];
    [self getManagerIpPort];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(screenShotAction) name:UIApplicationUserDidTakeScreenshotNotification  object:nil];
}

#pragma mark ----- ScreenshotNotification -----
-(void)screenShotAction
{
    _accountQRCodeImg.image = [CIQRCodeManager createImageWithString:[self generateAuthorizationCode]];
}

-(void)getManagerIpPort
{
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/msinfo" params:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        NSInteger RspNo = [dict[@"RspNo"] integerValue];
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            _ipPort = dict[@"ManagerIpPort"];
        }else{
            [ProgressHUD showStatus:RspNo];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

#pragma mark ----- 绑定二维码30秒变化一次 -----
-(void)codeChange:(NSTimer *)timer
{
   _accountQRCodeImg.image = [CIQRCodeManager createImageWithString:[self generateAuthorizationCode]];
}

-(NSString *)generateAuthorizationCode
{
    if (_ipPort == nil) {
        _ipPort = @"";
    }
    NSString *box_IP = _ipPort;
    _randomStr = [JsonObject getRandomStringWithNum:8];
    NSArray *codeArray = [NSArray arrayWithObjects:box_IP, _randomStr, [BoxDataManager sharedManager].app_account_id, nil];
    NSString *codeSting = [JsonObject dictionaryToarrJson:codeArray];
    return codeSting;
}

#pragma mark ----- 私钥APP轮询注册申请 -----
-(void)registrationsPending:(NSTimer *)timer
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"captainid"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/registlist" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] isEqualToString:@"0"] && ![dict[@"RegistInfos"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dic in dict[@"RegistInfos"]) {
                [self handleRegistrationsPending:dic];
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

#pragma mark ----- 私钥APP提交注册审批意见 -----
-(void)handleRegistrationsPending:(NSDictionary *)dic
{
    //Status 0 -创建 1-拒绝 2 -同意
    NSString *manager_id = dic[@"CaptainId"]; //直属上级唯一标识符
    if (![[BoxDataManager sharedManager].app_account_id isEqualToString:manager_id]) {
        return;
    }
    NSString *status = dic[@"Status"];//0暂无结果 1拒绝 2同意
    if ([status isEqualToString:@"2"] || [status isEqualToString:@"1"]) {
        return;
    }
    NSString *msg = dic[@"Msg"]; //加密后的注册信息, string
    NSString *applyer_id = dic[@"ApplyerId"]; //申请者唯一标识符
    NSString *reg_id = dic[@"RegId"]; //服务端申请表ID
    NSString *applyer_Account = dic[@"ApplyerAccount"]; //申请者账户
    NSString *randomString = [FSAES128 AES128DecryptString:msg keyStr:_randomStr];
    if (randomString == nil) {
        NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
        [paramsDic setObject:reg_id forKey:@"regid"];
        [paramsDic setObject:@(1) forKey:@"status"];
        [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/agent/registaproval" params:paramsDic success:^(id responseObject) {
            NSDictionary *dict = responseObject;
            if ([dict[@"RspNo"] integerValue] == 0) {
                NSLog(@"------------------%@", dict[@"message"]);
            }
        } fail:^(NSError *error) {
            NSLog(@"%@", error.description);
        }];
        return;
    }else{
        NSArray *randomArray = [JsonObject dictionaryWithJsonStringArr:randomString];
        NSString *applyer_pub_key = randomArray[1];
        NSString *menber_random = randomArray[0];
        NSDictionary *menberDic = @{@"menber_id":applyer_id,
                                    @"menber_account":applyer_Account,
                                    @"publicKey":applyer_pub_key,
                                    @"menber_random":menber_random,
                                    @"directIdentify":@(1)
                                    };
        MemberInfoModel *model = [[MemberInfoModel alloc] initWithDict:menberDic];
        if (applyer_pub_key !=  nil) {
            //该账号对申请者公钥生成的信息摘要
            NSString *hmacSHA256 = [UIARSAHandler hmac:applyer_pub_key withKey:menber_random];
            NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
            [paramsDic setObject:reg_id forKey:@"regid"];
            [paramsDic setObject:applyer_pub_key forKey:@"pubkey"];
            [paramsDic setObject:hmacSHA256 forKey:@"ciphertext"];
            [paramsDic setObject:@(2) forKey:@"status"];
            [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/agent/registaproval" params:paramsDic success:^(id responseObject) {
                NSDictionary *dict = responseObject;
                if ([dict[@"RspNo"] integerValue] == 0) {
                    NSLog(@"------------------%@", dict[@"message"]);
                    [[MemberInfoManager sharedManager] insertMenberInfoModel:model];
                    [[NewsInfoModel sharedManager] insertNewsInfoNews:[NSString stringWithFormat:@"授权码被%@扫描", applyer_Account]];
                }
            } fail:^(NSError *error) {
                NSLog(@"%@", error.description);
            }];
        }
    }
}

- (UIImage *) imageWithFrame:(CGRect)frame alphe:(CGFloat)alphe {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIColor *redColor = [UIColor colorWithHexString:@"#292e40"];;
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [redColor CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)initProgressHUD
{
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.delegate = self;
    //添加ProgressHUD到界面中
    [self.view addSubview:self.progressHUD];
}

-(void)createView
{
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight - 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kTopHeight - 64) )];
    _contentView.delegate = self;
    //滚动的时候消失键盘
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT + 1);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    UIView *oneView = [[UIView alloc] init];
    oneView.backgroundColor = kWhiteColor;
    oneView.layer.cornerRadius = 3.f;
    oneView.layer.masksToBounds = YES;
    [_contentView addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.width.offset(SCREEN_WIDTH - 34);
        make.top.offset(35);
        make.height.offset(699/2);
    }];
    
    UIView *oneBackView = [[UIView alloc] init];
    oneBackView.backgroundColor = [UIColor colorWithHexString:@"#f5f7fa"];
    [oneView addSubview:oneBackView];
    [oneBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(45);
    }];
    
    UIImageView *scanIconImg = [[UIImageView alloc] init];
    scanIconImg.image = [UIImage imageNamed:@"scanIconImg"];
    [oneBackView addSubview:scanIconImg];
    [scanIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(14);
        make.centerY.equalTo(oneBackView);
        make.height.offset(14);
    }];
    
    UILabel *scanLab = [[UILabel alloc] init];
    scanLab.text = ScanAdressVCScanLab;
    scanLab.textAlignment = NSTextAlignmentLeft;
    scanLab.font = Font(13);
    scanLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [oneBackView addSubview:scanLab];
    [scanLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(scanIconImg.mas_right).offset(8);
        make.height.offset(45);
        make.right.offset(0);
    }];
    
    _accountQRCodeImg = [[UIImageView alloc] init];
    _accountQRCodeImg.image = [CIQRCodeManager createImageWithString:@"hahahah"];
    [oneView addSubview:_accountQRCodeImg];
    [_accountQRCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneBackView.mas_bottom).offset(79/2);
        make.centerX.equalTo(oneView);
        make.height.offset(370/2);
        make.width.offset(370/2);
    }];

    _detailLab = [[UILabel alloc] init];
    _detailLab.text = ScanAdressVCDetailLab;
    _detailLab.textAlignment = NSTextAlignmentCenter;
    _detailLab.font = Font(11);
    _detailLab.textColor = [UIColor colorWithHexString:@"#8e9299"];
    [oneView addSubview:_detailLab];
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-12);
        make.top.equalTo(_accountQRCodeImg.mas_bottom).offset(41.0/2.0);
        make.height.offset(31.0/2.0);
    }];
    [self createAleartView];
}


-(void)createAleartView
{
    _aleartView = [[UIView alloc] init];
    _aleartView.backgroundColor = kWhiteColor;
    _aleartView.layer.cornerRadius = 3.f;
    _aleartView.layer.masksToBounds = YES;
    [_contentView addSubview:_aleartView];
    [_aleartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.width.offset(SCREEN_WIDTH - 34);
        make.top.offset(35);
        make.height.offset(699/2);
    }];
    
    UIImageView *thiefImg = [[UIImageView alloc] init];
    thiefImg.image = [UIImage imageNamed:@"icon_thief"];
    [_aleartView addSubview:thiefImg];
    [thiefImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(60);
        make.centerX.equalTo(_aleartView);
        make.width.offset(120);
        make.height.offset(187.0/2.0);
    }];
    
    UILabel *aleartLab = [[UILabel alloc] init];
    aleartLab.text = ScanAdressVCAleartLab;
    aleartLab.textAlignment = NSTextAlignmentCenter;
    aleartLab.font = Font(15);
    aleartLab.numberOfLines = 0;
    aleartLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_aleartView addSubview:aleartLab];
    [aleartLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.right.offset(-40);
        make.top.equalTo(thiefImg.mas_bottom).offset(30);
        make.height.offset(42);
    }];
    
    UIButton *achieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [achieveBtn setTitle:ScanAdressVCIknown forState:UIControlStateNormal];
    achieveBtn.titleLabel.font = Font(14);
    achieveBtn.layer.cornerRadius = 38.0/2.0;
    achieveBtn.layer.masksToBounds = YES;
    achieveBtn.layer.borderWidth = 1.0f;
    achieveBtn.layer.borderColor = [UIColor colorWithHexString:@"#4c7afd"].CGColor;
    [achieveBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    [achieveBtn addTarget:self action:@selector(achieveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_aleartView addSubview:achieveBtn];
    [achieveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aleartLab.mas_bottom).offset(45);
        make.centerX.equalTo(_aleartView);
        make.height.offset(38);
        make.width.offset(130);
    }];
}

-(void)achieveBtnAction:(UIButton *)btn
{
    _aleartView.hidden = YES;
    _accountQRCodeImg.image = [CIQRCodeManager createImageWithString:[self generateAuthorizationCode]];
    registTimer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(registrationsPending:) userInfo:nil repeats:YES];
    //绑定二维码30秒变化一次
    codeTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f target:self selector:@selector(codeChange:) userInfo:nil repeats:YES];
}

#pragma mark ----- createBarItem -----
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    if (_aleartView.hidden) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:ScanAdressVCAlertMessage preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:Affirm style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [registTimer invalidate];
            registTimer = nil;
            [codeTimer invalidate];
            codeTimer = nil;
            [self dismissViewControllerAnimated:YES completion:nil];
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
            
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:Cancel style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationUserDidTakeScreenshotNotification object:nil];
    }
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
