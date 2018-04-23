//
//  GenerateContractViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/14.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "GenerateContractViewController.h"
#import "PrivatePasswordView.h"
#import "ServiceStartViewController.h"
#import "ServiceStartModel.h"

#define GenerateContractVCTitle  @"生成合约"
#define GenerateContractVCScanLab  @"请先向账户二维码充值"
#define GenerateContractVCAccountCopyBtn  @"复制地址"
#define GenerateContractVCAccountSaveBtn  @"保存二维码"
#define GenerateContractVCscanTwoLab  @"合约二维码"
#define GenerateContractVCprivateBtn  @"输入私钥密码"
#define GenerateContractVserviceStartBtn  @"启动服务"

@interface GenerateContractViewController ()<UIScrollViewDelegate, UITextFieldDelegate,PrivatePasswordViewDelegate,MBProgressHUDDelegate>

@property(nonatomic, strong)UIScrollView *contentView;
/** 账户二维码 */
@property(nonatomic, strong)UIImageView *accountQRCodeImg;
/** 合约二维码 */
@property(nonatomic, strong)UIImageView *contractQRCodeImg;
/** 复制地址-账户 */
@property(nonatomic, strong)UIButton  *accountCopyBtn;
/** 保存二维码-账户 */
@property(nonatomic, strong)UIButton  *accountSaveBtn;
/** 显示账户二维码 */
@property(nonatomic, strong)UILabel *accountQRLab;
/** 复制地址-合约 */
@property(nonatomic, strong)UIButton  *contractCopyBtn;
/** 保存二维码-合约 */
@property(nonatomic, strong)UIButton  *contractSaveBtn;
/** 显示合约二维码 */
@property(nonatomic, strong)UILabel *contractQRLab;
/** 输入私钥密码 */
@property(nonatomic, strong)UIButton *importCodeBtn;
/** 输入私钥APP／刷新 */
@property(nonatomic, strong)UIButton *privateBtn;

@property(nonatomic, assign)NSInteger privateBtnState;

@property(nonatomic, strong)PrivatePasswordView *privatePasswordView;
/** 启动服务 */
@property(nonatomic, strong)UIButton *serviceStartBtn;
@property(nonatomic, strong)MBProgressHUD *progressHUD;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;

@end

@implementation GenerateContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    self.title = GenerateContractVCTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#292e40"];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createView];
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.delegate = self;
    //添加ProgressHUD到界面中
    [self.view addSubview:self.progressHUD];
}

- (UIImage *) imageWithFrame:(CGRect)frame alphe:(CGFloat)alphe {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIColor *redColor = [UIColor colorWithHexString:@"#292e40"];
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [redColor CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)createView
{
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight - 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kTopHeight - 64) )];
    _contentView.delegate = self;
    //滚动的时候消失键盘
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), kTopHeight + 8 + 304 + 10 + 304 + 25);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
#pragma mark ----- 账户 -----
    UIView *oneView = [[UIView alloc] init];
    oneView.backgroundColor = kWhiteColor;
    oneView.layer.cornerRadius = 3.f;
    oneView.layer.masksToBounds = YES;
    [_contentView addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.top.offset(8);
        make.height.offset(304);
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
        make.centerY.equalTo(oneBackView);
        make.width.offset(15);
        make.height.offset(15);
    }];
    
    UILabel *scanLab = [[UILabel alloc] init];
    scanLab.text = GenerateContractVCScanLab;
    scanLab.textAlignment = NSTextAlignmentLeft;
    scanLab.font = Font(13);
    scanLab.textColor = [UIColor colorWithHexString:@"#444444"];
    [oneBackView addSubview:scanLab];
    [scanLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scanIconImg.mas_right).offset(5);
        make.centerY.equalTo(oneBackView);
        make.right.offset(-15);
        make.height.offset(20);
    }];
    
    _accountQRCodeImg = [[UIImageView alloc] init];
    _accountQRCodeImg.image = [CIQRCodeManager createImageWithString:[BoxDataManager sharedManager].Address];
    [oneView addSubview:_accountQRCodeImg];
    [_accountQRCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneBackView.mas_bottom).offset(23);
        make.centerX.equalTo(oneView);
        make.height.offset(149);
        make.width.offset(149);
    }];
    
    _accountCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountCopyBtn setTitle:GenerateContractVCAccountCopyBtn forState:UIControlStateNormal];
    [_accountCopyBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    _accountCopyBtn.titleLabel.font = Font(13);
    [_accountCopyBtn addTarget:self action:@selector(accountCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:_accountCopyBtn];
    [_accountCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountQRCodeImg.mas_bottom).offset(18);
        make.left.equalTo(_accountQRCodeImg.mas_left).offset(0);
        make.width.offset(148/2);
        make.height.offset(19);
    }];
    
    _accountSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountSaveBtn setTitle:GenerateContractVCAccountSaveBtn forState:UIControlStateNormal];
    [_accountSaveBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    _accountSaveBtn.titleLabel.font = Font(13);
    [_accountSaveBtn addTarget:self action:@selector(accountSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:_accountSaveBtn];
    [_accountSaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountQRCodeImg.mas_bottom).offset(18);
        make.right.equalTo(_accountQRCodeImg.mas_right).offset(0);
        make.width.offset(148/2);
        make.height.offset(19);
    }];
    
    _accountQRLab = [[UILabel alloc] init];
    _accountQRLab.text = [BoxDataManager sharedManager].Address;
    _accountQRLab.textAlignment = NSTextAlignmentCenter;
    _accountQRLab.font = Font(13);
    _accountQRLab.textColor = [UIColor colorWithHexString:@"#8e9299"];
    [oneView addSubview:_accountQRLab];
    [_accountQRLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(_accountSaveBtn.mas_bottom).offset(13);
        make.height.offset(15);
    }];
    
#pragma mark ----- 合约 -----
    UIView *twoView = [[UIView alloc] init];
    twoView.backgroundColor = kWhiteColor;
    twoView.layer.cornerRadius = 3.f;
    twoView.layer.masksToBounds = YES;
    [_contentView addSubview:twoView];
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.top.equalTo(oneView.mas_bottom).offset(10);
        make.height.offset(304);
    }];
    
    UIView *twoBackView = [[UIView alloc] init];
    twoBackView.backgroundColor = [UIColor colorWithHexString:@"#f5f7fa"];
    [twoView addSubview:twoBackView];
    [twoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(45);
    }];
    
    UIImageView *scanIconTwoImg = [[UIImageView alloc] init];
    scanIconTwoImg.image = [UIImage imageNamed:@"scanIconImg"];
    [twoBackView addSubview:scanIconTwoImg];
    [scanIconTwoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(twoBackView);
        make.width.offset(15);
        make.height.offset(15);
    }];
    
    UILabel *scanTwoLab = [[UILabel alloc] init];
    scanTwoLab.text = GenerateContractVCscanTwoLab;
    scanTwoLab.textAlignment = NSTextAlignmentLeft;
    scanTwoLab.font = Font(13);
    scanTwoLab.textColor = [UIColor colorWithHexString:@"#444444"];
    [twoBackView addSubview:scanTwoLab];
    [scanTwoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scanIconTwoImg.mas_right).offset(5);
        make.centerY.equalTo(twoBackView);
        make.right.offset(-15);
        make.height.offset(20);
    }];
    
    _contractQRCodeImg = [[UIImageView alloc] init];
    _contractQRCodeImg.image = [UIImage imageNamed:@"icon_ercode"];
    [twoView addSubview:_contractQRCodeImg];
    [_contractQRCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoBackView.mas_bottom).offset(23);
        make.centerX.equalTo(twoView);
        make.height.offset(149);
        make.width.offset(149);
    }];
    
    _contractCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contractCopyBtn setTitle:GenerateContractVCAccountCopyBtn forState:UIControlStateNormal];
    [_contractCopyBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    _contractCopyBtn.titleLabel.font = Font(13);
    [_contractCopyBtn addTarget:self action:@selector(contractCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:_contractCopyBtn];
    [_contractCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contractQRCodeImg.mas_bottom).offset(18);
        make.left.equalTo(_contractQRCodeImg.mas_left).offset(0);
        make.width.offset(148/2);
        make.height.offset(19);
    }];
    _contractCopyBtn.hidden = YES;
    
    _contractSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contractSaveBtn setTitle:GenerateContractVCAccountSaveBtn forState:UIControlStateNormal];
    [_contractSaveBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    _contractSaveBtn.titleLabel.font = Font(13);
    [_contractSaveBtn addTarget:self action:@selector(accountSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:_contractSaveBtn];
    [_contractSaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contractQRCodeImg.mas_bottom).offset(18);
        make.right.equalTo(_contractQRCodeImg.mas_right).offset(0);
        make.width.offset(148/2);
        make.height.offset(19);
    }];
    _contractSaveBtn.hidden = YES;
    
    _contractQRLab = [[UILabel alloc] init];
    _contractQRLab.textAlignment = NSTextAlignmentCenter;
    _contractQRLab.font = Font(13);
    _contractQRLab.textColor = [UIColor colorWithHexString:@"#8e9299"];
    [twoView addSubview:_contractQRLab];
    [_contractQRLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.right.offset(-15);
        make.top.equalTo(_contractSaveBtn.mas_bottom).offset(13);
        make.height.offset(15);
    }];
    _contractQRLab.hidden = YES;
    
    _privateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_privateBtn setTitle:GenerateContractVCprivateBtn forState:UIControlStateNormal];
    [_privateBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _privateBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _privateBtn.titleLabel.font = Font(14);
    _privateBtn.layer.cornerRadius = 37.0/2.0;
    _privateBtn.layer.masksToBounds = YES;
    [_privateBtn addTarget:self action:@selector(privateAction:) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:_privateBtn];
    [_privateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contractQRCodeImg.mas_bottom).offset(22);
        make.centerX.equalTo(twoView);
        make.width.offset(140);
        make.height.offset(37);
    }];
    _privateBtn.hidden = NO;
    
    _serviceStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_serviceStartBtn setTitle:GenerateContractVserviceStartBtn forState:UIControlStateNormal];
    [_serviceStartBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _serviceStartBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _serviceStartBtn.titleLabel.font = Font(16);
    [_serviceStartBtn addTarget:self action:@selector(serviceStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_serviceStartBtn];
    [_serviceStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(50);
    }];
    _serviceStartBtn.hidden = YES;
}

-(void)showProgressHUD
{
    self.progressHUD.mode = MBProgressHUDModeText;
    self.progressHUD.label.textColor = kWhiteColor;
    self.progressHUD.bezelView.backgroundColor=[UIColor blackColor];
    //self.progressHUD.dimBackground = YES; //设置有遮罩
    self.progressHUD.label.text = @"地址复制成功"; //设置进度框中的提示文字
    [self.progressHUD showAnimated:YES];
    [self.progressHUD hideAnimated:YES afterDelay:0.5];
}

#pragma mark ----- 复制地址／账户二维码 -----
-(void)accountCopyAction:(UIButton *)btn
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _accountQRLab.text;
    [self showProgressHUD];
}

#pragma mark ----- 保存二维码／账户二维码 -----
-(void)accountSaveAction:(UIButton *)btn
{
    [self saveImageView:_accountQRCodeImg];
}

-(void)saveImageView:(UIImageView *)img
{
    UIGraphicsBeginImageContextWithOptions(img.bounds.size, NO, 0);
    CGContextRef ctx =  UIGraphicsGetCurrentContext();
    [img.layer renderInContext:ctx];
    // 这个是要分享图片的样式(自定义的)
    UIImage * newImage = UIGraphicsGetImageFromCurrentImageContext();
    //保存到本地相机
    UIImageWriteToSavedPhotosAlbum(newImage,self,@selector(image:didFinishSavingWithError:contextInfo:),nil);
}

//保存相片的回调方法
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        [SVProgressHUD showErrorWithStatus:@"保存失败"];
        [SVProgressHUD dismissWithDelay:0.8];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
        [SVProgressHUD dismissWithDelay:0.8];
    }
}

#pragma mark ----- 复制地址／合约二维码 -----
-(void)contractCopyAction:(UIButton *)btn
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = _contractQRLab.text;
    [self showProgressHUD];
}

#pragma mark ----- 保存二维码／合约二维码 -----
-(void)contractSaveAction:(UIButton *)btn
{
    [self saveImageView:_contractQRCodeImg];
}

#pragma mark ----- 输入私钥密码／刷新 -----
-(void)privateAction:(UIButton *)btn
{
    if (_privateBtnState == 0) {
        _privatePasswordView = [[PrivatePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _privatePasswordView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_privatePasswordView];
    }else if(_privateBtnState == 1){
        [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/status" params:nil success:^(id responseObject) {
            NSDictionary *dict = responseObject;
            if ([dict[@"RspNo"] isEqualToString:@"0"]) {
                NSInteger ServerStatus = [dict[@"Status"][@"ServerStatus"] integerValue];
                NSInteger Status = [dict[@"Status"][@"Status"] integerValue];
                NSInteger Total = [dict[@"Status"][@"Total"] integerValue];
                NSArray *NodesAuthorizedArr = dict[@"Status"][@"NodesAuthorized"];
                if (NodesAuthorizedArr.count < Total) {
                    for (NSDictionary *NodesAuthorizedDic in NodesAuthorizedArr) {
                        ServiceStartModel *model = [[ServiceStartModel alloc] initWithDict:NodesAuthorizedDic];
                        if ([model.ApplyerId isEqualToString:[BoxDataManager sharedManager].app_account_id]) {
                            [WSProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"等待第%ld位私钥App输入密码", NodesAuthorizedArr.count + 1]];
                            return;
                        }
                    }
                }
                if (Status == 0) {
                    if (ServerStatus == 3){
                        //合约地址
                        NSString *ContractAddress = dict[@"Status"][@"ContractAddress"];
                        if (![ContractAddress isEqualToString:@""]) {
                            [[BoxDataManager sharedManager] saveDataWithCoding:@"ContractAddress" codeValue:ContractAddress];
                            _contractQRCodeImg.image = [CIQRCodeManager createImageWithString:ContractAddress];
                            _contractQRLab.text = ContractAddress;
                            _contractCopyBtn.hidden = NO;
                            _contractSaveBtn.hidden = NO;
                            _contractQRLab.hidden = NO;
                            _privateBtn.hidden = YES;
                            _serviceStartBtn.hidden = NO;
                            _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), kTopHeight + 8 + 304 + 10 + 304 + 25 + 50);
                            _contentView.contentOffset = CGPointMake(0, _contentView.contentSize.height - _contentView.bounds.size.height);
                        }
                    }
                }else if(Status == 1){
                    [WSProgressHUD showErrorWithStatus:@"校验密码输入错误，请重新输入私钥密码"];
                    [_privateBtn setTitle:GenerateContractVCprivateBtn forState:UIControlStateNormal];
                    _privateBtnState = 0;
                    
                }else if(Status == 2){
                    [WSProgressHUD showErrorWithStatus:@"服务异常"];
                }
            }
        } fail:^(NSError *error) {
            NSLog(@"%@", error.description);
        }];
    }
}

#pragma mark ----- PrivatePasswordViewDelegate -----
- (void)PrivatePasswordViewDelegate:(NSString *)passwordStr
{
    NSString *aesStr = [FSAES128 AES128EncryptStrig:passwordStr keyStr:[BoxDataManager sharedManager].randomValue];
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:aesStr privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    //BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:aesStr signature:signSHA256 publicStr:[BoxDataManager sharedManager].publicKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:aesStr forKey:@"password"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"applyerid"];
    [paramsDic setObject:@"2" forKey:@"type"];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/agent/operate" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        NSInteger RspNo = [dict[@"RspNo"] integerValue];
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            [WSProgressHUD showSuccessWithStatus:@"密码已提交，等待校验"];
            [_privatePasswordView removeFromSuperview];
            [_privateBtn setTitle:@"刷新" forState:UIControlStateNormal];
            _privateBtnState = 1;

        }else{
            [ProgressHUD showStatus:RspNo];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}


#pragma mark ----- 启动服务 -----
-(void)serviceStartAction:(UIButton *)btn
{
    ServiceStartViewController *serviceStartVC = [[ServiceStartViewController alloc] init];
    UINavigationController *serviceStartNV = [[UINavigationController alloc] initWithRootViewController:serviceStartVC];
    [self presentViewController:serviceStartNV animated:YES completion:nil];
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
