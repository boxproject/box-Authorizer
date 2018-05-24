//
//  ApprovalBusinessViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessViewController.h"
#import "ApprovalBusinessModel.h"
#import "ApprovalBusinessTableViewCell.h"
#import "ApprovalBusinessDetailViewController.h"

#define PageSize  12
#define CellReuseIdentifier  @"ApprovalBusiness"
#define ApprovalBusinessVCTitle  @"审批流"

@interface ApprovalBusinessViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic,strong) UISegmentedControl *segmentedView;
@property (nonatomic,strong) UIView *viewLayer;

@end

@implementation ApprovalBusinessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    _sourceArray = [[NSMutableArray alloc] init];
    _page = 1;
    [self createSegmentedView];
    [self createView];
    [self requestData];
}

-(void)createSegmentedView
{
    self.navigationItem.titleView = self.viewLayer;
}

- (UIView *)viewLayer{
    if(_viewLayer) return _viewLayer;
    _viewLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _viewLayer.backgroundColor = [UIColor clearColor];
    _segmentedView = [[UISegmentedControl alloc]initWithItems:@[@"待审批",@"已审批"]];
    [_segmentedView addTarget:self action:@selector(segmentedChangle) forControlEvents:UIControlEventValueChanged];
    [_viewLayer addSubview:self.segmentedView];
    self.segmentedView.frame = CGRectMake(30, 0, 200 - 60, 30);
    _segmentedView.selectedSegmentIndex = 0;
    return _viewLayer;
}

-(void)segmentedChangle
{
    [self requestData];
}


#pragma mark ----- 数据请求 -----
-(void)requestData
{
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"captainid"];
    if (_segmentedView.selectedSegmentIndex == 0) {
        [paramsDic setObject: @(0) forKey:@"type"];
    }else{
        [paramsDic setObject: @(1) forKey:@"type"];
    }
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/approvallist" params:paramsDic success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] isEqualToString:@"0"]) {
            if (_page == 1) {
                [_sourceArray removeAllObjects];
            }
            if([dict[@"ApprovalInfos"] isKindOfClass:[NSNull class]]){
                [self reloadAction];
                return ;
            }
            NSArray *listArray = dict[@"ApprovalInfos"];
            for (NSDictionary *listDic in listArray) {
                ApprovalBusinessModel *model = [[ApprovalBusinessModel alloc] initWithDict:listDic];
                [_sourceArray addObject:model];
            }
        }else{
            [ProgressHUD showStatus:[dict[@"RspNo"] integerValue]];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        NSLog(@"%@", error.description);
        [self reloadAction];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

-(void)reloadAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    });
}

-(void)createView
{
    [self createBarItem];
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.offset(0);
        make.right.offset(-0);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
    }];
    [_tableView registerClass:[ApprovalBusinessTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self headerReflesh];
}

#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

-(void)headerReflesh
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
        [self requestData];
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ApprovalBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    ApprovalBusinessModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    dispatch_async(dispatch_get_main_queue(), ^{
        ApprovalBusinessModel *model = self.sourceArray[indexPath.row];
        ApprovalBusinessDetailViewController *approvalBusinessDetailVc = [[ApprovalBusinessDetailViewController alloc] init];
        approvalBusinessDetailVc.model = model;
        UINavigationController *approvalBusinessDetailNc = [[UINavigationController alloc] initWithRootViewController:approvalBusinessDetailVc];
        [self presentViewController:approvalBusinessDetailNc animated:NO completion:nil];
    });
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
