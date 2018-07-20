//
//  CurrencyDetailTableViewCell.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "CurrencyDetailTableViewCell.h"

@interface CurrencyDetailTableViewCell()

@property (nonatomic,strong) UILabel *leftLab;

@property (nonatomic,strong) UILabel *rightLab;

@end

@implementation CurrencyDetailTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

-(void)createView
{
    _leftLab = [[UILabel alloc]init];
    _leftLab.font = Font(14);
    _leftLab.textColor = [UIColor colorWithHexString:@"#2b3350"];
    [self.contentView addSubview:_leftLab];
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.left.offset(15);
        make.width.offset(90);
        make.bottom.offset(0);
    }];
    
    _rightLab = [[UILabel alloc]init];
    _rightLab.font = Font(14);
    _rightLab.textAlignment = NSTextAlignmentRight;
    _rightLab.textColor = [UIColor colorWithHexString:@"#2b3350"];
    [self.contentView addSubview:_rightLab];
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.right.offset(-16);
        make.left.equalTo(_leftLab.mas_right).offset(15);
        make.bottom.offset(0);
    }];
}

- (void)setDataWithModel:(CurrencyModel *)model
{
    _leftLab.text = [NSString stringWithFormat:@"%@%@", model.currency, Limit];
    _rightLab.text = model.limit;
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
