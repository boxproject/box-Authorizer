//
//  ApprovalBusinessTopView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessTopView.h"
#import "CurrencyDetailTableViewCell.h"

#define CellReuseIdentifier  @"CurrencyDetailTableViewCell"

@interface ApprovalBusinessTopView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic,strong)UILabel *leftLab;
@property (nonatomic,strong)UILabel *limitLab;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *sourceArray;

@end

@implementation ApprovalBusinessTopView
-(id)initWithFrame:(CGRect)frame dic:(NSDictionary *)dic{
    self = [super initWithFrame:frame];
    if (self) {
        _sourceArray = [[NSMutableArray alloc] init];
        [self createView:dic];
    }
    return self;
}

-(void)createView:(NSDictionary *)dic
{
    UIView *topView = [[UIView alloc] init];
    topView.layer.cornerRadius = 3.f;
    topView.layer.masksToBounds = YES;
    topView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:topView];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(10);
    }];
    
    UIView *mainView = [[UIView alloc] init];
    mainView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"icon_service_shenpi"];
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(17);
        make.left.offset(15);
        make.width.offset(27);
        make.height.offset(27);
    }];
    
    _leftLab = [[UILabel alloc] init];
    _leftLab.textAlignment = NSTextAlignmentLeft;
    _leftLab.font = Font(13);
    _leftLab.text = @"";
    _leftLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:_leftLab];
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.left.equalTo(img.mas_right).offset(8);
        make.height.offset(20);
    }];
    
    _rightLab = [[UILabel alloc] init];
    _rightLab.textAlignment = NSTextAlignmentRight;
    _rightLab.font = Font(13);
    _rightLab.text = @"";
    _rightLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:_rightLab];
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.right.offset(-15);
        make.left.equalTo(_leftLab.mas_right).offset(10);
        make.height.offset(20);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(59);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
    }];
    
    UILabel *limitTimeLab = [[UILabel alloc] init];
    limitTimeLab.textAlignment = NSTextAlignmentLeft;
    limitTimeLab.font = Font(14);
    limitTimeLab.text = LimitTimes;
    limitTimeLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self addSubview:limitTimeLab];
    [limitTimeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(13);
        make.height.offset(20);
        make.left.offset(15);
    }];
    
    _limitLab = [[UILabel alloc] init];
    _limitLab.textAlignment = NSTextAlignmentRight;
    _limitLab.font = Font(14);
    _limitLab.textColor = [UIColor colorWithHexString:@"#2b335"];
    [self addSubview:_limitLab];
    [_limitLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(limitTimeLab);
        make.height.offset(20);
        make.right.offset(-33);
    }];
    
    UIImageView *queryImg = [[UIImageView alloc] init];
    queryImg.image = [UIImage imageNamed:@"icon_question"];
    [self addSubview:queryImg];
    [queryImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15);
        make.centerY.equalTo(_limitLab);
        make.width.offset(12);
        make.height.offset(12);
        
    }];
    
    UIButton *queryBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [queryBtn addTarget:self action:@selector(queryBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:queryBtn];
    [queryBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_limitLab);
        make.right.offset(-5);
        make.width.offset(35);
        make.height.offset(50);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:(UITableViewStylePlain)];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.showsVerticalScrollIndicator = NO;
    _tableView.showsHorizontalScrollIndicator = NO;
    _tableView.scrollEnabled  = NO;
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.top.equalTo(limitTimeLab.mas_bottom).offset(4);
        make.right.offset(-0);
        make.bottom.offset(-10);
    }];
    [_tableView registerClass:[CurrencyDetailTableViewCell class] forCellReuseIdentifier:CellReuseIdentifier];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *lineTwo = [[UIView alloc]init];
    lineTwo.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self addSubview:lineTwo];
    [lineTwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.offset(-13);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
    }];
}

-(void)queryBtnAction:(UIButton *)btn
{
    if ([self.delegate respondsToSelector:@selector(queryForLimitTime)]) {
        [self.delegate queryForLimitTime];
    }
}

-(void)setValueWithData:(NSDictionary *)dic
{
    NSString *flow_name = dic[@"flow_name"];
    NSString *period = dic[@"period"];
    NSArray *flowLimitArr = dic[@"flow_limit"];
    _leftLab.text = flow_name;
    _limitLab.text = [NSString stringWithFormat:@"%@%@", period, AccountPasswordHour];
    for (NSDictionary *flowLimitDic in flowLimitArr) {
        CurrencyModel *model = [[CurrencyModel alloc] initWithDict:flowLimitDic];
        [_sourceArray addObject:model];
    }
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.sourceArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CurrencyDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellReuseIdentifier forIndexPath:indexPath];
    CurrencyModel *model = self.sourceArray[indexPath.row];
    cell.model = model;
    [cell setDataWithModel:model];
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
