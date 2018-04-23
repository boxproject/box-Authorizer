//
//  LeftMenuViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/20.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LeftMenuTableViewCell.h"
#import "LeftMenuModel.h"
#import "AboutBoxViewController.h"
#import "LanguageSwitchViewController.h"
#import "ModifyServerAddressViewController.h"

#define CellReuseIdentifier  @"LeftMenu"
#define TableViewCellHeight  55

@interface LeftMenuViewController ()<UITableViewDelegate, UITableViewDataSource>
/** 头像 */
@property(nonatomic, strong)UIImageView *headImg;
/** 名字 */
@property(nonatomic, strong)UILabel *nameLab;
@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"#1e2440"];
    _sourceArray = [[NSMutableArray alloc] init];
    NSDictionary *dict = @{
                           @"data":@[
                                   @{@"titleName":@"服务器地址"},
                                   @{@"titleName":@"关于BOX"}
                                   ]
                           };
    for (NSDictionary *dataDic in dict[@"data"]) {
        LeftMenuModel *model = [[LeftMenuModel alloc] initWithDict:dataDic];
        [_sourceArray addObject:model];
    }
    [self createView];
    [self.tableView reloadData];
    
}


-(void)createView
{
    _headImg = [[UIImageView alloc] init];
    _headImg.image = [UIImage imageNamed:@"leftMenuHeadImg"];
    [self.view addSubview:_headImg];
    [_headImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(20);
        make.top.offset(125/2);
        make.height.offset(25);
        make.width.offset(25);
    }];
    
    _nameLab = [[UILabel alloc] init];
    _nameLab.text = [BoxDataManager sharedManager].applyer_account;
    _nameLab.textAlignment = NSTextAlignmentLeft;
    _nameLab.font = Font(18);
    _nameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    _nameLab.numberOfLines = 1;
    [self.view addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImg.mas_right).offset(12);
        make.top.offset(125/2);
        make.height.offset(25);
        make.width.offset(200);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor colorWithHexString:@"#2e334f"];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(_nameLab.mas_bottom).offset(40);
        make.right.offset(-0);
        make.height.offset(_sourceArray.count * TableViewCellHeight);
    }];
    [_tableView registerClass:[LeftMenuTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return TableViewCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LeftMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    LeftMenuModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) {
        ModifyServerAddressViewController *modifyServerAdressVC = [[ModifyServerAddressViewController alloc] init];
        [self.navigationController pushViewController:modifyServerAdressVC animated:YES];
        [self.sidePanelController toggleRightPanel:nil];
        [self addNSNotificationCenter:modifyServerAdressVC];
    }else if(indexPath.row == 1){
        AboutBoxViewController *aboutBoxVC = [[AboutBoxViewController alloc] init];
        [self.navigationController pushViewController:aboutBoxVC animated:YES];
        [self addNSNotificationCenter:aboutBoxVC];
    }
}

-(void)addNSNotificationCenter:(UIViewController *)vc
{
    [[NSNotificationCenter defaultCenter]
     postNotificationName:@"pushNextVC" object:vc];
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
