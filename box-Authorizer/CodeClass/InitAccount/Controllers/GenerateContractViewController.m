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

@end

@implementation GenerateContractViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = RGB(73, 117, 254);
    self.title = @"生成合约";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = RGB(73, 117, 254);
    
    [self createView];
    
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.delegate = self;
    //添加ProgressHUD到界面中
    [self.view addSubview:self.progressHUD];
    
}

- (UIImage *) imageWithFrame:(CGRect)frame alphe:(CGFloat)alphe {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIColor *redColor = RGBA(73, 117, 254, 1.0);
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
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT + 80);
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
        make.left.offset(12);
        make.width.offset(SCREEN_WIDTH - 24);
        make.top.offset(10);
        make.height.offset(315);
    }];
    
    UIView *oneBackView = [[UIView alloc] init];
    oneBackView.backgroundColor = RGB(245, 247, 250);
    [oneView addSubview:oneBackView];
    [oneBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(40);
    }];
    
    UIImageView *scanIconImg = [[UIImageView alloc] init];
    scanIconImg.image = [UIImage imageNamed:@"scanIconImg"];
    scanIconImg.backgroundColor = kRedColor;
    [oneBackView addSubview:scanIconImg];
    [scanIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.width.offset(20);
        make.top.offset(10);
        make.height.offset(20);
    }];
    
    UILabel *scanLab = [[UILabel alloc] init];
    scanLab.text = @"请先向账户二维码充值";
    scanLab.textAlignment = NSTextAlignmentLeft;
    scanLab.font = Font(13);
    scanLab.textColor = kBlackColor;
    [oneBackView addSubview:scanLab];
    [scanLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(scanIconImg.mas_right).offset(5);
        make.height.offset(40);
        make.right.offset(0);
    }];
    
    _accountQRCodeImg = [[UIImageView alloc] init];
    _accountQRCodeImg.image = [CIQRCodeManager createImageWithString:@"hahahah"];
    [oneView addSubview:_accountQRCodeImg];
    [_accountQRCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneBackView.mas_bottom).offset(20);
        make.centerX.equalTo(oneView);
        make.height.offset(170);
        make.width.offset(170);
    }];
    
    _accountCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountCopyBtn setTitle:@"复制地址" forState:UIControlStateNormal];
    [_accountCopyBtn setTitleColor:RGB(76, 122, 253) forState:UIControlStateNormal];
    _accountCopyBtn.titleLabel.font = Font(13);
    [_accountCopyBtn addTarget:self action:@selector(accountCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:_accountCopyBtn];
    [_accountCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountQRCodeImg.mas_bottom).offset(8);
        make.left.equalTo(_accountQRCodeImg.mas_left).offset(0);
        make.width.offset(170/2);
        make.height.offset(30);
    }];
    
    _accountSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountSaveBtn setTitle:@"保存二维码" forState:UIControlStateNormal];
    [_accountSaveBtn setTitleColor:RGB(76, 122, 253) forState:UIControlStateNormal];
    _accountSaveBtn.titleLabel.font = Font(13);
    [_accountSaveBtn addTarget:self action:@selector(accountSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:_accountSaveBtn];
    [_accountSaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountQRCodeImg.mas_bottom).offset(8);
        make.right.equalTo(_accountQRCodeImg.mas_right).offset(0);
        make.width.offset(170/2);
        make.height.offset(30);
    }];
    
    _accountQRLab = [[UILabel alloc] init];
    _accountQRLab.text = @"0x74817507891570huifw8032789878078x8907078446";
    _accountQRLab.textAlignment = NSTextAlignmentCenter;
    _accountQRLab.font = Font(13);
    _accountQRLab.textColor = kDarkGrayColor;
    [oneView addSubview:_accountQRLab];
    [_accountQRLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-12);
        make.top.equalTo(_accountSaveBtn.mas_bottom).offset(8);
        make.height.offset(20);
    }];
    
    
#pragma mark ----- 合约 -----
    UIView *twoView = [[UIView alloc] init];
    twoView.backgroundColor = kWhiteColor;
    twoView.layer.cornerRadius = 3.f;
    twoView.layer.masksToBounds = YES;
    [_contentView addSubview:twoView];
    [twoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.width.offset(SCREEN_WIDTH - 24);
        make.top.equalTo(oneView.mas_bottom).offset(10);
        make.height.offset(315);
    }];
    
    UIView *twoBackView = [[UIView alloc] init];
    twoBackView.backgroundColor = RGB(245, 247, 250);
    [twoView addSubview:twoBackView];
    [twoBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(40);
    }];
    
    UIImageView *scanIconTwoImg = [[UIImageView alloc] init];
    scanIconTwoImg.image = [UIImage imageNamed:@"scanIconTwoImg"];
    scanIconTwoImg.backgroundColor = kRedColor;
    [twoBackView addSubview:scanIconTwoImg];
    [scanIconTwoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(10);
        make.width.offset(20);
        make.top.offset(10);
        make.height.offset(20);
    }];
    
    UILabel *scanTwoLab = [[UILabel alloc] init];
    scanTwoLab.text = @"合约二维码";
    scanTwoLab.textAlignment = NSTextAlignmentLeft;
    scanTwoLab.font = Font(13);
    scanTwoLab.textColor = kBlackColor;
    [twoBackView addSubview:scanTwoLab];
    [scanTwoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(scanIconTwoImg.mas_right).offset(5);
        make.height.offset(40);
        make.right.offset(0);
    }];
    
    _contractQRCodeImg = [[UIImageView alloc] init];
    _contractQRCodeImg.image = [CIQRCodeManager createImageWithString:@"hahahah"];
    [twoView addSubview:_contractQRCodeImg];
    [_contractQRCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(twoBackView.mas_bottom).offset(20);
        make.centerX.equalTo(twoView);
        make.height.offset(170);
        make.width.offset(170);
    }];
    
    _contractCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contractCopyBtn setTitle:@"复制地址" forState:UIControlStateNormal];
    [_contractCopyBtn setTitleColor:RGB(76, 122, 253) forState:UIControlStateNormal];
    //_contractCopyBtn.backgroundColor = RGB(76, 122, 253);
    _contractCopyBtn.titleLabel.font = Font(13);
    [_contractCopyBtn addTarget:self action:@selector(contractCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:_contractCopyBtn];
    [_contractCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contractQRCodeImg.mas_bottom).offset(8);
        make.left.equalTo(_contractQRCodeImg.mas_left).offset(0);
        make.width.offset(170/2);
        make.height.offset(30);
    }];
    _contractCopyBtn.hidden = YES;
    
    _contractSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_contractSaveBtn setTitle:@"保存二维码" forState:UIControlStateNormal];
    [_contractSaveBtn setTitleColor:RGB(76, 122, 253) forState:UIControlStateNormal];
    //_contractSaveBtn.backgroundColor = RGB(76, 122, 253);
    _contractSaveBtn.titleLabel.font = Font(13);
    [_contractSaveBtn addTarget:self action:@selector(contractSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:_contractSaveBtn];
    [_contractSaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contractQRCodeImg.mas_bottom).offset(8);
        make.right.equalTo(_contractQRCodeImg.mas_right).offset(0);
        make.width.offset(170/2);
        make.height.offset(30);
    }];
    _contractSaveBtn.hidden = YES;
    
    _contractQRLab = [[UILabel alloc] init];
    _contractQRLab.text = @"0x74817507891570huifw8032789878078x8907078446";
    _contractQRLab.textAlignment = NSTextAlignmentCenter;
    _contractQRLab.font = Font(13);
    _contractQRLab.textColor = kDarkGrayColor;
    [twoView addSubview:_contractQRLab];
    [_contractQRLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-12);
        make.top.equalTo(_contractSaveBtn.mas_bottom).offset(8);
        make.height.offset(20);
    }];
    _contractQRLab.hidden = YES;
    
    _privateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_privateBtn setTitle:@"输入私钥密码" forState:UIControlStateNormal];
    [_privateBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _privateBtn.backgroundColor = RGB(76, 122, 253);
    _privateBtn.titleLabel.font = Font(15);
    [_privateBtn addTarget:self action:@selector(privateAction:) forControlEvents:UIControlEventTouchUpInside];
    [twoView addSubview:_privateBtn];
    [_privateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_contractQRCodeImg.mas_bottom).offset(20);
        make.left.offset(55);
        make.right.offset(-55);
        make.height.offset(40);
    }];
    _privateBtn.hidden = NO;
    
    _serviceStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_serviceStartBtn setTitle:@"启动服务" forState:UIControlStateNormal];
    [_serviceStartBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _serviceStartBtn.backgroundColor = RGB(76, 122, 253);
    _serviceStartBtn.titleLabel.font = Font(15);
    [_serviceStartBtn addTarget:self action:@selector(serviceStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_serviceStartBtn];
    [_serviceStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(45);
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
    } else {
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
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
        _privateBtnState = 1;
        
        _privatePasswordView = [[PrivatePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _privatePasswordView.delegate = self;
        [[UIApplication sharedApplication].keyWindow addSubview:_privatePasswordView];
        
        
    }else if(_privateBtnState == 1){
        _contractCopyBtn.hidden = NO;
        _contractSaveBtn.hidden = NO;
        _contractQRLab.hidden = NO;
        _privateBtn.hidden = YES;
        _serviceStartBtn.hidden = NO;
        
        _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT + 100);
        _contentView.contentOffset = CGPointMake(0, _contentView.contentSize.height - _contentView.bounds.size.height);
    }
}

#pragma mark ----- PrivatePasswordViewDelegate -----
- (void)PrivatePasswordViewDelegate:(NSString *)passwordStr
{
    [_privatePasswordView removeFromSuperview];
    [_privateBtn setTitle:@"刷新" forState:UIControlStateNormal];
    _contractCopyBtn.hidden = YES;
    _contractSaveBtn.hidden = YES;
    _contractQRLab.hidden = YES;
    _privateBtn.hidden = NO;
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
