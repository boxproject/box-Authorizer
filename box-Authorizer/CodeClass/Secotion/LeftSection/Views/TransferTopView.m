//
//  TransferTopView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/30.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferTopView.h"

#define TransferTopViewCurrency  @"币种"
#define TransferTopViewReceiptAddress  @"收款地址"
#define TransferTopViewAmount  @"金额"
#define TransferTopViewApplyMenber  @"申请人"
#define TransferTopViewApplyReason  @"申请理由"
#define TransferTopViewMinersFee  @"矿工费"
#define TransferTopViewStateOne  @"待审批"
#define TransferTopViewStateTwo  @"审批中"
#define TransferTopViewStateThreeTransfing  @"审批通过(转账中)"
#define TransferTopViewStateThree  @"审批通过(转账成功)"
#define TransferTopViewStateFour  @"已拒绝审批"
#define TransferTopViewTitle  @"审批进度："

@interface TransferTopView ()<UITextFieldDelegate>

@property (nonatomic,strong)UILabel *amountLab;
@property (nonatomic,strong)UILabel *stateLab;
@property (nonatomic,strong)UILabel *currencyInfoLab;
@property (nonatomic,strong)UILabel *adressInfoLab;
@property (nonatomic,strong)UILabel *amountInfoLab;
@property (nonatomic,strong)UILabel *applyMenber;
@property (nonatomic,strong)UILabel *applyReasonInfoLab;
@property (nonatomic,strong)UILabel *minersFeeInfoLab;
@property (nonatomic,strong)UILabel *bottomTitle;

@end


@implementation TransferTopView

-(id)initWithFrame:(CGRect)frame dic:(NSDictionary *)dic{
    self = [super initWithFrame:frame];
    if (self) {
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
    mainView.layer.cornerRadius = 3.f;
    mainView.layer.masksToBounds = YES;
    mainView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    
    _amountLab = [[UILabel alloc] init];
    _amountLab.textAlignment = NSTextAlignmentCenter;
    _amountLab.font = FontBold(24);
    _amountLab.text = @"";
    _amountLab.textColor = [UIColor colorWithHexString:@"#444444"];
    [mainView addSubview:_amountLab];
    [_amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(33);
    }];
    
    _stateLab = [[UILabel alloc] init];
    _stateLab.textAlignment = NSTextAlignmentCenter;
    _stateLab.font = Font(14);
    _stateLab.text = @"";
    _stateLab.textColor = [UIColor colorWithHexString:@"#999999"];
    [mainView addSubview:_stateLab];
    [_stateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_amountLab.mas_bottom).offset(2);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(20);
    }];
    
    //币种
    UILabel *currencyLab = [[UILabel alloc] init];
    currencyLab.textAlignment = NSTextAlignmentLeft;
    currencyLab.font = Font(14);
    currencyLab.text = TransferTopViewCurrency;
    currencyLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [mainView addSubview:currencyLab];
    [currencyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stateLab.mas_bottom).offset(13);
        make.left.offset(14);
        make.height.offset(20);
    }];
    
    _currencyInfoLab = [[UILabel alloc] init];
    _currencyInfoLab.textAlignment = NSTextAlignmentRight;
    _currencyInfoLab.font = Font(14);
    _currencyInfoLab.text = @"";
    _currencyInfoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [mainView addSubview:_currencyInfoLab];
    [_currencyInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_stateLab.mas_bottom).offset(13);
        make.right.offset(-15);
        make.height.offset(20);
    }];
    
    //收款地址
    UILabel *addressLab = [[UILabel alloc] init];
    addressLab.textAlignment = NSTextAlignmentLeft;
    addressLab.font = Font(14);
    addressLab.text = TransferTopViewReceiptAddress;
    addressLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [mainView addSubview:addressLab];
    [addressLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currencyLab.mas_bottom).offset(10);
        make.left.offset(14);
        make.height.offset(20);
    }];
    
    _adressInfoLab = [[UILabel alloc] init];
    _adressInfoLab.textAlignment = NSTextAlignmentRight;
    _adressInfoLab.font = Font(12);
    _adressInfoLab.text = @"";
    _adressInfoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [mainView addSubview:_adressInfoLab];
    [_adressInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(currencyLab.mas_bottom).offset(10);
        make.right.offset(-14);
        make.height.offset(20);
        make.left.offset(75);
    }];
    
   
    //金额
    UILabel *amountLab = [[UILabel alloc] init];
    amountLab.textAlignment = NSTextAlignmentLeft;
    amountLab.font = Font(14);
    amountLab.text = TransferTopViewAmount;
    amountLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [mainView addSubview:amountLab];
    [amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLab.mas_bottom).offset(10);
        make.left.offset(14);
        make.height.offset(20);
    }];
    
    _amountInfoLab = [[UILabel alloc] init];
    _amountInfoLab.textAlignment = NSTextAlignmentRight;
    _amountInfoLab.font = Font(14);
    _amountInfoLab.text = @"";
    _amountInfoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [mainView addSubview:_amountInfoLab];
    [_amountInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(addressLab.mas_bottom).offset(10);
        make.right.offset(-14);
        make.height.offset(20);
    }];
    
    //申请人
    UILabel *applyMenberLab = [[UILabel alloc] init];
    applyMenberLab.textAlignment = NSTextAlignmentLeft;
    applyMenberLab.font = Font(14);
    applyMenberLab.text = TransferTopViewApplyMenber;
    applyMenberLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [mainView addSubview:applyMenberLab];
    [applyMenberLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLab.mas_bottom).offset(10);
        make.left.offset(14);
        make.height.offset(20);
    }];
    
    _applyMenber = [[UILabel alloc] init];
    _applyMenber.textAlignment = NSTextAlignmentRight;
    _applyMenber.font = Font(14);
    _applyMenber.text = @"";
    _applyMenber.textColor = [UIColor colorWithHexString:@"#333333"];
    [mainView addSubview:_applyMenber];
    [_applyMenber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(amountLab.mas_bottom).offset(10);
        make.right.offset(-14);
        make.height.offset(20);
    }];
    
    //申请理由
    UILabel *applyReasonLab = [[UILabel alloc] init];
    applyReasonLab.textAlignment = NSTextAlignmentLeft;
    applyReasonLab.font = Font(14);
    applyReasonLab.text = TransferTopViewApplyReason;
    applyReasonLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [mainView addSubview:applyReasonLab];
    [applyReasonLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyMenberLab.mas_bottom).offset(10);
        make.left.offset(14);
        make.height.offset(20);
    }];
    
    _applyReasonInfoLab = [[UILabel alloc] init];
    _applyReasonInfoLab.textAlignment = NSTextAlignmentRight;
    _applyReasonInfoLab.font = Font(14);
    _applyReasonInfoLab.text = @"";
    _applyReasonInfoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [mainView addSubview:_applyReasonInfoLab];
    [_applyReasonInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyMenberLab.mas_bottom).offset(10);
        make.right.offset(-14);
        make.height.offset(20);
    }];
    
    //矿工费
    UILabel *minersFeeLab = [[UILabel alloc] init];
    minersFeeLab.textAlignment = NSTextAlignmentLeft;
    minersFeeLab.font = Font(14);
    minersFeeLab.text = TransferTopViewMinersFee;
    minersFeeLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [mainView addSubview:minersFeeLab];
    [minersFeeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyReasonLab.mas_bottom).offset(10);
        make.left.offset(14);
        make.height.offset(20);
    }];
    
    _minersFeeInfoLab = [[UILabel alloc] init];
    _minersFeeInfoLab.textAlignment = NSTextAlignmentRight;
    _minersFeeInfoLab.font = Font(14);
    _minersFeeInfoLab.text = @"";
    _minersFeeInfoLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [mainView addSubview:_minersFeeInfoLab];
    [_minersFeeInfoLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(applyReasonLab.mas_bottom).offset(10);
        make.right.offset(-14);
        make.height.offset(20);
    }];
    

    UIImageView *lineImg = [[UIImageView alloc] init];
    //lineImg.backgroundColor = kRedColor;
    lineImg.image = [UIImage imageNamed:@"lineImgIcon"];
    [mainView addSubview:lineImg];
    [lineImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(minersFeeLab.mas_bottom).offset(25);
        make.left.offset(16);
        make.right.offset(-15);
        make.height.offset(1.5);
    }];
    
    UIView *leftbdg = [[UIView alloc] init];
    leftbdg.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    leftbdg.layer.cornerRadius = 8.0f;
    leftbdg.layer.masksToBounds = YES;
    [mainView addSubview:leftbdg];
    [leftbdg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(-8);
        make.height.offset(16);
        make.width.offset(16);
        make.centerY.equalTo(lineImg);
    }];
    
    UIView *rightbdg = [[UIView alloc] init];
    rightbdg.backgroundColor = [UIColor colorWithHexString:@"#292e40"];
    rightbdg.layer.cornerRadius = 8.0f;
    rightbdg.layer.masksToBounds = YES;
    [mainView addSubview:rightbdg];
    [rightbdg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(8);
        make.height.offset(16);
        make.width.offset(16);
        make.centerY.equalTo(lineImg);
    }];
    
    UIImageView *leftTitleImg = [[UIImageView alloc] init];
    //leftTitleImg.backgroundColor = kRedColor;
    leftTitleImg.image = [UIImage imageNamed:@"leftTitleImg"];
    [mainView addSubview:leftTitleImg];
    [leftTitleImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineImg.mas_bottom).offset(15);
        make.left.offset(15);
        make.height.offset(21);
        make.width.offset(21);
    }];
    
    _bottomTitle = [[UILabel alloc] init];
    _bottomTitle.textAlignment = NSTextAlignmentLeft;
    _bottomTitle.font = Font(14);
    //_bottomTitle.text = [NSString stringWithFormat:@"%@%@", TransferTopViewTitle,@"等待黄大大审批"];
    _bottomTitle.textColor = [UIColor colorWithHexString:@"#666666"];
    [mainView addSubview:_bottomTitle];
    [_bottomTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(leftTitleImg);
        make.left.equalTo(leftTitleImg.mas_right).offset(9);
        make.height.offset(20);
        make.right.offset(-15);
    }];

}

-(void)setValueWithData:(NSDictionary *)dic
{
    NSString *currency = dic[@"currency"];
    NSString *amount = dic[@"amount"];
    NSString *tx_info = dic[@"tx_info"];
    NSString *miner = dic[@"miner"];
    NSString *to_address = dic[@"to_address"];
    NSInteger progress = [dic[@"progress"] integerValue];
    NSInteger arrived = [dic[@"arrived"] integerValue];
    NSString *accont = dic[@"account"];
    _amountLab.text = [NSString stringWithFormat:@"-%@%@", amount, currency];
    _currencyInfoLab.text = currency;
    _adressInfoLab.text = to_address;
    _amountInfoLab.text = [NSString stringWithFormat:@"-%@%@", amount, currency];
    _applyMenber.text = accont;
    _applyReasonInfoLab.text = tx_info;
    _minersFeeInfoLab.text = miner;
    
    switch (progress) {
        case 0:
            _stateLab.text = TransferTopViewStateOne;
            _bottomTitle.text = [NSString stringWithFormat:@"%@%@", TransferTopViewTitle,TransferTopViewStateOne];
            break;
        case 1:
            _stateLab.text = TransferTopViewStateTwo;
            _bottomTitle.text = [NSString stringWithFormat:@"%@%@", TransferTopViewTitle,TransferTopViewStateTwo];
            break;
        case 2:
            _stateLab.text = TransferTopViewStateFour;
            _bottomTitle.text = [NSString stringWithFormat:@"%@%@", TransferTopViewTitle,TransferTopViewStateFour];
            break;
        case 3:
            if (arrived == 1) {
                _stateLab.text = TransferTopViewStateThreeTransfing;
                _bottomTitle.text = [NSString stringWithFormat:@"%@%@", TransferTopViewTitle,TransferTopViewStateThreeTransfing];
            }else if(arrived == 2){
                _stateLab.text = TransferTopViewStateThree;
                _bottomTitle.text = [NSString stringWithFormat:@"%@%@", TransferTopViewTitle,TransferTopViewStateThree];
            }
            break;
        default:
            break;
    }
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
