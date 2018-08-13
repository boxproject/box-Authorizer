//
//  AboutBoxViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AboutBoxViewController.h"

@interface AboutBoxViewController ()

@end

@implementation AboutBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.navigationController.navigationBar.hidden = NO;
    self.title = AboutBOX;
    [self createBarItem];
    [self createView];
}

-(void)createView
{
    UIImage *image = [UIImage imageNamed:@"icon_aboutus"];
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    [self.view addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(76 + kTopHeight);
        make.centerX.equalTo(self.view);
        make.height.offset(100);
        make.width.offset(70);
    }];
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    UILabel *versonlab = [[UILabel alloc] init];
    versonlab.text = [NSString stringWithFormat:@"%@ V%@",CurrentVersion,app_Version];
    versonlab.font = Font(14);
    versonlab.textAlignment = NSTextAlignmentCenter;
    versonlab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.view addSubview:versonlab];
    [versonlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(imageView.mas_bottom).offset(15);
        make.centerX.equalTo(self.view);
        make.height.offset(20);
        make.width.offset(230);
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
