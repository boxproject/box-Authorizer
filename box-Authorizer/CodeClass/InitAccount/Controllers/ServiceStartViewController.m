//
//  ServiceStartViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/14.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ServiceStartViewController.h"
#import "HomepageViewController.h"


#define ServiceStartTitle  @"启动服务"
#define ServiceStartLaunchState  @"启动中"
#define ServiceStartPassword  @"请输入私钥密码"
#define ServiceStartRepassword  @"请再次输入私钥密码"
#define ServiceStartCommitStart  @"同意启动"
#define ServiceStartAwaitBtn  @"已等待时间"
#define ServiceStartUse  @"开始使用"
#define ServiceStateTitle  @"启动成功"
#define ServiceStateDetail  @"继续等待下一位私钥App持有者启动服务"

@interface ServiceStartViewController ()<UITextFieldDelegate,UIScrollViewDelegate>

@property(nonatomic, strong)UIScrollView *contentView;
@property(nonatomic, strong)UIImageView *topImageView;
/** 启动状态 */
@property (nonatomic,strong)LYButton *launchState;

@property (nonatomic,strong)TBButton *oneStaff;
@property (nonatomic,strong)TBButton *twoStaff;
@property (nonatomic,strong)TBButton *threeStaff;
/** 输入并确认私钥密码 */
@property (nonatomic,strong)UIView *importView;
@property (nonatomic,strong)UITextField *passwordTf;
@property (nonatomic,strong)UITextField *rePasswordTf;
@property (nonatomic,strong)UIButton *commitStartBtn;
/** 启动状态 */
@property (nonatomic,strong)UIView *startStateView;
@property (nonatomic,strong)UILabel *awaitTimeLab;
@property (nonatomic,strong)UILabel *stateTitleLab;
@property (nonatomic,strong)UILabel *statedetailLab;
@property (nonatomic,strong)UIButton *stateUseBtn;

@property (nonatomic,strong)NSTimer *timer;
/** 计时 */
@property (nonatomic,assign) NSInteger currentTime;


@end

@implementation ServiceStartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = kWhiteColor;
    self.title = ServiceStartTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = RGB(41, 46, 64);
    [self createView];
    
    
    
}

- (UIImage *) imageWithFrame:(CGRect)frame alphe:(CGFloat)alphe {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIColor *redColor = RGBA(41, 46, 64, 1.0);
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
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight - 64, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
    _contentView.delegate = self;
    //滚动的时候消失键盘
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT - kTopHeight + 5);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0,  SCREEN_WIDTH, 195)];
    _topImageView.image = [UIImage imageNamed:@"ServiceStartTopImg"];
    _topImageView.backgroundColor = kLightGrayColor;
    [_contentView addSubview:_topImageView];
    
    _launchState = [LYButton buttonWithType:UIButtonTypeCustom];
    [_launchState setTitle:ServiceStartLaunchState forState:UIControlStateNormal];
    [_launchState setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _launchState.titleLabel.font = Font(13);
    [_launchState setImage:[UIImage imageNamed:@"launchStateImg"] forState:UIControlStateNormal];
    //[launchState addTarget:self action:@selector(launchStateAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topImageView addSubview:_launchState];
    [_launchState mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(10);
        make.left.offset(15);
        make.width.offset(65);
        make.height.offset(25);
    }];
    
    CGFloat staffWidth = 70;
    CGFloat staffHeight = 120;
    CGFloat leftStaf = 35;
    CGFloat topStaf = 20;
    CGFloat distanceStaf = (_topImageView.frame.size.width - leftStaf * 2 - staffWidth * 3) / 2 ;
    
    _oneStaff = [TBButton buttonWithType:UIButtonTypeCustom];//highlight
    [_oneStaff setTitle:@"张博" forState:UIControlStateNormal];
    [_oneStaff setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _oneStaff.titleLabel.font = Font(15);
    [_oneStaff setImage:[UIImage imageNamed:@"staffStateHigh"] forState:UIControlStateNormal];
    //[_oneStaff setImage:[UIImage imageNamed:@"staffStateGray"] forState:UIControlStateNormal];
    //[_oneStaff addTarget:self action:@selector(oneStaffAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topImageView addSubview:_oneStaff];
    [_oneStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_launchState.mas_bottom).offset(topStaf);
        make.left.offset(leftStaf);
        make.width.offset(staffWidth);
        make.height.offset(staffHeight);
    }];
    
    _twoStaff = [TBButton buttonWithType:UIButtonTypeCustom];//highlight
    [_twoStaff setTitle:@"马化腾" forState:UIControlStateNormal];
    [_twoStaff setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _twoStaff.titleLabel.font = Font(15);
    [_twoStaff setImage:[UIImage imageNamed:@"staffStateHigh"] forState:UIControlStateNormal];
    //[_oneStaff setImage:[UIImage imageNamed:@"staffStateGray"] forState:UIControlStateNormal];
    //[_oneStaff addTarget:self action:@selector(oneStaffAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topImageView addSubview:_twoStaff];
    [_twoStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_launchState.mas_bottom).offset(topStaf);
        make.left.equalTo(_oneStaff.mas_right).offset(distanceStaf);
        make.width.offset(staffWidth);
        make.height.offset(staffHeight);
    }];
    
    _threeStaff = [TBButton buttonWithType:UIButtonTypeCustom];//highlight
    [_threeStaff setTitle:@"雷军" forState:UIControlStateNormal];
    [_threeStaff setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _threeStaff.titleLabel.font = Font(15);
    [_threeStaff setImage:[UIImage imageNamed:@"staffStateHigh"] forState:UIControlStateNormal];
    //[_oneStaff setImage:[UIImage imageNamed:@"staffStateGray"] forState:UIControlStateNormal];
    //[_oneStaff addTarget:self action:@selector(oneStaffAction:) forControlEvents:UIControlEventTouchUpInside];
    [_topImageView addSubview:_threeStaff];
    [_threeStaff mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_launchState.mas_bottom).offset(topStaf);
        make.left.equalTo(_twoStaff.mas_right).offset(distanceStaf);
        make.width.offset(staffWidth);
        make.height.offset(staffHeight);
    }];
                 
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1.0];
    [_topImageView insertSubview:lineView belowSubview:_oneStaff];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_oneStaff.imageView.mas_left).offset(staffWidth/2);
        make.top.equalTo(_oneStaff.imageView.mas_top).offset(_oneStaff.imageView.frame.size.height/2 + 0.5);
        make.right.equalTo(_threeStaff.imageView.mas_left).offset(staffWidth/2);
        make.height.offset(1);
    }];
    
    //输入密码
    _importView = [[UIView alloc] init];
    _importView.backgroundColor = kWhiteColor;
    [_contentView addSubview:_importView];
    [_importView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topImageView.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(130);
    }];
    
    UITapGestureRecognizer *tapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchTopViewAction:)];
    _importView.userInteractionEnabled = YES;
    [_importView addGestureRecognizer:tapOne];
    
    _passwordTf = [[UITextField alloc] init];
    _passwordTf.backgroundColor = kWhiteColor;
    _passwordTf.delegate = self;
    NSString *passwordText = ServiceStartPassword;
    NSMutableAttributedString *backupHolder = [[NSMutableAttributedString alloc] initWithString:passwordText];
    [backupHolder addAttribute:NSForegroundColorAttributeName
                         value:kLightGrayColor
                         range:NSMakeRange(0, passwordText.length)];
    [backupHolder addAttribute:NSFontAttributeName
                         value:Font(13)
                         range:NSMakeRange(0, passwordText.length)];
    _passwordTf.attributedPlaceholder = backupHolder;
    _passwordTf.keyboardType = UIKeyboardTypeAlphabet;
    _passwordTf.secureTextEntry = YES;
    [_importView addSubview:_passwordTf];
    [_passwordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(18);
        make.right.offset(-18);
        make.height.offset(49);
    }];
    
    UIView *lineOne = [[UIView alloc] init];
    lineOne.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    [_importView addSubview:lineOne];
    [lineOne mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_passwordTf.mas_bottom).offset(0);
        make.left.offset(18);
        make.right.offset(-18);
        make.height.offset(1);
    }];
    
    _rePasswordTf = [[UITextField alloc] init];
    _rePasswordTf.backgroundColor = kWhiteColor;
    _rePasswordTf.delegate = self;
    NSString *rePasswordText = ServiceStartRepassword;
    NSMutableAttributedString *reBackupHolder = [[NSMutableAttributedString alloc] initWithString:rePasswordText];
    [reBackupHolder addAttribute:NSForegroundColorAttributeName
                         value:kLightGrayColor
                         range:NSMakeRange(0, rePasswordText.length)];
    [reBackupHolder addAttribute:NSFontAttributeName
                         value:Font(13)
                         range:NSMakeRange(0, rePasswordText.length)];
    _rePasswordTf.attributedPlaceholder = reBackupHolder;
    _rePasswordTf.keyboardType = UIKeyboardTypeAlphabet;
    _rePasswordTf.secureTextEntry = YES;
    [_importView addSubview:_rePasswordTf];
    [_rePasswordTf mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineOne.mas_bottom).offset(0);
        make.left.offset(18);
        make.right.offset(-18);
        make.height.offset(49);
    }];
    
    UIView *lineTwo = [[UIView alloc] init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    [_importView addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_rePasswordTf.mas_bottom).offset(0);
        make.left.offset(18);
        make.right.offset(-18);
        make.height.offset(1);
    }];
    
    _commitStartBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_commitStartBtn setTitle:ServiceStartCommitStart forState:UIControlStateNormal];
    [_commitStartBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _commitStartBtn.backgroundColor = RGB(76, 122, 253);
    //_commitStartBtn.layer.borderWidth = 1.0f;
    //_commitStartBtn.layer.borderColor = kLightGrayColor.CGColor;
    _commitStartBtn.titleLabel.font = Font(17);
    [_commitStartBtn addTarget:self action:@selector(commitStartAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_commitStartBtn];
    [_commitStartBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_importView.mas_bottom).offset(20);
        make.left.offset(18);
        make.width.offset(SCREEN_WIDTH - 36);
        make.height.offset(45);
    }];
    
}

-(void)createStartStateView
{
    _startStateView = [[UIView alloc] init];
    _startStateView.backgroundColor = kWhiteColor;
    [_contentView addSubview:_startStateView];
    [_startStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topImageView.mas_bottom).offset(0);
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.height.offset(280);
    }];
    
    UIImageView *circleImg = [[UIImageView alloc] init];
    circleImg.backgroundColor = kLightGrayColor;
    circleImg.image = [UIImage imageNamed:@"circleStateImg"];
    [_startStateView addSubview:circleImg];
    [circleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(30);
        make.centerX.equalTo(_startStateView).offset(0);
        make.width.offset(150);
        make.height.offset(150);
    }];
    
    LYButton *awaitBtn = [LYButton buttonWithType:UIButtonTypeCustom];
    [awaitBtn setTitle:ServiceStartAwaitBtn forState:UIControlStateNormal];
    [awaitBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    awaitBtn.titleLabel.font = Font(12);
    [awaitBtn setImage:[UIImage imageNamed:@"awaitStateImg"] forState:UIControlStateNormal];
    //[launchState addTarget:self action:@selector(launchStateAction:) forControlEvents:UIControlEventTouchUpInside];
    [_startStateView addSubview:awaitBtn];
    [awaitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleImg.mas_top).offset(50);
        make.centerX.equalTo(circleImg).offset(8);
        make.width.offset(100);
        make.height.offset(20);
    }];
  
    _awaitTimeLab = [[UILabel alloc] init];
    _awaitTimeLab.text = @"00:16";
    _awaitTimeLab.textAlignment = NSTextAlignmentCenter;
    _awaitTimeLab.font = FontBold(30);
    _awaitTimeLab.textColor = kBlackColor;
    _awaitTimeLab.numberOfLines = 1;
    [_startStateView addSubview:_awaitTimeLab];
    [_awaitTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(awaitBtn.mas_bottom).offset(15);
        make.centerX.equalTo(circleImg).offset(0);
        make.width.offset(200);
        make.height.offset(45);
    }];
    
    _stateTitleLab = [[UILabel alloc] init];
    _stateTitleLab.text = ServiceStateTitle;
    _stateTitleLab.textAlignment = NSTextAlignmentCenter;
    _stateTitleLab.font = FontBold(17);
    _stateTitleLab.textColor = kBlackColor;
    _stateTitleLab.numberOfLines = 1;
    [_startStateView addSubview:_stateTitleLab];
    [_stateTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleImg.mas_bottom).offset(5);
        make.left.offset(18);
        make.right.offset(-18);
        make.height.offset(30);
    }];
    
    _statedetailLab = [[UILabel alloc] init];
    _statedetailLab.text = ServiceStateDetail;
    _statedetailLab.textAlignment = NSTextAlignmentCenter;
    _statedetailLab.font = Font(13);
    _statedetailLab.textColor = kDarkGrayColor;
    _statedetailLab.numberOfLines = 1;
    [_startStateView addSubview:_statedetailLab];
    [_statedetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stateTitleLab.mas_bottom).offset(7);
        make.left.offset(18);
        make.right.offset(-18);
        make.height.offset(25);
    }];
    
    _stateUseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_stateUseBtn setTitle:ServiceStartCommitStart forState:UIControlStateNormal];
    [_stateUseBtn setTitleColor:kWhiteColor forState:UIControlStateNormal];
    _stateUseBtn.backgroundColor = RGB(76, 122, 253);
    //_commitStartBtn.layer.borderWidth = 1.0f;
    //_commitStartBtn.layer.borderColor = kLightGrayColor.CGColor;
    _stateUseBtn.titleLabel.font = Font(17);
    [_stateUseBtn addTarget:self action:@selector(startUseAction:) forControlEvents:UIControlEventTouchUpInside];
    [_startStateView addSubview:_stateUseBtn];
    [_stateUseBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_statedetailLab.mas_bottom).offset(10);
        make.left.offset(18);
        make.width.offset(SCREEN_WIDTH - 36);
        make.height.offset(45);
    }];
    
    _stateUseBtn.hidden = YES;
    
    
    
    
}





/*
-(void)oneStaffAction:(TBButton *)btn
{
    
}
 */

-(void)touchTopViewAction:(UITapGestureRecognizer *)tap
{
    [self.view endEditing:YES];
}

#pragma mark ----- commitStar -----
-(void)commitStartAction:(UIButton *)btn
{
    _importView.hidden = YES;
    _commitStartBtn.hidden = YES;
    [self createStartStateView];
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(updateTimeAction:) userInfo:nil repeats:YES];
    
}
-(void)updateTimeAction:(NSTimer *)timer
{
    _currentTime += 1;
    _awaitTimeLab.text = [TimeManeger minutesFormatString:(int)_currentTime];
    if (_currentTime == 5) {
        if (_timer) {
            [_timer invalidate];
            _timer = nil;
            _stateUseBtn.hidden = NO;
            _statedetailLab.hidden = YES;
        }
    }
}

#pragma mark ----- starUse -----
-(void)startUseAction:(UIButton *)btn
{
    HomepageViewController *homePageVC =  [[HomepageViewController alloc] init];
    [self presentViewController: homePageVC animated:YES completion:nil];
    
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
