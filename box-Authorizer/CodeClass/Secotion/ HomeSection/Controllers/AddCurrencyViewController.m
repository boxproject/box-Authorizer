//
//  AddCurrencyViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/18.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AddCurrencyViewController.h"
#import "ScanAdressViewController.h"

#define AddCurrencyVCTitle  @"新增代币"
#define AddCurrencyVCCurrencyNameTf  @"请输入代币名称"
#define AddCurrencyVCCurrencyAdressTf  @"请输入代币地址"
#define AddCurrencyVCaccuracyTf  @"请输入代币精度 (位数)"

@interface AddCurrencyViewController ()<UIScrollViewDelegate, UITextFieldDelegate>

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

@end

@implementation AddCurrencyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.title = AddCurrencyVCTitle;
    [self createBarItem];
    [self createView];
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
    NSString *accuracyStr = AddCurrencyVCaccuracyTf;
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
    //[_cormfirmButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    //@"#50b4ff"
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
    ScanAdressViewController *scanAdressVC = [[ScanAdressViewController alloc] init];
    [self.navigationController pushViewController:scanAdressVC animated:YES];
}

#pragma mark ------ 确认增加 -----
-(void)cormfirmAction:(UIButton *)btn
{
    
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
