//
//  AwaitBackupViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/9.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AwaitBackupViewController.h"
#import "BlueToothListViewController.h"

@interface AwaitBackupViewController ()

@property(nonatomic, strong)UILabel *timeLab;

@property(nonatomic, strong)UILabel *contentLab;

@property (nonatomic,strong)NSTimer *timer;
/** 计时 */
@property (nonatomic,assign) NSInteger currentTime;

@property (nonatomic, strong) UIButton *nextButton;

@end

@implementation AwaitBackupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    [self createView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimeAction:) userInfo:nil repeats:YES];
    
}

-(void)createView
{
    _timeLab = [[UILabel alloc] init];
    _timeLab.text = @"0S";
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.font = Font(17);
    _timeLab.textColor = kBlackColor;
    _timeLab.numberOfLines = 1;
    _timeLab.layer.borderWidth = 1.0f;
    _timeLab.layer.borderColor = kDarkGrayColor.CGColor;
    [self.view addSubview:_timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.view).offset(-100);
        make.centerX.equalTo(self.view);
        make.height.offset(70);
        make.width.offset(70);
    }];
    
    _contentLab = [[UILabel alloc] init];
    _contentLab.text = @"等待第二个私钥App持有者输入正确的备份密码";
    _contentLab.textAlignment = NSTextAlignmentCenter;
    _contentLab.font = Font(17);
    _contentLab.textColor = kBlackColor;
    _contentLab.numberOfLines = 0;
    [self.view addSubview:_contentLab];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_timeLab.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.height.offset(60);
        make.width.offset(SCREEN_WIDTH - 100);
    }];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    [_nextButton setTitleColor:kWhiteColor forState:UIControlStateNormal];
     _nextButton.backgroundColor = RGB(76, 122, 253);
    _nextButton.titleLabel.font = Font(17);
    [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.width.offset(SCREEN_WIDTH - 40);
        make.top.equalTo(_contentLab.mas_bottom).offset(40);
        make.height.offset(45);
    }];
    _nextButton.hidden = YES;
    
}

-(void)nextAction:(UIButton *)btn
{
    BlueToothListViewController *blueToothListVC = [[BlueToothListViewController alloc] init];
    UINavigationController *blueToothListNV = [[UINavigationController alloc] initWithRootViewController:blueToothListVC];
    [self presentViewController:blueToothListNV animated:YES completion:nil];

}


-(void)updateTimeAction:(NSTimer *)timer
{
    _currentTime += 1;
    _timeLab.text = [NSString stringWithFormat:@"%ld%@", _currentTime, @"S"];
    if (_currentTime == 2) {
        _contentLab.text = @"等待第三个私钥App持有者输入正确的备份密码";
    }
    
    if (_currentTime == 2) {
        _contentLab.text = @"所有私钥App持有者输入备份密码正确";
    }
    
    if (_currentTime == 3) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
        }
        _nextButton.hidden = NO;
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
