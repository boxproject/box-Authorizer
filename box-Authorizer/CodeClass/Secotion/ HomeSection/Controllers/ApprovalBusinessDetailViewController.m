//
//  ApprovalBusinessDetailViewController.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessDetailViewController.h"
#import "ApprovalBusinessCollectionReusableView.h"
#import "ApprovalBusinessCollectionViewCell.h"
#import "ApprovalBusinessDetailModel.h"
#import "ApprovalBusApproversModel.h"
#import "ApprovalBusinessTopView.h"
#import "PrivatePasswordView.h"

#define CellReuseIdentifier  @"ApprovalBusinessDetail"
#define headerReusableViewIdentifier  @"ApprovalBusinessDetail"
#define ApprovalBusinessDetailVCAgreeApprovalBtn  @"同意审批"
#define ApprovalBusinessDetailVCRefuseApprovalBtn  @"拒绝审批"
#define ApprovalBusinessDetailApprovaling  @"审批中"
#define ApprovalBusinessDetailSucceed  @"审批通过"
#define ApprovalBusinessDetailFail  @"已拒绝审批"
#define ApprovalBusinessDetailAwait  @"待审批"
#define ApprovalBusinessDetailAgreen  @"已同意审批"

@interface ApprovalBusinessDetailViewController ()<UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PrivatePasswordViewDelegate>

@property(nonatomic, strong)ApprovalBusinessTopView *approvalBusinessTopView;
//布局对象
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionFlowlayout;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *approvaledInfoArray;
@property(nonatomic, strong)UIButton *approvalStateBtn;
@property(nonatomic, strong)UIButton *agreeApprovalBtn;
@property(nonatomic, strong)UIButton *refuseApprovalBtn;
@property(nonatomic, strong)PrivatePasswordView *privatePasswordView;
@property(nonatomic, strong)DDRSAWrapper *aWrapper;
@property(nonatomic, assign)NSInteger buttonTag;
@property(nonatomic, strong)NSDictionary *responseDic;
@end

@implementation ApprovalBusinessDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.view.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    self.title = _model.Name;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:kWhiteColor}];
    UINavigationBar * bar = self.navigationController.navigationBar;
    UIImage *bgImage = [self imageWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, kTopHeight) alphe:1.0];
    [bar setBackgroundImage:bgImage forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithHexString:@"#292e40"];
    [self createBarItem];
    _approvaledInfoArray = [[NSMutableArray alloc] init];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self layoutCollectionView];
    [self createCollectionView];
    [self requestData];
}

#pragma mark ----- 布局 -----
-(void)layoutCollectionView
{
    _collectionFlowlayout = [[UICollectionViewFlowLayout alloc] init];
    //item大小
    _collectionFlowlayout.itemSize = CGSizeMake(([UIScreen mainScreen].bounds.size.width - 22 - 37 - 13 - 6*3)/4, 35);
    // 最小列间距
    _collectionFlowlayout.minimumInteritemSpacing = 6;
    // 最小行间距
    _collectionFlowlayout.minimumLineSpacing = 10;
    // 分区内容边间距（上，左， 下， 右）；
    _collectionFlowlayout.sectionInset = UIEdgeInsetsMake(8, 37, 8, 13);
    // 滑动方向
    //_flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    //_assoFlowlayout.scrollDirection = NO;
}

#pragma mark - 添加群列表
-(void)createCollectionView
{
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(11, 8,  SCREEN_WIDTH - 22, SCREEN_HEIGHT - 8 - kTopHeight - 45) collectionViewLayout:_collectionFlowlayout];
    [_collectionView registerClass:[ApprovalBusinessCollectionViewCell class] forCellWithReuseIdentifier:CellReuseIdentifier];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator =NO;
    _collectionView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    _collectionView.contentInset = UIEdgeInsetsMake(72, 0, 0, 0);
    _approvalBusinessTopView = [[ApprovalBusinessTopView alloc] initWithFrame: CGRectMake(0, -72, SCREEN_WIDTH - 22, 72) dic:nil];
    [_collectionView addSubview: _approvalBusinessTopView];
    [_collectionView registerClass:[ApprovalBusinessCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusableViewIdentifier];
    [self.view addSubview:_collectionView];
    
    _agreeApprovalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_agreeApprovalBtn setTitle:ApprovalBusinessDetailVCAgreeApprovalBtn forState:UIControlStateNormal];
    _agreeApprovalBtn.tag = 1;
    [_agreeApprovalBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _agreeApprovalBtn.backgroundColor = [UIColor colorWithHexString:@"#4c7afd"];
    _agreeApprovalBtn.titleLabel.font = Font(15);
    [_agreeApprovalBtn addTarget:self action:@selector(approvalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_agreeApprovalBtn];
    [_agreeApprovalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH/2);
        make.bottom.offset(-kTabBarHeight + 49);
        make.height.offset(45);
    }];
    
    _refuseApprovalBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_refuseApprovalBtn setTitle:ApprovalBusinessDetailVCRefuseApprovalBtn forState:UIControlStateNormal];
    [_refuseApprovalBtn setTitleColor:[UIColor colorWithHexString:@"#4c7afd"] forState:UIControlStateNormal];
    _refuseApprovalBtn.tag = 0;
    _refuseApprovalBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    _refuseApprovalBtn.titleLabel.font = Font(15);
    [_refuseApprovalBtn addTarget:self action:@selector(approvalAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_refuseApprovalBtn];
    [_refuseApprovalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_agreeApprovalBtn.mas_right).offset(0);
        make.width.offset(SCREEN_WIDTH/2);
        make.bottom.offset(-kTabBarHeight + 49);
        make.height.offset(45);
    }];
    
    _approvalStateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_approvalStateBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"] forState:UIControlStateNormal];
    _approvalStateBtn.backgroundColor = [UIColor colorWithHexString:@"#c9c9c9"];
    _approvalStateBtn.titleLabel.font = Font(15);
    [self.view addSubview:_approvalStateBtn];
    [_approvalStateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.width.offset(SCREEN_WIDTH);
        make.bottom.offset(-kTabBarHeight + 49);
        make.height.offset(45);
    }];
    _approvalStateBtn.hidden = YES;
}

#pragma mark -----  同意审批/拒绝审批 -----
-(void)approvalAction:(UIButton *)btn
{
    NSString *Status = _responseDic[@"ApprovalInfo"][@"Status"];
    NSString *AppId = _responseDic[@"ApprovalInfo"][@"AppId"];
    NSString *Flow = _responseDic[@"ApprovalInfo"][@"Flow"];
    NSString *Sign = _responseDic[@"ApprovalInfo"][@"Sign"];
    if ([Status isEqualToString:@"0"]) {
        NSArray *menberArr = [[MemberInfoManager sharedManager] loadMenberInfo:AppId];
        MemberInfoModel *menberInfoModel = menberArr[0];
        BOOL veryOK = [_aWrapper PKCSVerifyBytesSHA256withRSA:Flow signature:Sign publicStr:menberInfoModel.publicKey];
        if (!veryOK) {
            [WSProgressHUD showErrorWithStatus:@"非法审批流"];
            return;
        }
    }
     NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:Flow privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:_model.Hash forKey:@"hash"];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"captainid"];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [paramsDic setObject:@(btn.tag) forKey:@"opinion"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/allow" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            _agreeApprovalBtn.hidden = YES;
            _refuseApprovalBtn.hidden = YES;
            _approvalStateBtn.hidden = NO;
            if (btn.tag == 0) {
                [_approvalStateBtn setTitle:ApprovalBusinessDetailFail forState:UIControlStateNormal];
                [[NewsInfoModel sharedManager] insertNewsInfoNews:[NSString stringWithFormat:@"%@%@", @"拒绝审批",_model.Name]];
            }else if(btn.tag == 1){
                [_approvalStateBtn setTitle:ApprovalBusinessDetailAgreen forState:UIControlStateNormal];
                [[NewsInfoModel sharedManager] insertNewsInfoNews:[NSString stringWithFormat:@"%@%@", @"同意审批",_model.Name]];
            }
        }else{
            [ProgressHUD showStatus:[responseObject[@"code"] integerValue]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

#pragma mark  ----- UICollectionViewDataSource -----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ApprovalBusinessDetailModel *model = _approvaledInfoArray[section];
    return model.approvers.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return _approvaledInfoArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ApprovalBusinessCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    ApprovalBusinessDetailModel *approvalBusinessDetailModel = _approvaledInfoArray[indexPath.section];
    ApprovalBusApproversModel *model = approvalBusinessDetailModel.approvers[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width - 22, 30);
}

//创建头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    ApprovalBusinessCollectionReusableView* reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerReusableViewIdentifier forIndexPath:indexPath];
    ApprovalBusinessDetailModel *approvalBusinessDetailModel = _approvaledInfoArray[indexPath.section];
    reusableView.model = approvalBusinessDetailModel;
    [reusableView setDataWithModel:approvalBusinessDetailModel index:indexPath.section];
    return reusableView;
}

#pragma mark ----- 数据请求 -----
-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:_model.Hash forKey:@"hash"];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"captainid"];
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/approvaldetail" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            _responseDic = dict;
            NSString *Status = dict[@"ApprovalInfo"][@"Status"];
            [self showBtnApprovalState:Status];
            NSString *Flow = dict[@"ApprovalInfo"][@"Flow"];
            NSDictionary *flowDic = [JsonObject dictionaryWithJsonString:Flow];
            NSString *flow_name = flowDic[@"flow_name"];
            NSString *single_limit = flowDic[@"single_limit"];
            NSMutableDictionary *mutableDic = [NSMutableDictionary dictionary];
            [mutableDic  setObject:single_limit forKey:@"single_limit"];
            [mutableDic  setObject:flow_name forKey:@"flow_name"];
            [_approvalBusinessTopView setValueWithData:mutableDic ];
            NSArray *approvaled_infoArr = flowDic[@"approval_info"];
            for (NSDictionary *dic in approvaled_infoArr) {
                ApprovalBusinessDetailModel *model = [[ApprovalBusinessDetailModel alloc] initWithDict:dic];
                [_approvaledInfoArray addObject:model];
            }
            if (![dict[@"HashOperates"] isKindOfClass:[NSNull class]]) {
                NSArray *HashOperatesArr = dict[@"HashOperates"];
                if ([Status isEqualToString:@"0"] || [Status isEqualToString:@"3"]) {
                    for (NSDictionary *dic in HashOperatesArr) {
                        if ([[BoxDataManager sharedManager].app_account_id isEqualToString:dic[@"CaptainId"]]) {
                            [self showBtnApprovalOption:dic[@"Option"]];
                        }
                    }
                }
            }
        }else{
            [ProgressHUD showStatus:[responseObject[@"code"] integerValue]];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
    }];
}

-(void)showBtnApprovalState:(NSString *)state
{
    /*
     HASH_STATUS_0 = "0" //待申请
     HASH_STATUS_1 = "1" //私钥已申请提交
     HASH_STATUS_2 = "2" //私钥已拒绝提交 私钥A拒绝
     HASH_STATUS_3 = "3" //私链已申请确认(日志)
     HASH_STATUS_4 = "4" //私链已同意确认 私钥B、私钥C均同意
     HASH_STATUS_5 = "5" //私链已拒绝确认 私钥B、私钥C有不同意
     HASH_STATUS_6 = "6" //私链已同意(日志)
     HASH_STATUS_7 = "7" //公链已同意
     HASH_STATUS_8 = "8" //公链已拒绝
     */
    if ([state isEqualToString:@"0"] || [state isEqualToString:@"3"]) {
        _agreeApprovalBtn.hidden = NO;
        _refuseApprovalBtn.hidden = NO;
        _approvalStateBtn.hidden = YES;
    }else if([state isEqualToString:@"7"]){
        _agreeApprovalBtn.hidden = YES;
        _refuseApprovalBtn.hidden = YES;
        _approvalStateBtn.hidden = NO;
        [_approvalStateBtn setTitle:ApprovalBusinessDetailSucceed forState:UIControlStateNormal];
    }else if([state isEqualToString:@"5"] || [state isEqualToString:@"2"]){
        _agreeApprovalBtn.hidden = YES;
        _refuseApprovalBtn.hidden = YES;
        _approvalStateBtn.hidden = NO;
        [_approvalStateBtn setTitle:ApprovalBusinessDetailFail forState:UIControlStateNormal];
    }else{
        _agreeApprovalBtn.hidden = YES;
        _refuseApprovalBtn.hidden = YES;
        _approvalStateBtn.hidden = NO;
        [_approvalStateBtn setTitle:ApprovalBusinessDetailApprovaling forState:UIControlStateNormal];
    }
}

-(void)showBtnApprovalOption:(NSString *)option
{
    /*
     Option = "0" //拒绝
     Option = "1" //同意
 
     */
    if ([option isEqualToString:@"0"]) {
        _agreeApprovalBtn.hidden = YES;
        _refuseApprovalBtn.hidden = YES;
        _approvalStateBtn.hidden = NO;
        [_approvalStateBtn setTitle:ApprovalBusinessDetailFail forState:UIControlStateNormal];
    }else if([option isEqualToString:@"1"]){
        _agreeApprovalBtn.hidden = YES;
        _refuseApprovalBtn.hidden = YES;
        _approvalStateBtn.hidden = NO;
        [_approvalStateBtn setTitle:ApprovalBusinessDetailAgreen forState:UIControlStateNormal];
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

#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back_white"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
    
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    //[self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
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
