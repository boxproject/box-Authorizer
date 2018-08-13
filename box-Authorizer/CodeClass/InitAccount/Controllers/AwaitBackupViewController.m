//
//  AwaitBackupViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/9.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AwaitBackupViewController.h"
#import "BlueToothListViewController.h"
#import "AuthorizerInfoModel.h"
#import "GenerateContractViewController.h"

@interface AwaitBackupViewController ()
{
    NSTimer *timer;
    NSTimer *timerNet;
    NSInteger statusIn;
}

@property(nonatomic, strong)UILabel *timeLab;
@property(nonatomic, strong)UILabel *contentLab;
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
    [self createTimer];
}

-(void)createTimer
{
    _currentTime = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimeAction:) userInfo:nil repeats:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        timerNet = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(getBackUpResult:) userInfo:nil repeats:YES];
    });
}

-(void)getBackUpResult:(NSTimer *)Timer
{
    [self requestAgentStatus];
}

#pragma mark ------ 拉取签名机状态信息 -----
-(void)requestAgentStatus
{
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/status" params:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            NSInteger ServerStatus = [dict[@"Status"][@"ServerStatus"] integerValue];
            NSInteger Status = [dict[@"Status"][@"Status"] integerValue];
            //NSInteger Total = [dict[@"Status"][@"Total"] integerValue];
            NSString *stringD = dict[@"Status"][@"D"];
            if (ServerStatus == 1){
                if([dict[@"Status"][@"NodesAuthorized"] isKindOfClass:[NSNull class]]){
                    return;
                }
                if (Status == 2) {
                    [self handleStatus:Status];
                    return;
                }
                NSArray *array = dict[@"Status"][@"NodesAuthorized"];
                for (NSDictionary *dic in array) {
                    AuthorizerInfoModel *model = [[AuthorizerInfoModel alloc] initWithDict:dic];
                    if ([model.ApplyerId isEqualToString:[BoxDataManager sharedManager].app_account_id]) {
                        _contentLab.text = [NSString stringWithFormat:@"等待第%ld个私钥App持有者输入正确的备份密码", array.count + 1];
                        _nextButton.hidden = YES;
                    }
                }
            }else if (ServerStatus == 2){
                [timer invalidate];
                timer = nil;
                [timerNet invalidate];
                timerNet = nil;
                NSString *Address = dict[@"Status"][@"Address"];
                [[BoxDataManager sharedManager] saveDataWithCoding:@"Address" codeValue:Address];
                [[BoxDataManager sharedManager] saveDataWithCoding:@"stringD" codeValue:stringD];
                _nextButton.hidden = NO;
                [_nextButton setTitle:NextStep forState:UIControlStateNormal];
                statusIn = 0;
                _contentLab.text = AwaitBackupVCContentLabText;
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)handleStatus:(NSInteger)status
{
    _contentLab.text = AwaitBackupVCContentLabStatusText;
    _nextButton.hidden = NO;
    [_nextButton setTitle:AwaitBackupVnextButtonTitle forState:UIControlStateNormal];
    statusIn = status;
}

-(void)createView
{
    UIImageView *circleImg = [[UIImageView alloc] init];
    circleImg.image = [UIImage imageNamed:@"circleStateImg"];
    [self.view addSubview:circleImg];
    [circleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(SCREEN_HEIGHT/2 - 230);
        make.centerX.equalTo(self.view);
        make.width.offset(150);
        make.height.offset(150);
    }];
    
    _timeLab = [[UILabel alloc] init];
    _timeLab.text = @"00:00";
    _timeLab.textAlignment = NSTextAlignmentCenter;
    _timeLab.font = FontBold(30);
    _timeLab.textColor = kBlackColor;
    _timeLab.numberOfLines = 1;
    [circleImg addSubview:_timeLab];
    [_timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(65);
        make.centerX.equalTo(circleImg).offset(0);
        make.width.offset(200);
        make.height.offset(45);
    }];
   
    _contentLab = [[UILabel alloc] init];
    _contentLab.text = AwaitBackupVCContentLabNextText;
    _contentLab.textAlignment = NSTextAlignmentCenter;
    _contentLab.font = Font(17);
    _contentLab.textColor = [UIColor colorWithHexString:@"#444444"];
    _contentLab.numberOfLines = 0;
    [self.view addSubview:_contentLab];
    [_contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleImg.mas_bottom).offset(30);
        make.centerX.equalTo(self.view);
        make.height.offset(60);
        make.width.offset(SCREEN_WIDTH - 100);
    }];
    
    _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextButton setTitle:NextStep forState:UIControlStateNormal];
    [_nextButton setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
     _nextButton.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _nextButton.titleLabel.font = Font(16);
    _nextButton.layer.cornerRadius = 2.0f;
    _nextButton.layer.masksToBounds = YES;
    [_nextButton addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_nextButton];
    [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.width.offset(SCREEN_WIDTH - 40);
        make.top.equalTo(_contentLab.mas_bottom).offset(42);
        make.height.offset(45);
    }];
    _nextButton.hidden = YES;
}

-(void)nextAction:(UIButton *)btn
{
    if (statusIn == 2) {
        [timer invalidate];
        timer = nil;
        [timerNet invalidate];
        timerNet = nil;
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    BlueToothListViewController *blueToothListVC = [[BlueToothListViewController alloc] init];
    UINavigationController *blueToothListNV = [[UINavigationController alloc] initWithRootViewController:blueToothListVC];
    [self presentViewController:blueToothListNV animated:YES completion:nil];
}

-(void)updateTimeAction:(NSTimer *)timer
{
    _currentTime += 1;
    _timeLab.text = [TimeManeger minutesFormatString:(int)_currentTime];
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
