//
//  AccountAdressDetailViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AccountAdressDetailViewController.h"

@interface AccountAdressDetailViewController () <UIScrollViewDelegate, UITextFieldDelegate,MBProgressHUDDelegate>

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

@property(nonatomic, strong)MBProgressHUD *progressHUD;

@end

@implementation AccountAdressDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    self.title = _titleAccount;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#292e40"];
    
    [self createBarItem];
    [self createView];
    
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
        make.left.offset(17);
        make.width.offset(SCREEN_WIDTH - 34);
        make.top.offset(35);
        make.height.offset(732/2);
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
    scanLab.text = @"账户地址";
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
        make.top.equalTo(oneBackView.mas_bottom).offset(78/2);
        make.centerX.equalTo(oneView);
        make.height.offset(370/2);
        make.width.offset(370/2);
    }];
    
    _accountCopyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountCopyBtn setTitle:@"复制地址" forState:UIControlStateNormal];
    [_accountCopyBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    _accountCopyBtn.titleLabel.font = Font(13);
    [_accountCopyBtn addTarget:self action:@selector(accountCopyAction:) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:_accountCopyBtn];
    [_accountCopyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountQRCodeImg.mas_bottom).offset(20);
        make.left.equalTo(_accountQRCodeImg.mas_left).offset(0);
        make.width.offset(370/4);
        make.height.offset(19);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithHexString:@"#dddddd"];
    [oneView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(oneView);
        make.centerY.equalTo(_accountCopyBtn);
        make.width.offset(1);
        make.height.offset(14);
    }];
    
    
    _accountSaveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_accountSaveBtn setTitle:@"保存二维码" forState:UIControlStateNormal];
    [_accountSaveBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    _accountSaveBtn.titleLabel.font = Font(13);
    [_accountSaveBtn addTarget:self action:@selector(accountSaveAction:) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:_accountSaveBtn];
    [_accountSaveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accountQRCodeImg.mas_bottom).offset(20);
        make.right.equalTo(_accountQRCodeImg.mas_right).offset(0);
        make.width.offset(370/4);
        make.height.offset(19);
    }];
    
    _accountQRLab = [[UILabel alloc] init];
    _accountQRLab.text = @"0x74817507891570huifw8032789878078x8907078446";
    _accountQRLab.textAlignment = NSTextAlignmentCenter;
    _accountQRLab.font = Font(11);
    _accountQRLab.textColor = [UIColor colorWithHexString:@"#8e9299"];
    [oneView addSubview:_accountQRLab];
    [_accountQRLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-12);
        make.top.equalTo(_accountSaveBtn.mas_bottom).offset(14);
        make.height.offset(15);
    }];
    
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
        [SVProgressHUD dismissWithDelay:1.0];
    } else {
        [SVProgressHUD showSuccessWithStatus:@"成功保存到相册"];
        [SVProgressHUD dismissWithDelay:1.0];
    }
}


#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
    
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
