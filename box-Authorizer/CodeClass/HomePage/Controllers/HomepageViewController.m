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

//text
#import "AccountAdressViewController.h"
#import "AboutBoxViewController.h"
#import "UIViewController+JASidePanel.h"



#define HomepageMidOneLabStop  @"关停"
#define HomepageMidOneLabStart  @"启动"
#define HomepageMidOneLabDetailStop  @"您的服务为启动状态"
#define HomepageMidOneLabDetailStart  @"您的服务为关停状态"
#define HomepageMidTwoLab  @"币种开户"
#define HomepageMidThreeLab  @"审批业务流"
#define HomepageMidFourLab  @"授权码"
#define HomepageMidFourDetailLab  @"授权员工最高权限"
#define HomepageFootTitle  @"最新动态"
#define HomepageTitle  @"首页"

@interface HomepageViewController ()<UIScrollViewDelegate, SeviceStateViewDelegate>

@property(nonatomic, strong)UIScrollView *contentView;
@property (nonatomic,strong)UIImageView *topView;
@property (nonatomic,strong)UIView *middleView;
@property (nonatomic,strong)UIView *footView;
@property (nonatomic,strong)UIButton *menuBtn;
@property (nonatomic,strong)UILabel *middleOneLab;
@property (nonatomic,strong)UILabel *middleOneDetailLab;
@property (nonatomic,strong)UILabel *middleTwoDetailLab;
@property (nonatomic,strong)UILabel *middleThreeDetailLab;
@property (nonatomic,strong)UILabel *middleFourDetailLab;
@property (nonatomic,strong)UILabel *footTitleLab;

@property (nonatomic,strong)SeviceStateView *seviceStateView;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ededee"];
    self.title = HomepageTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = RGBA(75, 97, 246, 1.0);
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self createView];
    [self createBarItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNextVCAction:) name:@"pushNextVC" object:nil];
}

-(void)pushNextVCAction:(NSNotification *)notification
{
    UIViewController *vc = notification.object;
    vc.hidesBottomBarWhenPushed = YES;
    [self.sidePanelController.leftPanel.navigationController pushViewController:vc animated:NO];
    [self.sidePanelController setCenterPanelHidden:YES];
}

- (UIImage *)imageWithFrame:(CGRect)frame alphe:(CGFloat)alphe {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIColor *redColor = RGBA(75, 97, 246, 1.0);
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
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), [UIScreen mainScreen].bounds.size.width*(750/700) - 64 + 484/2 - 44 + 10 + 200 + 30);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    _topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width*(750/700) - 64)];
    _topView.image = [UIImage imageNamed:@"homePageTopImg"];
    //_topView.backgroundColor = kBlueColor;
    [_contentView addSubview:_topView];
    
//    UIImageView *menuImg = [[UIImageView alloc] init];
//    menuImg.image = [UIImage imageNamed:@"homePageMenuImg"];
//    [self.view addSubview:menuImg];
//    [menuImg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(40);
//        make.left.offset(15);
//        make.width.offset(22);
//        make.height.offset(15);
//    }];
//
//    _menuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    [_menuBtn addTarget:self action:@selector(menuBtnAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_menuBtn];
//    [_menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.offset(38);
//        make.left.offset(12);
//        make.width.offset(45);
//        make.height.offset(30);
//    }];
//
    
    
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

#pragma mark ----- 关停启动服务 -----
-(void)touchMiddleOneAction:(UITapGestureRecognizer *)tap
{
    _seviceStateView = [[SeviceStateView alloc] initWithFrame:[UIScreen mainScreen].bounds state:seviceStateStop];
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
    UIView *middleOneView = [[UIView alloc] init];
    middleOneView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_middleView addSubview:middleOneView];
    [middleOneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.height.offset((484/2-1)/2);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2);
    }];
    
    UITapGestureRecognizer *middleTapOne = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(touchMiddleOneAction:)];
    middleOneView.userInteractionEnabled = YES;
    [middleOneView addGestureRecognizer:middleTapOne];
    
    UIImageView *middleOneImg = [[UIImageView alloc] init];
    middleOneImg.image = [UIImage imageNamed:@"middleOneImg"];
    [middleOneView addSubview:middleOneImg];
    [middleOneImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(51/2);
        make.centerX.equalTo(middleOneView).offset(0);
        make.height.offset(55/2);
        make.width.offset(58/2);
    }];
    
    _middleOneLab = [[UILabel alloc] init];
    _middleOneLab.text = HomepageMidOneLabStop;
    _middleOneLab.textAlignment = NSTextAlignmentCenter;
    _middleOneLab.font = Font(14);
    _middleOneLab.textColor = [UIColor colorWithHexString:@"#333333"];
    _middleOneLab.numberOfLines = 1;
    [middleOneView addSubview:_middleOneLab];
    [_middleOneLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(middleOneImg.mas_bottom).offset(10);
        make.centerX.equalTo(middleOneView);
        make.height.offset(20);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2 - 24);
    }];
    
    _middleOneDetailLab = [[UILabel alloc] init];
    _middleOneDetailLab.text = HomepageMidOneLabDetailStop;
    _middleOneDetailLab.textAlignment = NSTextAlignmentCenter;
    _middleOneDetailLab.font = Font(12);
    _middleOneDetailLab.textColor = [UIColor colorWithHexString:@"#999999"];
    _middleOneDetailLab.numberOfLines = 1;
    [middleOneView addSubview:_middleOneDetailLab];
    [_middleOneDetailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_middleOneLab.mas_bottom).offset(2);
        make.centerX.equalTo(middleOneView);
        make.height.offset(15);
        make.width.offset((SCREEN_WIDTH - 24 - 1)/2 - 24);
    }];
    
    
    
    
    UIView *middleTwoView = [[UIView alloc] init];
    middleTwoView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [_middleView addSubview:middleTwoView];
    [middleTwoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(middleOneView.mas_right).offset(1);
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
    _middleTwoDetailLab.text = @"BTC EOS BTS BOX";
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
        make.top.equalTo(middleOneView.mas_bottom).offset(1);
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
    _middleThreeDetailLab.text = @"您有两条待审批";
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
    
    
}

#pragma mark ----- menuBtn -----
-(void)menuBtnAction:(UIBarButtonItem *)btn
{
    [self.sidePanelController showLeftPanelAnimated:YES];
    
}

#pragma mark ----- SeviceStateViewDelegate -----
- (void)SeviceState:(NSInteger)state
{
    [_seviceStateView removeFromSuperview];
    _middleOneLab.text = HomepageMidOneLabStart;
    _middleOneDetailLab.text = HomepageMidOneLabDetailStart;
    
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
