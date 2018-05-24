//
//  EditCurrencyViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/11.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "EditCurrencyViewController.h"
#import "ScanCodeViewController.h"

#define AddCurrencyVCTitle  @"代币编辑"
#define AddCurrencyVCCurrencyNameTf  @"请输入代币名称"
#define AddCurrencyVCCurrencyAdressTf  @"请输入代币地址"
#define AddCurrencyVCaccuracyTf  @"请输入代币精度 (位数)"

@interface EditCurrencyViewController ()<UIScrollViewDelegate, UITextFieldDelegate>

@property(nonatomic, strong)UIScrollView *contentView;
/** 代币名称 */
@property (nonatomic,strong)UITextField *currencyNameTf;
/** 代币地址 */
@property (nonatomic,strong)UITextField *currencyAdressTf;
/** 代币精度 */
@property (nonatomic,strong)UITextField *accuracyTf;
 /** 提交 */
@property (nonatomic, strong) UIButton *cormfirmButton;
/** 二维码扫描 */
@property (nonatomic, strong) UIButton *scanButton;

@property (nonatomic, strong) DDRSAWrapper *aWrapper;

@end

@implementation EditCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.title = AddCurrencyVCTitle;
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createBarItem];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *shadowImage = self.navigationController.navigationBar.shadowImage;
    self.navigationController.navigationBar.shadowImage = shadowImage;
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    self.navigationController.navigationBar.tintColor = nil;
    self.navigationController.navigationBar.barTintColor = nil;
    self.navigationController.navigationBar.alpha = 1.0;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kBlackColor}];
}

-(void)createView
{
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight - 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kTopHeight - 64))];
    _contentView.delegate = self;
    //滚动的时候消失键盘
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - 60);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    _currencyNameTf = [[UITextField alloc]init];
    _currencyNameTf.backgroundColor = [UIColor whiteColor];
    _currencyNameTf.delegate = self;
    _currencyNameTf.text = _model.TokenName;
    _currencyNameTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    NSString *nameText = AddCurrencyVCCurrencyNameTf;
    NSMutableAttributedString *nameholder = [[NSMutableAttributedString alloc] initWithString:nameText];
    [nameholder addAttribute:NSForegroundColorAttributeName
                       value:[UIColor colorWithHexString:@"#cccccc"]
                       range:NSMakeRange(0, nameText.length)];
    [nameholder addAttribute:NSFontAttributeName
                       value:Font(14)
                       range:NSMakeRange(0, nameText.length)];
    _currencyNameTf.attributedPlaceholder = nameholder;
    [_contentView addSubview:_currencyNameTf];
    [_currencyNameTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
        make.height.offset(56);
    }];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_currencyNameTf.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
        make.height.offset(1);
    }];
    
    _currencyAdressTf = [[UITextField alloc]init];
    _currencyAdressTf.backgroundColor = [UIColor whiteColor];
    _currencyAdressTf.delegate = self;
    _currencyAdressTf.text = _model.ContractAddr;
    NSString *adressStr = AddCurrencyVCCurrencyAdressTf;
    NSMutableAttributedString *AdressHolder = [[NSMutableAttributedString alloc] initWithString:adressStr];
    [AdressHolder addAttribute:NSForegroundColorAttributeName
                         value:[UIColor colorWithHexString:@"#cccccc"]
                         range:NSMakeRange(0, adressStr.length)];
    [AdressHolder addAttribute:NSFontAttributeName
                         value:Font(14)
                         range:NSMakeRange(0, adressStr.length)];
    _currencyAdressTf.attributedPlaceholder = AdressHolder;
    [_contentView addSubview:_currencyAdressTf];
    [_currencyAdressTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 50 - 16);
        make.height.offset(56);
    }];
    
    UIImageView *scanImg = [[UIImageView alloc] init];
    scanImg.image = [UIImage imageNamed:@"AddCurrencyScanIcon"];
    [_contentView addSubview:scanImg];
    [scanImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_currencyAdressTf);
        make.left.offset(SCREEN_WIDTH - 40);
        make.width.offset(18);
        make.height.offset(18);
    }];
    
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scanButton addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_scanButton];
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_currencyAdressTf);
        make.left.offset(SCREEN_WIDTH - 50);
        make.width.offset(45);
        make.height.offset(55);
    }];
    
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_currencyAdressTf.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
        make.height.offset(1);
    }];
    
    _accuracyTf = [[UITextField alloc]init];
    _accuracyTf.backgroundColor = [UIColor whiteColor];
    _accuracyTf.delegate = self;
    _accuracyTf.text = [NSString stringWithFormat:@"%ld", _model.Decimals];
    NSString *accuracyStr = AddCurrencyVCaccuracyTf;
    _accuracyTf.keyboardType = UIKeyboardTypeASCIICapableNumberPad;
    _accuracyTf.clearButtonMode=UITextFieldViewModeWhileEditing;
    NSMutableAttributedString *accuracyHolder = [[NSMutableAttributedString alloc] initWithString:accuracyStr];
    [accuracyHolder addAttribute:NSForegroundColorAttributeName
                           value:[UIColor colorWithHexString:@"#cccccc"]
                           range:NSMakeRange(0, accuracyStr.length)];
    [accuracyHolder addAttribute:NSFontAttributeName
                           value:Font(14)
                           range:NSMakeRange(0, accuracyStr.length)];
    _accuracyTf.attributedPlaceholder = accuracyHolder;
    [_contentView addSubview:_accuracyTf];
    [_accuracyTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineTwo.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
        make.height.offset(56);
    }];
    
    UIView *lineThree = [[UIView alloc] init];
    lineThree.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineThree];
    [lineThree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_accuracyTf.mas_bottom).offset(0);
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
        make.height.offset(1);
    }];
    
    _cormfirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cormfirmButton setTitle:@"确认增加" forState:UIControlStateNormal];
    [_cormfirmButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _cormfirmButton.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _cormfirmButton.titleLabel.font = Font(16);
    _cormfirmButton.layer.masksToBounds = YES;
    _cormfirmButton.layer.cornerRadius = 2.0f;
    [_cormfirmButton addTarget:self action:@selector(cormfirmAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_cormfirmButton];
    [_cormfirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
        make.top.equalTo(lineThree.mas_bottom).offset(50);
        make.height.offset(45);
    }];
}



#pragma mark ------ 二维码扫描 -----
-(void)scanAction:(UIButton *)btn
{
    ScanCodeViewController *scanCodeVC = [[ScanCodeViewController alloc] init];
    scanCodeVC.fromFunction = fromHomeBox;
    scanCodeVC.codeBlock = ^(NSString *codeText){
        _currencyAdressTf.text = codeText;
    };
    [self.navigationController pushViewController:scanCodeVC animated:YES];
}

#pragma mark ------ 确认增加 -----
-(void)cormfirmAction:(UIButton *)btn
{
    if ( [_currencyNameTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:AddCurrencyVCCurrencyNameTf];
        return;
    }
    if ([_currencyAdressTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:AddCurrencyVCCurrencyAdressTf];
        return;
    }
    BOOL checkBool = [AddressVerifyManager checkAddressVerify:_currencyAdressTf.text type:@"ETH"];
    if (!checkBool) {
        [WSProgressHUD showErrorWithStatus:AddressVerifyETHError];
        return;
    }
    if ([_accuracyTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:AddCurrencyVCaccuracyTf];
        return;
    }
    
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:_currencyAdressTf.text privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    NSInteger accuracy = [_accuracyTf.text integerValue];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject: _currencyNameTf.text forKey:@"tokenname"];
    [paramsDic setObject:_currencyAdressTf.text forKey:@"contractaddr"];
    [paramsDic setObject:@(accuracy) forKey:@"decimals"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"applyerid"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/agent/tokenedit" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] integerValue] == 0) {
            [WSProgressHUD showSuccessWithStatus:@"新增成功"];
            if ([self.delegate respondsToSelector:@selector(editCurrencyDelegateReflesh)]) {
                [self.navigationController popViewControllerAnimated:YES];
                [self.delegate editCurrencyDelegateReflesh];
            }
            
        }else{
            [ProgressHUD showStatus:[dict[@"RspNo"] integerValue]];
        }
    } fail:^(NSError *error) {
        [WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
    }];
}

#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
    
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
    //[self dismissViewControllerAnimated:YES completion:nil];
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
