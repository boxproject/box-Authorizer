//
//  HomepageViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/15.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "HomepageViewController.h"
#import "SeviceStateView.h"
#import "CurrencyAccountViewController.h"
#import "ApprovalBusinessViewController.h"
#import "ScanAdressViewController.h" //授权码
#import "NewsModel.h"
#import "NewsTableViewCell.h"
#import "PrivatePasswordView.h"
#import "AboutBoxViewController.h"
#import "UIViewController+JASidePanel.h"
#import "CoinlistModel.h"

#define CellReuseIdentifier  @"Homepage"
#define HomepageMidOneLabStop  @"关停"
#define HomepageMidOneLabStart  @"启动"
#define HomepageMidOneLabDetailStop  @"您的服务为启动状态"
#define HomepageMidOneLabDetailStart  @"您的服务为关停状态"
#define HomepageMidOneLabDetailError  @"您的服务异常"
#define HomepageMidTwoLab  @"币种开户"
#define HomepageMidThreeLab  @"审批业务流"
#define HomepageMidFourLab  @"授权码"
#define HomepageMidFourDetailLab  @"授权员工最高权限"
#define HomepageFootTitle  @"最新动态"
#define HomepageTitle  @"首页"
#define HomepageNoApproval  @"暂无待审批"
#define HomepageNoCurrency  @"暂无开户币种"

@interface HomepageViewController ()<UIScrollViewDelegate, SeviceStateViewDelegate,UITableViewDelegate, UITableViewDataSource,PrivatePasswordViewDelegate>
{
    NSTimer *timer;
}
@property(nonatomic, strong)UIScrollView *contentView;
@property (nonatomic,strong)UIImageView *topView;
@property (nonatomic,strong)UIView *middleView;
@property (nonatomic,strong)UIView *middleOneView;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)UIButton *menuBtn;
@property (nonatomic,strong)UILabel *middleOneLab;
@property (nonatomic,strong)UILabel *middleOneDetailLab;
@property (nonatomic,strong)UILabel *middleTwoDetailLab;
@property (nonatomic,strong)UILabel *middleThreeDetailLab;
@property (nonatomic,strong)UILabel *middleFourDetailLab;
@property (nonatomic,strong)UILabel *footTitleLab;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,strong)UILabel *labelTip;
@property (nonatomic,strong)SeviceStateView *seviceStateView;
@property (nonatomic,strong)PrivatePasswordView *privatePasswordView;
@property (nonatomic,strong)NSMutableArray *agentStatusArray;
@property (nonatomic,assign)NSInteger firstInit;
@property (nonatomic,strong)DDRSAWrapper *aWrapper;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ededee"];
    self.title = HomepageTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) hexString:@"4867FF"];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"4867FF"];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self createMenberInfo];
    _sourceArray = [[NSMutableArray alloc] init];
    _agentStatusArray = [[NSMutableArray alloc] init];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createView];
    [self createBarItem];
    _firstInit = 1;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNextVCAction:) name:@"pushNextVC" object:nil];
    [[NewsInfoModel sharedManager] insertNewsInfoNews:@"打开私钥App"];
    [self loadNews];
    timer = [NSTimer scheduledTimerWithTimeInterval:2.0f target:self selector:@selector(agentStatusTimer:) userInfo:nil repeats:YES];
    [self headRefresh];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadNews];
}

#pragma mark ------ 签名机状态查询 -----
-(void)agentStatusTimer:(NSTimer *)timer
{
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/status" params:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            NSInteger Status = [dict[@"Status"][@"Status"] integerValue];
            NSInteger ServerStatus = [dict[@"Status"][@"ServerStatus"] integerValue];
            if (ServerStatus == NotConnectedStatus) {
                [_agentStatusArray addObject:@(AgentStatusError)];
                [self seviceType:NotConnectedStatus];
            }else{
                [_agentStatusArray addObject:@(AgentStatusStable)];
                if (ServerStatus == StartedServiceStatus) {
                    if ([BoxDataManager sharedManager].serverStatus != ServerStatus) {
                        [BoxDataManager sharedManager].serverStatus = ServerStatus;
                        [self seviceType:StartedServiceStatus];
                    }
                }else if(ServerStatus == StoppedServiceStatus) {
                    if (Status == 1) {
                        if ([_middleOneLab.text isEqualToString:@"等待校验"]) {
                            _middleOneView.userInteractionEnabled = NO;
                        }else{
                            if ([BoxDataManager sharedManager].serverStatus != ServerStatus) {
                                [BoxDataManager sharedManager].serverStatus = ServerStatus;
                                [self seviceType:StoppedServiceStatus];
                            }
                        }
                    }else if(Status == 0) {
                        if ([BoxDataManager sharedManager].serverStatus != ServerStatus) {
                            [BoxDataManager sharedManager].serverStatus = ServerStatus;
                            [self seviceType:StoppedServiceStatus];
                        }
                    }
                }
            }
            if ([BoxDataManager sharedManager].serverStatus != ServerStatus) {
                if (ServerStatus == NotConnectedStatus) {
                    [BoxDataManager sharedManager].serverStatus  = ServerStatus;
                    [self showAgentState:AgentStatusError];
                }else{
                    [BoxDataManager sharedManager].serverStatus  = ServerStatus;
                    _showAgentStatus = [self getAgentStatusProbability];
                    [self showAgentState:_showAgentStatus];
                }
            }
            if (_firstInit == 1) {
                if (ServerStatus == NotConnectedStatus) {
                    [BoxDataManager sharedManager].serverStatus  = ServerStatus;
                    [self showAgentState:AgentStatusError];
                }else{
                    [BoxDataManager sharedManager].serverStatus  = ServerStatus;
                    _showAgentStatus = [self getAgentStatusProbability];
                    [self showAgentState:_showAgentStatus];
                }
                _firstInit = 0;
            }
        }
    } fail:^(NSError *error) {
        [_agentStatusArray addObject:@(AgentStatusError)];
        if (_showAgentStatus != 0) {
            [self showAgentState:_showAgentStatus];
        }
        NSLog(@"%@", error.description);
    }];
}

-(void)showAgentState:(NSInteger)state
{
    NSString *hexString;
    if (state == AgentStatusError) {
        hexString = @"DE3917";
        _topView.image = [UIImage imageNamed:@"image_home_red"];
    }else if(state == AgentStatusNoStable){
        hexString = @"F17B00";
        _topView.image = [UIImage imageNamed:@"image_home_yellow"];
    }else{
       hexString = @"4867FF";
        _topView.image = [UIImage imageNamed:@"homePageTopImg"];
    }
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) hexString: hexString];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:hexString];
}

#pragma mark ------ 0：异常 1:不稳定 2:稳定 -----
-(NSInteger)getAgentStatusProbability
{
    if (_agentStatusArray.count == 6) {
        [_agentStatusArray removeObjectAtIndex:0];
        NSInteger stateAll = 0;
        for (int i = 0; i < _agentStatusArray.count; i++) {
            NSInteger stateIn = [_agentStatusArray[i] integerValue];
            if (stateIn == 0) {
                stateAll += 1;
            }
        }
        if (stateAll >1) {
            return AgentStatusNoStable;
        }else{
            return AgentStatusStable;
        }
    }else{
        NSInteger stateAll = 0;
        for (int i = 0; i < _agentStatusArray.count; i++) {
            NSInteger stateIn = [_agentStatusArray[i] integerValue];
            if (stateIn == 0) {
                stateAll += 1;
            }
        }
        if (stateAll >0) {
            return AgentStatusNoStable;
        }else{
            return AgentStatusStable;
        }
    }
}

#pragma mark ------ 数据库 -----
-(void)createMenberInfo
{
    NSInteger applyer_id = [[BoxDataManager sharedManager].applyer_id integerValue];
    NSString *path = [DeviceManager documentPathAppendingPathComponent:[NSString stringWithFormat:@"authorizertt/%ld",(long)applyer_id]];
    NSString *dbPath = [path stringByAppendingPathComponent:@"message.db"];
    BOOL fileExist = [[NSFileManager defaultManager]fileExistsAtPath:path];
    if (!fileExist) {
        NSLog(@"没有发现数据库开始创建中。。。");
        NSError *error;
        [[NSFileManager defaultManager]createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        if (error) {
            //创建数据库失败
            NSLog(@"------创建数据库失败");
        }else{
            NSString *dbPath = [path stringByAppendingPathComponent:@"message.db"];
            [DBHelp openDataBase:dbPath];
            //创建表结构
            [[MenberInfoManager sharedManager] createMenberInfoTable];
            [[NewsInfoModel sharedManager] createNewsInfoTable];
        }
    }else{
        NSLog(@"数据库存在 直接Open %@",dbPath);
        [DBHelp openDataBase:dbPath];
    }
}

-(void)pushNextVCAction:(NSNotification *)notification
{
    UIViewController *vc = notification.object;
    vc.hidesBottomBarWhenPushed = YES;
    [self.sidePanelController.leftPanel.navigationController pushViewController:vc animated:NO];
    [self.sidePanelController setCenterPanelHidden:YES];
}

- (UIImage *)imageWithFrame:(CGRect)frame hexString:(NSString *)hexString {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIColor *redColor = [UIColor colorWithHexString:hexString];
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [redColor CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"homePageMenuImg"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(menuBtnAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
}

-(void)createView
{
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - kTopHeight)];
    _contentView.delegate = self;
    //滚动的时候消失键盘
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), [UIScreen mainScreen].bounds.size.height - kTopHeight);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    _contentView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headRefresh)];
    
    _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*(750/700) - 64)];
    _topView.image = [UIImage imageNamed:@"homePageTopImg"];
    //_topView.backgroundColor = kBlueColor;
    [_contentView addSubview:_topView];
 
    _middleView = [[UIView alloc] init];
    _middleView.backgroundColor = [UIColor colorWithHexString:@"#ededee"];
    _middleView.layer.cornerRadius = 3.f;
    _middleView.layer.masksToBounds = YES;
    [_contentView addSubview:_middleView];
    [_middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom).offset(-44);
        make.left.offset(12);
        make.width.offset(SCREEN_WIDTH - 24);
        make.height.offset(484/2);
    }];
    [self createMiddleDetail];
    
    _footView = [[UIView alloc] init];
    _footView.backgroundColor = kWhiteColor;
    [_contentView addSubview:_footView];
    [_footView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_middleView.mas_bottom).offset(10);
        make.left.offset(12);
        make.width.offset(SCREEN_WIDTH - 24);
        make.height.offset(200);
    }];
    [self createFootDetail];
}

#pragma mark  ----- 刷新数据-币种开户/待审批业务流/最新动态 -----
-(void)headRefresh
{
    [self approvallist];
    [self requestCoinlist];
    [self loadNews];
}

#pragma mark ----- 币种 -----
-(void)requestCoinlist
{
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/coinlist" params:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] integerValue] == 0) {
            [_sourceArray removeAllObjects];
            if([dict[@"CoinStatus"] isKindOfClass:[NSNull class]]){
                _middleTwoDetailLab.text = HomepageNoCurrency;
                return ;
            }
            NSString *text = @"";
            NSArray *listArray = dict[@"CoinStatus"];
            for (NSDictionary *listDic in listArray) {
                CoinlistModel *model = [[CoinlistModel alloc] initWithDict:listDic];
                text = [NSString stringWithFormat:@"%@ %@", text, model.Name];
            }
            _middleTwoDetailLab.text = text;
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
        [self reloadAction];
    }];
}

#pragma mark ----- 待审批业务流 -----
-(void)approvallist
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"captainid"];
    [paramsDic setObject: @(0) forKey:@"type"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/approvallist" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            if([dict[@"ApprovalInfos"] isKindOfClass:[NSNull class]]){
                _middleThreeDetailLab.text = HomepageNoApproval;
                return ;
            }
            NSArray *listArray = dict[@"ApprovalInfos"];
            _middleThreeDetailLab.text = [NSString stringWithFormat:@"您有%ld条待审批",listArray.count];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
        [self reloadAction];
    }];
}

-(void)reloadAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [_contentView.mj_header endRefreshing];
    });
}

#pragma mark ----- 关停启动服务 -----
-(void)touchMiddleOneAction:(UITapGestureRecognizer *)tap
{
    _seviceStateView = [[SeviceStateView alloc] initWithFrame:[UIScreen mainScreen].bounds state:[BoxDataManager sharedManager].agentOperate];
    _seviceStateView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_seviceStateView];
}

#pragma mark ----- 币种开户 -----
-(void)touchMiddleTwoAction:(UITapGestureRecognizer *)tap
{
    CurrencyAccountViewController *currencyAccountVC = [[CurrencyAccountViewController alloc] init];
    UINavigationController *currencyAccountNC = [[UINavigationController alloc] initWithRootViewController:currencyAccountVC];
    [self presentViewController:currencyAccountNC animated:YES completion:nil];
}

#pragma mark -----  审批业务流 -----
-(void)touchMiddleThreeAction:(UITapGestureRecognizer *)tap
{
    ApprovalBusinessViewController *approvalBusinessVC = [[ApprovalBusinessViewController alloc] init];
    UINavigationController *approvalBusinessNC = [[UINavigationController alloc] initWithRootViewController:approvalBusinessVC];
    [self presentViewController:approvalBusinessNC animated:YES completion:nil];
}

#pragma mark ----- 授权码 -----
-(void)touchMiddleFourAction:(UITapGestureRecognizer *)tap
{
    ScanAdressViewController *scanAdressVC = [[ScanAdressViewController alloc] init];
    BoxNavigationController *scanAdressNC = [[BoxNavigationController alloc] initWithRootViewController:scanAdressVC];
    [self presentViewController:scanAdressNC animated:YES completion:nil];
}

-(void)createMiddleDetail
{
    _middleOneView = [[UIView alloc] init];
    _middleOneView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_middleView addSubview:_middleOneView];
    [_middleOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.height.offset((484/2-1)/2);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2);
    }];
    
    UITapGestureRecognizer *middleTapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchMiddleOneAction:)];
    _middleOneView.userInteractionEnabled = YES;
    [_middleOneView addGestureRecognizer:middleTapOne];
    
    UIImageView *middleOneImg = [[UIImageView alloc] init];
    middleOneImg.image = [UIImage imageNamed:@"middleOneImg"];
    [_middleOneView addSubview:middleOneImg];
    [middleOneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(51/2);
        make.centerX.equalTo(_middleOneView).offset(0);
        make.height.offset(55/2);
        make.width.offset(58/2);
    }];
    
    _middleOneLab = [[UILabel alloc] init];
    _middleOneLab.text = HomepageMidOneLabStop;
    _middleOneLab.textAlignment = NSTextAlignmentCenter;
    _middleOneLab.font = Font(14);
    _middleOneLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _middleOneLab.numberOfLines = 1;
    [_middleOneView addSubview:_middleOneLab];
    [_middleOneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleOneImg.mas_bottom).offset(10);
        make.centerX.equalTo(_middleOneView);
        make.height.offset(20);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2 - 24);
    }];
    
    _middleOneDetailLab = [[UILabel alloc] init];
    _middleOneDetailLab.text = HomepageMidOneLabDetailStop;
    _middleOneDetailLab.textAlignment = NSTextAlignmentCenter;
    _middleOneDetailLab.font = Font(12);
    _middleOneDetailLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _middleOneDetailLab.numberOfLines = 1;
    [_middleOneView addSubview:_middleOneDetailLab];
    [_middleOneDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_middleOneLab.mas_bottom).offset(2);
        make.centerX.equalTo(_middleOneView);
        make.height.offset(15);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2 - 24);
    }];
    
    UIView *middleTwoView = [[UIView alloc] init];
    middleTwoView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_middleView addSubview:middleTwoView];
    [middleTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_middleOneView.mas_right).offset(1);
        make.top.offset(0);
        make.height.offset((484/2-1)/2);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2);
    }];
    
    UITapGestureRecognizer *middleTapTwo = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchMiddleTwoAction:)];
    middleTwoView.userInteractionEnabled = YES;
    [middleTwoView addGestureRecognizer:middleTapTwo];
    
    UIImageView *middleTwoImg = [[UIImageView alloc] init];
    middleTwoImg.image = [UIImage imageNamed:@"middleTwoImg"];
    [middleTwoView addSubview:middleTwoImg];
    [middleTwoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(51/2);
        make.centerX.equalTo(middleTwoView).offset(0);
        make.height.offset(55/2);
        make.width.offset(58/2);
    }];
    
    UILabel *middleTwoLab = [[UILabel alloc] init];
    middleTwoLab.text = HomepageMidTwoLab;
    middleTwoLab.textAlignment = NSTextAlignmentCenter;
    middleTwoLab.font = Font(14);
    middleTwoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    middleTwoLab.numberOfLines = 1;
    [middleTwoView addSubview:middleTwoLab];
    [middleTwoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleTwoImg.mas_bottom).offset(10);
        make.centerX.equalTo(middleTwoView);
        make.height.offset(20);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2 - 24);
    }];
    
    _middleTwoDetailLab = [[UILabel alloc] init];
    _middleTwoDetailLab.text = HomepageNoCurrency;
    _middleTwoDetailLab.textAlignment = NSTextAlignmentCenter;
    _middleTwoDetailLab.font = Font(12);
    _middleTwoDetailLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _middleTwoDetailLab.numberOfLines = 1;
    [middleTwoView addSubview:_middleTwoDetailLab];
    [_middleTwoDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleTwoLab.mas_bottom).offset(2);
        make.centerX.equalTo(middleTwoView);
        make.height.offset(15);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2 - 24);
    }];
    
    UIView *middleThreeView = [[UIView alloc] init];
    middleThreeView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_middleView addSubview:middleThreeView];
    [middleThreeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(_middleOneView.mas_bottom).offset(1);
        make.height.offset((484/2)/2);
        make.width.offset((SCREEN_WIDTH - 24)/2);
    }];
    
    UITapGestureRecognizer *middleTapThree = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchMiddleThreeAction:)];
    middleThreeView.userInteractionEnabled = YES;
    [middleThreeView addGestureRecognizer:middleTapThree];
    
    UIImageView *middleThreeImg = [[UIImageView alloc] init];
    middleThreeImg.image = [UIImage imageNamed:@"middleThreeImg"];
    [middleThreeView addSubview:middleThreeImg];
    [middleThreeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(51/2);
        make.centerX.equalTo(middleThreeView).offset(0);
        make.height.offset(55/2);
        make.width.offset(58/2);
    }];
    
    UILabel *middleThreeLab = [[UILabel alloc] init];
    middleThreeLab.text = HomepageMidThreeLab;
    middleThreeLab.textAlignment = NSTextAlignmentCenter;
    middleThreeLab.font = Font(14);
    middleThreeLab.textColor = [UIColor colorWithHexString:@"#333333"];
    middleThreeLab.numberOfLines = 1;
    [middleThreeView addSubview:middleThreeLab];
    [middleThreeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleThreeImg.mas_bottom).offset(10);
        make.centerX.equalTo(middleThreeView);
        make.height.offset(20);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2 - 24);
    }];
    
    _middleThreeDetailLab = [[UILabel alloc] init];
    _middleThreeDetailLab.text = HomepageNoApproval;
    _middleThreeDetailLab.textAlignment = NSTextAlignmentCenter;
    _middleThreeDetailLab.font = Font(12);
    _middleThreeDetailLab.textColor = [UIColor colorWithHexString:@"#e24846"];
    _middleThreeDetailLab.numberOfLines = 1;
    [middleThreeView addSubview:_middleThreeDetailLab];
    [_middleThreeDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleThreeLab.mas_bottom).offset(2);
        make.centerX.equalTo(middleThreeView);
        make.height.offset(15);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2 - 24);
    }];

    UIView *middleFourView = [[UIView alloc] init];
    middleFourView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_middleView addSubview:middleFourView];
    [middleFourView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleThreeView.mas_right).offset(1);
        make.top.equalTo(middleTwoView.mas_bottom).offset(1);
        make.height.offset((484/2)/2);
        make.width.offset((SCREEN_WIDTH - 24)/2);
    }];
    
    UITapGestureRecognizer *middleTapFour = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchMiddleFourAction:)];
    middleFourView.userInteractionEnabled = YES;
    [middleFourView addGestureRecognizer:middleTapFour];
    
    UIImageView *middleFourImg = [[UIImageView alloc] init];
    middleFourImg.image = [UIImage imageNamed:@"middleFourImg"];
    [middleFourView addSubview:middleFourImg];
    [middleFourImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(51/2);
        make.centerX.equalTo(middleFourView).offset(0);
        make.height.offset(55/2);
        make.width.offset(58/2);
    }];
    
    UILabel *middleFourLab = [[UILabel alloc] init];
    middleFourLab.text = HomepageMidFourLab;
    middleFourLab.textAlignment = NSTextAlignmentCenter;
    middleFourLab.font = Font(14);
    middleFourLab.textColor = [UIColor colorWithHexString:@"#333333"];
    middleFourLab.numberOfLines = 1;
    [middleFourView addSubview:middleFourLab];
    [middleFourLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleFourImg.mas_bottom).offset(10);
        make.centerX.equalTo(middleFourView);
        make.height.offset(20);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2 - 24);
    }];
    
    _middleFourDetailLab = [[UILabel alloc] init];
    _middleFourDetailLab.text = HomepageMidFourDetailLab;
    _middleFourDetailLab.textAlignment = NSTextAlignmentCenter;
    _middleFourDetailLab.font = Font(12);
    _middleFourDetailLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _middleFourDetailLab.numberOfLines = 1;
    [middleFourView addSubview:_middleFourDetailLab];
    [_middleFourDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleFourLab.mas_bottom).offset(2);
        make.centerX.equalTo(middleFourView);
        make.height.offset(15);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2 - 24);
    }];
}


-(void)createFootDetail
{
    UIView *lineH = [[UIView alloc] init];
    lineH.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    lineH.layer.cornerRadius = 1.5f;
    lineH.layer.masksToBounds = YES;
    [_footView addSubview:lineH];
    [lineH mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.top.offset(20);
        make.width.offset(3);
        make.height.offset(14);
    }];
    
    _footTitleLab = [[UILabel alloc] init];
    _footTitleLab.text = HomepageFootTitle;
    _footTitleLab.textAlignment = NSTextAlignmentLeft;
    _footTitleLab.font = Font(14);
    _footTitleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _footTitleLab.numberOfLines = 1;
    [_footView addSubview:_footTitleLab];
    [_footTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lineH.mas_right).offset(5);
        make.top.offset(33/2);
        make.right.offset(-16);
        make.height.offset(22);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.scrollEnabled  = NO;
    [_footView addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(_footTitleLab.mas_bottom).offset(5);
        make.right.offset(-0);
        make.bottom.offset(-5);
    }];
    [_tableView registerClass:[NewsTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _labelTip = [[UILabel alloc]initWithFrame:CGRectMake(30, 15, SCREEN_WIDTH - 60, 30)];
    _labelTip.text = @"暂无动态";
    _labelTip.textAlignment = NSTextAlignmentCenter;
    _labelTip.textColor = [UIColor colorWithHue:0.00 saturation:0.00 brightness:0.66 alpha:1.00];
    _labelTip.font = [UIFont systemFontOfSize:17];
    _labelTip.hidden = YES;
    [_tableView addSubview:_labelTip];
}

#pragma mark ----- load最新动态 -----
-(void)loadNews
{
    [_sourceArray removeAllObjects];
    NSMutableArray *dataArr = [[NewsInfoModel sharedManager] loadNewsInfo];
    _sourceArray = dataArr;
    [self.tableView reloadData];
    if (_sourceArray.count == 0) {
        _labelTip.hidden = NO;
    }else{
        _labelTip.hidden = YES;
    }
    if (dataArr.count <= 5) {
        [_footView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(33/2 + 22 + 5 + dataArr.count * 27 + 5);
        }];
        _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), [UIScreen mainScreen].bounds.size.width*(750/700) - 64 - 44 + 484/2 + 10 + 33/2 + 22 + 5 + dataArr.count * 27 + 5 + 15);
    }else{
        [_footView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.offset(33/2 + 22 + 5 + 5 * 27 + 5);
        }];
        _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), [UIScreen mainScreen].bounds.size.width*(750/700) - 64 - 44 + 484/2 + 10 + 33/2 + 22 + 5 + 5 * 27 + 5 + 15);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 27;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    NewsModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

#pragma mark ----- menuBtn -----
-(void)menuBtnAction:(UIBarButtonItem *)btn
{
    [self.sidePanelController showLeftPanelAnimated:YES];
}

#pragma mark ----- SeviceStateViewDelegate -----
- (void)SeviceState:(NSInteger)state
{
    switch (state) {
        case StopServiceOperate:
            [self agentOperate:state password:nil];
            [_seviceStateView removeFromSuperview];
            break;
        case StartServiceOperate:
            [_seviceStateView removeFromSuperview];
            [self showPrivatePasswordView];
            break;
        default:
            break;
    }
}

-(void)showPrivatePasswordView
{
    _privatePasswordView = [[PrivatePasswordView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    _privatePasswordView.delegate = self;
    [[UIApplication sharedApplication].keyWindow addSubview:_privatePasswordView];
}

#pragma ----- PrivatePasswordViewDelegate -----
- (void)PrivatePasswordViewDelegate:(NSString *)passwordStr
{
    [_privatePasswordView removeFromSuperview];
    [self agentOperate:StartServiceOperate password:passwordStr];
}

-(void)agentOperate:(NSInteger)state password:(NSString *)password
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    //0-添加公钥 1-创建 2-发布 3-启动 4-停止
    if (state == StartServiceOperate) {
        NSString *aesStr = [FSAES128 AES128EncryptStrig:password keyStr:[BoxDataManager sharedManager].randomValue];
        NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:aesStr privateStr:[BoxDataManager sharedManager].privateKeyBase64];
        //BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:aesStr signature:signSHA256 publicStr:[BoxDataManager sharedManager].publicKeyBase64];
        [paramsDic setObject:aesStr forKey:@"password"];
        [paramsDic setObject:signSHA256 forKey:@"sign"];
    }
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"applyerid"];
    [paramsDic setObject:@(state) forKey:@"type"];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/agent/operate" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        NSInteger RspNo = [dict[@"RspNo"] integerValue];
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            if (state == StartServiceOperate) {
                _middleOneView.userInteractionEnabled = NO;
                _middleOneLab.text = @"等待校验";
                
            }else{
                [self seviceType:StoppedServiceStatus];
            }
        }else{
            [ProgressHUD showStatus:RspNo];
        }
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)seviceType:(NSInteger)state
{
    if (state == StartedServiceStatus) {
         _middleOneView.userInteractionEnabled = YES;
        [[NewsInfoModel sharedManager] insertNewsInfoNews:@"已启动服务"];
        //可关停
        [BoxDataManager sharedManager].agentOperate = StopServiceOperate;
        _middleOneLab.text = HomepageMidOneLabStop;
        _middleOneDetailLab.text = HomepageMidOneLabDetailStop;
    }else if(state == StoppedServiceStatus){
         _middleOneView.userInteractionEnabled = YES;
        [[NewsInfoModel sharedManager] insertNewsInfoNews:@"已关停服务"];
        //可启动
        [BoxDataManager sharedManager].agentOperate = StartServiceOperate;
        _middleOneLab.text = HomepageMidOneLabStart;
        _middleOneDetailLab.text = HomepageMidOneLabDetailStart;
    }else if(state == NotConnectedStatus){
         _middleOneView.userInteractionEnabled = NO;
        [[NewsInfoModel sharedManager] insertNewsInfoNews:@"服务异常"];
        _middleOneLab.text = HomepageMidOneLabStart;
        _middleOneDetailLab.text = HomepageMidOneLabDetailError;
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
