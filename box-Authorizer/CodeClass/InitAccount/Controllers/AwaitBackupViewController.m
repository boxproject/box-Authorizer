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

#define ServiceStartAwaitBtn  @"已等待时间"

@interface AwaitBackupViewController ()
{
    NSTimer *timer;
    NSTimer *timerNet;
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
    _currentTime = 0;
    timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimeAction:) userInfo:nil repeats:YES];
    timerNet = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(getBackUpResult:) userInfo:nil repeats:YES];
}

-(void)getBackUpResult:(NSTimer *)Timer
{
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/status" params:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            NSInteger ServerStatus = [dict[@"Status"][@"ServerStatus"] integerValue];
            if (ServerStatus == 1){
                if([dict[@"Status"][@"NodesAuthorized"] isKindOfClass:[NSNull class]]){
                    return;
                }
                NSArray *array = dict[@"Status"][@"NodesAuthorized"];
                for (NSDictionary *dic in array) {
                    AuthorizerInfoModel *model = [[AuthorizerInfoModel alloc] initWithDict:dic];
                    if ([model.ApplyerId isEqualToString:[BoxDataManager sharedManager].app_account_id]) {
                        _contentLab.text = [NSString stringWithFormat:@"等待第%ld个私钥App持有者输入正确的备份密码", array.count + 1];
                    }
                }
            }else if (ServerStatus == 2){
                [timer invalidate];
                timer = nil;
                [timerNet invalidate];
                timerNet = nil;
                NSString *Address = dict[@"Status"][@"Address"];
                [[BoxDataManager sharedManager] saveDataWithCoding:@"Address" codeValue:Address];
                _nextButton.hidden = NO;
                _contentLab.text = @"所有私钥App持有者都已正确输入备份密码";
            }
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
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
    _contentLab.text = @"等待下一个私钥App持有者输入正确的备份密码";
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
    [_nextButton setTitle:@"下一步" forState:UIControlStateNormal];
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
