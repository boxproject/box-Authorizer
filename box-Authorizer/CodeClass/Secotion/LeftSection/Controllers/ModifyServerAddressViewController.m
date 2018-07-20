//
//  ModifyServerAddressViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ModifyServerAddressViewController.h"
#define ModifyServerAddressVCTitle  @"修改服务器地址"
#define ModifyServerAddressVCAddress  @"地址"
#define ModifyServerAddressVCInfo  @"请输入服务器地址"
#define ModifyServerAddressVCAleartSucceed  @"修改成功"
#define ModifyServerAddressVCVerifyBtn  @"确认修改"


@interface ModifyServerAddressViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *contentView;
@property (nonatomic,strong)UITextField *addressTf;
@property (nonatomic,strong)UIButton *verifyBtn;

@end

@implementation ModifyServerAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.title = ModifyServerAddressVCTitle;
    self.navigationController.navigationBar.hidden = NO;
    [self createView];
    [self createBarItem];
}

-(void)createView
{
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight - 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kTopHeight - 64))];
    _contentView.delegate = self;
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - 60);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    //地址
    UIView *addressView = [[UIView alloc] init];
    addressView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_contentView addSubview:addressView];
    [addressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(50);
    }];
    
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textAlignment = NSTextAlignmentLeft;
    addressLab.font = Font(14);
    addressLab.text = ModifyServerAddressVCAddress;
    addressLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [addressView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(16);
        make.width.offset(50);
    }];
    
    _addressTf = [[UITextField alloc] init];
    _addressTf.font = Font(14);
    _addressTf.placeholder = ModifyServerAddressVCInfo;
    _addressTf.delegate = self;
    _addressTf.text = [BoxDataManager sharedManager].box_IpPort;
    _addressTf.textColor = [UIColor colorWithHexString:@"#333333"];
    _addressTf.keyboardType = UIKeyboardTypeAlphabet;
    [addressView addSubview:_addressTf];
    [_addressTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(addressLab.mas_right).offset(35);
        make.right.offset(-16);
        make.top .offset(0);
        make.bottom.offset(0);
    }];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [_contentView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressView.mas_bottom).offset(0);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(1);
    }];
    
    _verifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_verifyBtn setTitle:ModifyServerAddressVCVerifyBtn forState:UIControlStateNormal];
    [_verifyBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _verifyBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _verifyBtn.titleLabel.font = Font(16);
    _verifyBtn.layer.masksToBounds = YES;
    _verifyBtn.layer.cornerRadius = 2.0f;
    [_verifyBtn addTarget:self action:@selector(verifyAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_verifyBtn];
    [_verifyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(50);
        make.left.offset(15);
        make.width.offset(SCREEN_WIDTH - 30);
        make.height.offset(46);
    }];
}

-(void)verifyAction:(UIButton *)Btn
{
    if ([_addressTf.text isEqualToString:@""]) {
        [WSProgressHUD showErrorWithStatus:ModifyServerAddressVCInfo];
        return;
    }
    [[BoxDataManager sharedManager] saveDataWithCoding:@"box_IpPort" codeValue:_addressTf.text];
    NSString *boxIpStr = [NSString stringWithFormat:@"https://%@", _addressTf.text];
    [[BoxDataManager sharedManager] saveDataWithCoding:@"box_IP" codeValue:boxIpStr];
    [self.navigationController popViewControllerAnimated:YES];
    [WSProgressHUD showSuccessWithStatus:ModifyServerAddressVCVerifyBtn];
    [self.sidePanelController setCenterPanelHidden:NO];
    self.navigationController.navigationBar.hidden = YES;
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
    [self.sidePanelController setCenterPanelHidden:NO];
    //[self.sidePanelController showCenterPanelAnimated:NO];
    self.navigationController.navigationBar.hidden = YES;
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
