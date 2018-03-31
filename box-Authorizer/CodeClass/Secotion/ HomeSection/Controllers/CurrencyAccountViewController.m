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

#define PageSize  12
#define CellReuseIdentifier  @"currencyAccount"

@interface CurrencyAccountViewController ()<UITableViewDelegate, UITableViewDataSource>
/**< 币种／代币 */
@property (nonatomic,strong) UISegmentedControl *segmentedView;
@property (nonatomic,strong) UIView *viewLayer;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;
@property (nonatomic, strong) NSMutableArray *selectArray;

@end

@implementation CurrencyAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
     _sourceArray = [[NSMutableArray alloc] init];
    _selectArray = [[NSMutableArray alloc] init];
    [self createView];
    NSDictionary *dict = @{
                           @"data":@[
                                   @{@"currency":@"EOS", @"isType":@(0)},
                                   @{@"currency":@"BTS", @"isType":@(0)},
                                   @{@"currency":@"ETH", @"isType":@(0)},
                                   @{@"currency":@"ZB", @"isType":@(0)},
                                   @{@"currency":@"HT", @"isType":@(0)},
                                   @{@"currency":@"APPC", @"isType":@(0)},
                                   @{@"currency":@"OKB", @"isType":@(0)}
                                   ]
                           
                           };
    
    
    for (NSDictionary *dataDic in dict[@"data"]) {
        CurrencyAccountModel *model = [[CurrencyAccountModel alloc] initWithDict:dataDic];
        [_sourceArray addObject:model];
    }
    [self.tableView reloadData];
    
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
    [self footerReflesh];
    [self headerReflesh];
}

-(void)footerReflesh
{
    _tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self.page += 1;
        [self requestData];
    }];
    
    
}

-(void)headerReflesh
{
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.page = 1;
    }];
}

#pragma mark ----- requestData -----
-(void)requestData
{
    
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
    if (_segmentedView.selectedSegmentIndex == 1) {
        [_sourceArray removeAllObjects];
        NSDictionary *dict = @{
                               @"data":@[
                                       @{@"currency":@"EOS", @"isType":@(0)},
                                       @{@"currency":@"BTS", @"isType":@(0)},
                                       @{@"currency":@"ETH", @"isType":@(0)},
                                       @{@"currency":@"ZB", @"isType":@(0)},
                                       @{@"currency":@"HT", @"isType":@(0)},
                                       @{@"currency":@"APPC", @"isType":@(0)},
                                       @{@"currency":@"OKB", @"isType":@(0)},
                                       @{@"currency":@"", @"isType":@(1)}
                                       ]
                               
                               };
        
        
        for (NSDictionary *dataDic in dict[@"data"]) {
            CurrencyAccountModel *model = [[CurrencyAccountModel alloc] initWithDict:dataDic];
            [_sourceArray addObject:model];
        }
        [self.tableView reloadData];
    }else{
        [_sourceArray removeAllObjects];
        NSDictionary *dict = @{
                               @"data":@[
                                       @{@"currency":@"EOS", @"isType":@(0)},
                                       @{@"currency":@"BTS", @"isType":@(0)},
                                       @{@"currency":@"ETH", @"isType":@(0)},
                                       @{@"currency":@"ZB", @"isType":@(0)},
                                       @{@"currency":@"HT", @"isType":@(0)},
                                       @{@"currency":@"APPC", @"isType":@(0)},
                                       @{@"currency":@"OKB", @"isType":@(0)}
                                       ]
                               
                               };
        
        
        for (NSDictionary *dataDic in dict[@"data"]) {
            CurrencyAccountModel *model = [[CurrencyAccountModel alloc] initWithDict:dataDic];
            [_sourceArray addObject:model];
        }
        [self.tableView reloadData];
    }
    //[_selectArray removeAllObjects];
    //[_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    CurrencyAccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    CurrencyAccountModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CurrencyAccountModel *model = _sourceArray[indexPath.row];
    if (model.isType == AddCurrency) {
        AddCurrencyViewController *addCurrencyVC = [[AddCurrencyViewController alloc] init];
        [self.navigationController pushViewController:addCurrencyVC animated:YES];
        return;
    }
    if (!model.isSelect) {
        [_selectArray removeAllObjects];
        for (int i = 0; i < _sourceArray.count; i++) {
            CurrencyAccountModel *model = _sourceArray[i];
            if (model.isSelect) {
                [_selectArray addObject:model];
            }
        }
//        if (_selectArray.count >=3) {
//            return;
//        }
    }
    model.isSelect = !model.isSelect;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
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
