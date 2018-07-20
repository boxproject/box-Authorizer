//
//  TransferRecordTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TransferRecordTableViewCell.h"

#define TransferRecordTableViewCellTransferingAwait  @"待审批"
#define TransferRecordTableViewCellTransfering  @"审批中"
#define TransferRecordTableViewCellTransferStateSucceed  @"同意审批(转账成功)"
#define TransferRecordTableViewCellTransferStateSucceedTransfing  @"同意审批(转账中)"
#define TransferRecordTableViewCellTransferStateFail  @"同意审批(转账失败)"
#define TransferRecordTableViewCellRecharge  @"充值成功"
#define TransferRecordTableViewCellTransferFail  @"拒绝审批"

@interface TransferRecordTableViewCell()

@property (nonatomic,strong) UILabel *topLeftLab;
@property (nonatomic,strong) UILabel *bottomLeftLab;
@property (nonatomic,strong) UILabel *topRightlab;
@property (nonatomic,strong) UILabel *bottomRightlab;
@property (nonatomic,strong) UIView *lineView;

@end

@implementation TransferRecordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

- (void)createView{
    
    UIImageView *leftImg = [[UIImageView alloc] init];
    leftImg.image = [UIImage imageNamed:@"transferRecord_lefticon"];
    [self.contentView addSubview:leftImg];
    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.top.offset(12);
        make.width.offset(14);
        make.height.offset(14);
    }];
    
    _topLeftLab = [[UILabel alloc]init];
    _topLeftLab.font = Font(14);
    _topLeftLab.textColor = [UIColor colorWithHexString:@"#323232"];
    [self.contentView addSubview:_topLeftLab];
    [_topLeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(9);
        make.height.offset(20);
        make.left.equalTo(leftImg.mas_right).offset(9);
        make.right.offset(-120);
    }];
    
    _bottomLeftLab = [[UILabel alloc]init];
    _bottomLeftLab.font = Font(12);
    _bottomLeftLab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:_bottomLeftLab];
    [_bottomLeftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topLeftLab.mas_bottom).offset(1);
        make.height.offset(17);
        make.left.equalTo(leftImg.mas_right).offset(9);
        make.right.offset(-120);
    }];
    
    _topRightlab = [[UILabel alloc]init];
    _topRightlab.font = Font(14);
    _topRightlab.textAlignment = NSTextAlignmentRight;
    _topRightlab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_topRightlab];
    [_topRightlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(9);
        make.height.offset(19);
        make.width.offset(130);
        make.right.offset(-15);
    }];
    
    _bottomRightlab = [[UILabel alloc]init];
    _bottomRightlab.font = Font(12);
    _bottomRightlab.textAlignment = NSTextAlignmentRight;
    _bottomRightlab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:_bottomRightlab];
    [_bottomRightlab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topRightlab.mas_bottom).offset(2);
        make.height.offset(17);
        make.width.offset(150);
        make.right.offset(-15);
    }];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
    }];
    
}

- (void)setDataWithModel:(TransferAwaitModel *)model
{
    _topLeftLab.text = model.tx_info;
    if (model.type == 1) {
        _topRightlab.text = [NSString stringWithFormat:@"+%@%@", model.amount, model.currency];
        _bottomRightlab.text = TransferRecordTableViewCellRecharge;
    }else if(model.type == 0){
        _topRightlab.text = [NSString stringWithFormat:@"-%@%@", model.amount, model.currency];
        [self handleProgress:model];
    }
    _bottomLeftLab.text = [self getElapseTimeToString:model.apply_at];
}

-(void)handleProgress:(TransferAwaitModel *)model
{
    switch (model.progress) {
        case ApprovalAwait:
        {
            _bottomRightlab.text = TransferRecordTableViewCellTransferingAwait;
            break;
        }
        case Approvaling:
        {
            _bottomRightlab.text = TransferRecordTableViewCellTransfering;
            break;
        }
        case ApprovalSucceed:
        {
            if (model.arrived == 1) {
                _bottomRightlab.text = TransferRecordTableViewCellTransferStateSucceedTransfing;
            }else if (model.arrived == 2){
                _bottomRightlab.text = TransferRecordTableViewCellTransferStateSucceed;
            }else if (model.arrived == -1){
                _bottomRightlab.text = TransferRecordTableViewCellTransferStateFail;
            }
            break;
        }
        case ApprovalFail:
        {
            _bottomRightlab.text = TransferRecordTableViewCellTransferFail;
            break;
        }
        default:
            break;
    }
}

- (NSString *)getElapseTimeToString:(NSInteger)second{
    NSDateFormatter  *dateformatter1 = [[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"M月d日 HH:mm"];
    NSTimeInterval timeInterval1 = second;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInterval1];
    NSString *dateStr1=[dateformatter1 stringFromDate:date1];
    return dateStr1;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
