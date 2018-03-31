//
//  ScanAdressViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ScanAdressViewController.h"

#define ScanAdressVCTitle  @"授权码"
#define ScanAdressVCScanLab  @"授权二维码"
#define ScanAdressVCDetailLab  @"用员工App扫描以上二维码，进行授权"
#define ScanAdressVCAuthorizeBtn  @"本机授权"
#define ScanAdressVCAleartLab  @"为避免资金风险，请勿分享授权码给他人，截屏自动失效"
#define ScanAdressVCIknown  @"我知道了"

@interface ScanAdressViewController ()<UIScrollViewDelegate, UITextFieldDelegate,MBProgressHUDDelegate>

@property(nonatomic, strong)UIScrollView *contentView;
/** 授权码 */
@property(nonatomic, strong)UIImageView *accountQRCodeImg;
@property(nonatomic, strong)UILabel *detailLab;
@property(nonatomic, strong)UIButton *authorizeBtn;
@property(nonatomic, strong)MBProgressHUD *progressHUD;
@property(nonatomic, strong)UIView *aleartView;
@property(nonatomic, strong)NSTimer *timer;
@property(nonatomic, strong)NSString *captain_id;
@property(nonatomic, strong)NSString *randomStr;

@end

@implementation ScanAdressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    self.title = ScanAdressVCTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#292e40"];
    
    [self createBarItem];
    [self createView];
    [self initProgressHUD];
    
    NSInteger currentTime = [[NSDate date]timeIntervalSince1970] * 1000;
    _captain_id = [NSString stringWithFormat:@"%ld", currentTime];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(registrationsPending:) userInfo:nil repeats:YES];
    
}

-(void)registrationsPending:(NSTimer *)timer
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:_captain_id forKey:@"captain_id"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/api/v1/registrations/pending" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"code"] integerValue] == 0 && ![dict[@"data"] isKindOfClass:[NSNull class]]) {
            for (NSDictionary *dic in dict[@"data"]) {
//                NSString *consent = dic[@"data"][@"consent"];//0暂无结果 1拒绝 2同意
//                NSString *message = dic[@"message"];
//                NSString *msg = dic[@"data"][@"msg"];
                [self handleRegistrationsPending:dic];
            }
            
            
        }
        
    } fail:^(NSError *error) {
        _timer = nil;
        [_timer invalidate];
        NSLog(@"%@", error.description);
    }];
}

-(void)handleRegistrationsPending:(NSDictionary *)dic
{
    NSString *consent = dic[@"consent"];//0暂无结果 1拒绝 2同意
    NSString *msg = dic[@"msg"];
    NSString *reg_id = dic[@"reg_id"];
    NSString *applyer_pub_key = [FSAES128 AES128DecryptString:msg keyStr:_randomStr];
    if (applyer_pub_key !=  nil) {
        
        NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
        [paramsDic setObject:@"2" forKey:@"consent"];
        [paramsDic setObject:applyer_pub_key forKey:@"applyer_pub_key"];
        [paramsDic setObject:reg_id forKey:@"reg_id"];
        
        [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/api/v1/registrations/approval" params:paramsDic success:^(id responseObject) {
            NSDictionary *dict = responseObject;
            if ([dict[@"code"] integerValue] == 0) {
 
                
            }
            
        } fail:^(NSError *error) {
            NSLog(@"%@", error.description);
        }];
        
    }
    
    
    
}





- (UIImage *) imageWithFrame:(CGRect)frame alphe:(CGFloat)alphe {
    frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
    UIColor *redColor = [UIColor colorWithHexString:@"#292e40"];;
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [redColor CGColor]);
    CGContextFillRect(context, frame);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

-(void)initProgressHUD
{
    self.progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    self.progressHUD.delegate = self;
    //添加ProgressHUD到界面中
    [self.view addSubview:self.progressHUD];
}

-(void)createView
{
    _contentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, kTopHeight - 64, SCREEN_WIDTH, SCREEN_HEIGHT - (kTopHeight - 64) )];
    _contentView.delegate = self;
    //滚动的时候消失键盘
    _contentView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _contentView.contentSize = CGSizeMake(CGRectGetWidth(self.view.frame), SCREEN_HEIGHT + 1);
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_contentView];
    
    UIView *oneView = [[UIView alloc] init];
    oneView.backgroundColor = kWhiteColor;
    oneView.layer.cornerRadius = 3.f;
    oneView.layer.masksToBounds = YES;
    [_contentView addSubview:oneView];
    [oneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.width.offset(SCREEN_WIDTH - 34);
        make.top.offset(35);
        make.height.offset(699/2);
    }];
    
    UIView *oneBackView = [[UIView alloc] init];
    oneBackView.backgroundColor = [UIColor colorWithHexString:@"#f5f7fa"];
    [oneView addSubview:oneBackView];
    [oneBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.right.offset(0);
        make.top.offset(0);
        make.height.offset(45);
    }];
    
    UIImageView *scanIconImg = [[UIImageView alloc] init];
    scanIconImg.image = [UIImage imageNamed:@"scanIconImg"];
    [oneBackView addSubview:scanIconImg];
    [scanIconImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.width.offset(14);
        make.centerY.equalTo(oneBackView);
        make.height.offset(14);
    }];
    
    UILabel *scanLab = [[UILabel alloc] init];
    scanLab.text = ScanAdressVCScanLab;
    scanLab.textAlignment = NSTextAlignmentLeft;
    scanLab.font = Font(13);
    scanLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [oneBackView addSubview:scanLab];
    [scanLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.equalTo(scanIconImg.mas_right).offset(8);
        make.height.offset(45);
        make.right.offset(0);
    }];
    
    _accountQRCodeImg = [[UIImageView alloc] init];
    _accountQRCodeImg.image = [CIQRCodeManager createImageWithString:@"hahahah"];
    [oneView addSubview:_accountQRCodeImg];
    [_accountQRCodeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(oneBackView.mas_bottom).offset(79/2);
        make.centerX.equalTo(oneView);
        make.height.offset(370/2);
        make.width.offset(370/2);
    }];
    
    
    _detailLab = [[UILabel alloc] init];
    _detailLab.text = ScanAdressVCDetailLab;
    _detailLab.textAlignment = NSTextAlignmentCenter;
    _detailLab.font = Font(11);
    _detailLab.textColor = [UIColor colorWithHexString:@"#8e9299"];
    [oneView addSubview:_detailLab];
    [_detailLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(12);
        make.right.offset(-12);
        make.top.equalTo(_accountQRCodeImg.mas_bottom).offset(41.0/2.0);
        make.height.offset(31.0/2.0);
    }];
    
    _authorizeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_authorizeBtn setTitle:ScanAdressVCAuthorizeBtn forState:UIControlStateNormal];
    [_authorizeBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _authorizeBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _authorizeBtn.titleLabel.font = Font(16);
    _authorizeBtn.layer.masksToBounds = YES;
    _authorizeBtn.layer.cornerRadius = 2.0f;
    [_authorizeBtn addTarget:self action:@selector(authorizeAction:) forControlEvents:UIControlEventTouchUpInside];
    [_contentView addSubview:_authorizeBtn];
    [_authorizeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(16);
        make.width.offset(SCREEN_WIDTH - 32);
        make.top.equalTo(oneView.mas_bottom).offset(78.0/2.0);
        make.height.offset(46);
    }];
    
    [self createAleartView];
    
}


-(void)createAleartView
{
    _aleartView = [[UIView alloc] init];
    _aleartView.backgroundColor = kWhiteColor;
    _aleartView.layer.cornerRadius = 3.f;
    _aleartView.layer.masksToBounds = YES;
    [_contentView addSubview:_aleartView];
    [_aleartView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(17);
        make.width.offset(SCREEN_WIDTH - 34);
        make.top.offset(35);
        make.height.offset(699/2);
    }];
    
    UIImageView *thiefImg = [[UIImageView alloc] init];
    thiefImg.image = [UIImage imageNamed:@"icon_thief"];
    [_aleartView addSubview:thiefImg];
    [thiefImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(60);
        make.centerX.equalTo(_aleartView);
        make.width.offset(120);
        make.height.offset(187.0/2.0);
    }];
    
    UILabel *aleartLab = [[UILabel alloc] init];
    aleartLab.text = ScanAdressVCAleartLab;
    aleartLab.textAlignment = NSTextAlignmentCenter;
    aleartLab.font = Font(15);
    aleartLab.numberOfLines = 0;
    aleartLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [_aleartView addSubview:aleartLab];
    [aleartLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(40);
        make.right.offset(-40);
        make.top.equalTo(thiefImg.mas_bottom).offset(30);
        make.height.offset(42);
    }];
    
    UIButton *achieveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [achieveBtn setTitle:ScanAdressVCIknown forState:UIControlStateNormal];
    achieveBtn.titleLabel.font = Font(14);
    achieveBtn.layer.cornerRadius = 38.0/2.0;
    achieveBtn.layer.masksToBounds = YES;
    achieveBtn.layer.borderWidth = 1.0f;
    achieveBtn.layer.borderColor = [UIColor colorWithHexString:@"#4c7afd"].CGColor;
    [achieveBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    [achieveBtn addTarget:self action:@selector(achieveBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_aleartView addSubview:achieveBtn];
    [achieveBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(aleartLab.mas_bottom).offset(45);
        make.centerX.equalTo(_aleartView);
        make.height.offset(38);
        make.width.offset(130);
    }];
    
    
    
    
}

-(void)achieveBtnAction:(UIButton *)btn
{
    _aleartView.hidden = YES;
    _accountQRCodeImg.image = [CIQRCodeManager createImageWithString:[self generateAuthorizationCode]];
}


#pragma mark -----  本机授权 -----
-(void)authorizeAction:(UIButton *)btn
{
    
}

#pragma mark ----- createBarItem -----
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
    
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


-(NSString *)generateAuthorizationCode
{
    NSString *box_IP = BOX_IP;
    _randomStr = [JsonObject getRandomStringWithNum:8];
    NSArray *codeArray = [NSArray arrayWithObjects:box_IP, _randomStr, _captain_id, nil];
    NSString *codeSting = [JsonObject dictionaryToarrJson:codeArray];
    return codeSting;
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
