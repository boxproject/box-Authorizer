//
//  LanguageSwitchViewController.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/21.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "LanguageSwitchViewController.h"
#import "LanguageSwitchModel.h"
#import "languageSwitchTableViewCell.h"

#define  LanguageSwitchTitle  @"语言"
#define CellReuseIdentifier  @"languageSwitch"

@interface LanguageSwitchViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic, strong)NSMutableArray *sourceArray;
@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) NSInteger pageSize;

@end

@implementation LanguageSwitchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kWhiteColor;
    self.navigationController.navigationBar.hidden = NO;
    self.title = LanguageSwitchTitle;
    [self createBarItem];
    
    _sourceArray = [[NSMutableArray alloc] init];
    [self createView];
    NSDictionary *dict = @{
                           @"data":@[
                                   @{@"titleName":SimplifiedChinese,@"select":@(YES)},
                                   @{@"titleName":@"English",@"select":@(NO)}
                                   ]
                                   };
    for (NSDictionary *dataDic in dict[@"data"]) {
        LanguageSwitchModel *model = [[LanguageSwitchModel alloc] initWithDict:dataDic];
        [_sourceArray addObject:model];
    }
    [self.tableView reloadData];
}
                                   
-(void)createView
{
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
    [_tableView registerClass:[languageSwitchTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    // 去掉底部多余的表格线
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    languageSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    LanguageSwitchModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LanguageSwitchModel *model = self.sourceArray[indexPath.row];
    for (LanguageSwitchModel *languageSwitchModel in self.sourceArray) {
        if (![languageSwitchModel.titleName isEqualToString:model.titleName]) {
            if (languageSwitchModel.select) {
                model.select = languageSwitchModel.select;
                languageSwitchModel.select = !languageSwitchModel.select;
            }
        }
    }
    [self.tableView reloadData];
}

#pragma mark - createBarItem
- (void)createBarItem{
    UIImage *leftImage = [[UIImage imageNamed:@"icon_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *buttonLeft = [[UIBarButtonItem alloc]initWithImage:leftImage style:UIBarButtonItemStylePlain target:self action:@selector(backAction:)];
    self.navigationItem.leftBarButtonItem = buttonLeft;
    
    UIBarButtonItem *buttonRight = [[UIBarButtonItem alloc]initWithTitle:Affirm style:UIBarButtonItemStyleDone target:self action:@selector(rightButtonAction:)];
    self.navigationItem.rightBarButtonItem = buttonRight;
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateSelected];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:Font(15),NSFontAttributeName,[UIColor colorWithHexString:@"#666666"],NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
}

#pragma mark ----- rightBarButtonItemAction -----
- (void)rightButtonAction:(UIBarButtonItem *)buttonItem{
    [self.navigationController popViewControllerAnimated:YES];
    [self.sidePanelController setCenterPanelHidden:NO];
    //[self.sidePanelController showCenterPanelAnimated:NO];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)backAction:(UIBarButtonItem *)barButtonItem
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.sidePanelController setCenterPanelHidden:NO];
    //[self.sidePanelController showCenterPanelAnimated:NO];
    self.navigationController.navigationBar.hidden = YES;
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
