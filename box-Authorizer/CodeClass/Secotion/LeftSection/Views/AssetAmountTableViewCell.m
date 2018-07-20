//
//  AssetAmountTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/3/29.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "AssetAmountTableViewCell.h"

#define AssetAmountfreeze  @"冻结"

@interface AssetAmountTableViewCell()

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UILabel *amountLab;

@property (nonatomic,strong) UILabel *freezeLab;

@property (nonatomic,strong) UIView *lineView;

@end

@implementation AssetAmountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}


-(void)createView
{
    _titleLab = [[UILabel alloc]init];
    _titleLab.font = Font(15);
    _titleLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(15);
        make.bottom.offset(0);
    }];
    
    _amountLab = [[UILabel alloc]init];
    _amountLab.font = Font(18);
    _amountLab.textAlignment = NSTextAlignmentRight;
    _amountLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_amountLab];
    [_amountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(-14);
        make.bottom.offset(0);
    }];
    
    /*
    _freezeLab = [[UILabel alloc]init];
    _freezeLab.font = Font(12);
    _freezeLab.textAlignment = NSTextAlignmentRight;
    _freezeLab.textColor = [UIColor colorWithHexString:@"#999999"];
    [self.contentView addSubview:_freezeLab];
    [_freezeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_amountLab.mas_bottom).offset(3);
        make.right.offset(-15);
        make.height.offset(17);
    }];
     */
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
    }];
    
}

- (void)setDataWithModel:(AssetAmountModel *)model;
{
    _titleLab.text = model.currency;
    _amountLab.text = model.balance;
    //_freezeLab.text = [NSString stringWithFormat:@"%@ %@",AssetAmountfreeze,model.freezeAmount];
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
