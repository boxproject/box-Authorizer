//
//  CurrencyAccountViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "CurrencyAccountViewController.h"
#import "CurrencyAccountModel.h"
#import "CurrencyAccountTableViewCell.h"
#import "AddCurrencyViewController.h"
#import "EditCurrencyViewController.h"
#import "CoinlistModel.h"

#define PageSize  12
#define CellReuseIdentifier  @"currencyAccount"

@interface CurrencyAccountViewController ()<UITableViewDelegate, UITableViewDataSource,AddCurrencyDelegate,EditCurrencyDelegate>
/**< 币种／代币 */
@property (nonatomic,strong) UISegmentedControl *segmentedView;
@property (nonatomic,strong) UIView *viewLayer;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic, strong)NSMutableArray *sourceTwoArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *selectArray;
@property (nonatomic, strong) DDRSAWrapper *aWrapper;

@end

@implementation CurrencyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    _sourceArray = [[NSMutableArray alloc] init];
    _sourceTwoArray = [[NSMutableArray alloc] init];
    _selectArray = [[NSMutableArray alloc] init];
    _aWrapper = [[DDRSAWrapper alloc] init];
    [self createView];
    _page = 1;
    _segmentedView.selectedSegmentIndex = 0;
    [self requestData];
}

-(void)createView
{
    [self createSegmentedView];
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
    [_tableView registerClass:[CurrencyAccountTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self headerReflesh];
}

-(void)headerReflesh
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self requestData];
    }];
}

#pragma mark ----- AddCurrencyDelegate -----
- (void)addCurrencyDelegateReflesh
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ----- EditCurrencyDelegate -----
- (void)editCurrencyDelegateReflesh
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ----- 数据请求 -----
-(void)requestData
{
    if (_segmentedView.selectedSegmentIndex == 0) {
        //币种
        [self requestCoinlist];
    }else{
        //代币
        [self requestTokenlist];
    }
}

-(void)requestCoinlist
{
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/coinlist" params:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] integerValue] == 0) {
            [_sourceArray removeAllObjects];
            if([dict[@"CoinStatus"] isKindOfClass:[NSNull class]]){
                return ;
            }
            NSArray *listArray = dict[@"CoinStatus"];
            for (NSDictionary *listDic in listArray) {
                CoinlistModel *model = [[CoinlistModel alloc] initWithDict:listDic];
                [_sourceArray addObject:model];
            }
            
        }else{
            [ProgressHUD showStatus:[dict[@"RspNo"] integerValue]];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        //[WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
        [self handleRequestFailed];
    }];
}

-(void)requestTokenlist
{
    [[NetworkManager shareInstance] requestWithMethod:GET withUrl:@"/agent/tokenlist" params:nil success:^(id responseObject) {
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] integerValue] == 0) {
            [_sourceTwoArray removeAllObjects];
            if([dict[@"TokenInfos"] isKindOfClass:[NSNull class]]){
                CurrencyAccountModel *model = [[CurrencyAccountModel alloc] init];
                model.isType = 1;
                [_sourceTwoArray addObject:model];
                [self reloadAction];
                return ;
            }
            NSArray *listArray = dict[@"TokenInfos"];
            for (NSDictionary *listDic in listArray) {
                CurrencyAccountModel *model = [[CurrencyAccountModel alloc] initWithDict:listDic];
                [_sourceTwoArray addObject:model];
            }
            CurrencyAccountModel *model = [[CurrencyAccountModel alloc] init];
            model.isType = 1;
            [_sourceTwoArray addObject:model];
            
        }else{
            [ProgressHUD showStatus:[dict[@"RspNo"] integerValue]];
        }
        [self reloadAction];
    } fail:^(NSError *error) {
        //[WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
        [self handleRequestFailed];
    }];
}

-(void)handleRequestFailed
{
    //[_sourceArray removeAllObjects];
    [self reloadAction];
}

-(void)reloadAction
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
        [self.tableView.mj_header endRefreshing];
    });
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
}

-(void)createSegmentedView
{
    self.navigationItem.titleView = self.viewLayer;
}

- (UIView *)viewLayer{
    if(_viewLayer) return _viewLayer;
    _viewLayer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    _viewLayer.backgroundColor = [UIColor clearColor];
    _segmentedView = [[UISegmentedControl alloc]initWithItems:@[@"币种",@"代币"]];
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

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *action1 = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:delete handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:SureToDelete preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:Affirm style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
            [self deleteCurrentcy:indexPath];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:Cancel style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }];
    if (_segmentedView.selectedSegmentIndex == 0) {
        return @[];
    }else{
        CurrencyAccountModel *model = _sourceTwoArray[indexPath.row];
        if (model.isType == AddCurrency) {
            return @[];
        }else{
            return @[action1];
        }
    }
}

#pragma mark ----- 删除代币 -----
-(void)deleteCurrentcy:(NSIndexPath *)indexPath
{
    CurrencyAccountModel *model = self.sourceTwoArray[indexPath.row];
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:model.ContractAddr forKey:@"contractaddr"];
    [paramsDic setObject:[BoxDataManager sharedManager].app_account_id forKey:@"applyerid"];
    NSString *signSHA256 = [_aWrapper PKCSSignBytesSHA256withRSA:model.ContractAddr privateStr:[BoxDataManager sharedManager].privateKeyBase64];
    [paramsDic setObject:signSHA256 forKey:@"sign"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/agent/tokendel" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] integerValue] == 0) {
            [self.sourceTwoArray removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }else{
            [ProgressHUD showStatus:[dict[@"RspNo"] integerValue]];
        }
    } fail:^(NSError *error) {
        [WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
    }];
}

#pragma mark ----- 是否使用，0-禁用 1-使用 -----
-(void)coinUsed:(NSIndexPath *)indexPath
{
    CoinlistModel *model = self.sourceArray[indexPath.row];
    NSString *usedString;
    if (model.used) {
        usedString = @"0";
    }else{
        usedString = @"1";
    }
    NSMutableDictionary *paramsDic = [[NSMutableDictionary alloc]init];
    [paramsDic setObject:@(model.category) forKey:@"category"];
    [paramsDic setObject:usedString forKey:@"used"];
    [ProgressHUD showProgressHUD];
    [[NetworkManager shareInstance] requestWithMethod:POST withUrl:@"/agent/coin" params:paramsDic success:^(id responseObject) {
        [WSProgressHUD dismiss];
        NSDictionary *dict = responseObject;
        if ([dict[@"RspNo"] integerValue] == 0) {
            if (!model.used) {
                [_selectArray removeAllObjects];
                for (int i = 0; i < _sourceArray.count; i++) {
                    CoinlistModel *model = _sourceArray[i];
                    if (model.used) {
                        [_selectArray addObject:model];
                    }
                }
            }
            model.used = !model.used;
            [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            
        }else{
            [ProgressHUD showStatus:[dict[@"RspNo"] integerValue]];
        }
    } fail:^(NSError *error) {
        [WSProgressHUD dismiss];
        NSLog(@"%@", error.description);
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_segmentedView.selectedSegmentIndex == 0) {
        return self.sourceArray.count;
    }else{
        return self.sourceTwoArray.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CurrencyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    if (_segmentedView.selectedSegmentIndex == 0) {
        CoinlistModel *model = self.sourceArray[indexPath.row];
        cell.coinlistModel = model;
        [cell setDataWithCoinlistModel:model];
    }else{
       CurrencyAccountModel *model = self.sourceTwoArray[indexPath.row];
        cell.model = model;
       [cell setDataWithModel:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_segmentedView.selectedSegmentIndex == 0) {
        [self coinUsed:indexPath];
    }else{
        CurrencyAccountModel *model = _sourceTwoArray[indexPath.row];
        if (model.isType == AddCurrency) {
            AddCurrencyViewController *addCurrencyVC = [[AddCurrencyViewController alloc] init];
            addCurrencyVC.delegate = self;
            [self.navigationController pushViewController:addCurrencyVC animated:YES];
            
        }else{
            EditCurrencyViewController *editCurrencyVC = [[EditCurrencyViewController alloc] init];
            editCurrencyVC.delegate = self;
            editCurrencyVC.model = model;
            [self.navigationController pushViewController:editCurrencyVC animated:YES];
        }
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
