//
//  InitAccountViewController.m
//  box-Staff-Manager
//
//  Created by Rony on 2018/2/28.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "InitAccountViewController.h"
#import "ScanCodeViewController.h"

#define InitAccountVCTitle  @"扫一扫"
#define PerfectInformationVCLaber  @"扫一扫完成初始化"
#define PerfectInformationVCSubLaber  @"扫一扫MAC端的签名机完成初始化"
 
@interface InitAccountViewController ()
/** 开始扫描 */
@property(nonatomic, strong)UIButton *scanButton;

@end

@implementation InitAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = InitAccountVCTitle;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self createView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = kWhiteColor;
    self.navigationController.navigationBar.alpha = 1.0;
}

-(void)createView
{
    UIImageView *imgView = [[UIImageView alloc] init];
    imgView.image = [UIImage imageNamed: @"scanBoxIcon"];
    [self.view addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(35 + kTopHeight);
        make.centerX.equalTo(self.view);
        make.width.offset(SCREEN_WIDTH - 60*2);
        make.height.offset(SCREEN_WIDTH - 60*2 - 30);
    }];
    
    UILabel *laber = [[UILabel alloc] init];
    laber.text = PerfectInformationVCLaber;
    laber.textAlignment = NSTextAlignmentCenter;
    laber.font = FontBold(19);
    laber.textColor = [UIColor colorWithHexString:@"#444444"];
    [self.view addSubview:laber];
    [laber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imgView.mas_bottom).offset(35);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(54/2);
    }];
    
    UILabel *subLaber = [[UILabel alloc] init];
    subLaber.text = PerfectInformationVCSubLaber;
    subLaber.textAlignment = NSTextAlignmentCenter;
    subLaber.font = Font(12);
    subLaber.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.view addSubview:subLaber];
    [subLaber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(laber.mas_bottom).offset(21/2);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(34/2);
    }];
    
    _scanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_scanButton setImage:[UIImage imageNamed:@"startScanImg"] forState:UIControlStateNormal];
    _scanButton.titleLabel.font = Font(17);
    [_scanButton setTitleColor:kBlueColor forState:UIControlStateNormal];
    [_scanButton addTarget:self action:@selector(scanAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_scanButton];
    [_scanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(subLaber.mas_bottom).offset(188/2);
        make.centerX.equalTo(self.view);
        make.height.offset(80/2);
        make.width.offset(318/2);
    }];

}

#pragma mark ----- 开始扫描 -----
-(void)scanAction
{
    ScanCodeViewController *scanVC = [[ScanCodeViewController alloc]init];
    [self.navigationController pushViewController:scanVC animated:YES];
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
