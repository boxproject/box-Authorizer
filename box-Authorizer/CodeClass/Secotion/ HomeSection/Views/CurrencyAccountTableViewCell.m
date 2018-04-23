//
//  CurrencyAccountTableViewCell.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/18.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "CurrencyAccountTableViewCell.h"

#define CurrencyAccountTableViewCellAddCurrency  @"新增代币"

@interface CurrencyAccountTableViewCell()

@property (nonatomic,strong) UILabel *currencyLab;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UIImageView *checkImage;

@end

@implementation CurrencyAccountTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

- (void)createView{
    _currencyLab = [[UILabel alloc]init];
    _currencyLab.font = Font(15);
    _currencyLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_currencyLab];
    [_currencyLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(16);
        make.right.offset(-16);
    }];

    _checkImage = [[UIImageView alloc] init];
    _checkImage.image = [UIImage imageNamed:@"icon_check"];
    [self.contentView addSubview:_checkImage];
    [_checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_currencyLab);
        make.right.offset(-18);
        make.height.offset(16);
        make.width.offset(20);
    }];
    _checkImage.hidden = YES;
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.offset(16);
        make.right.offset(-15);
        make.height.offset(1);
    }];
}

- (void)setDataWithModel:(CurrencyAccountModel *)model
{
    _checkImage.hidden = YES;
    if (model.isType == NoAddCurrency) {
         _currencyLab.text = model.TokenName;
    }else{
        //创建富文本
        NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@", CurrencyAccountTableViewCellAddCurrency]];
        [attri addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#4c7afd"] range:NSMakeRange(0, CurrencyAccountTableViewCellAddCurrency.length + 1)];
        //NSTextAttachment可以将要插入的图片作为特殊字符处理
        NSTextAttachment *attch = [[NSTextAttachment alloc] init];
        //定义图片内容及位置和大小
        attch.image = [UIImage imageNamed:@"icon_add"];
        attch.bounds = CGRectMake(0, -0.5, 13.5, 13.5);
        //创建带有图片的富文本
        NSAttributedString *string = [NSAttributedString attributedStringWithAttachment:attch];
        //将图片放在最后一位
        //[attri appendAttributedString:string];
        //将图片放在第一位
        [attri insertAttributedString:string atIndex:0];
        
        _currencyLab.attributedText = attri;
    }
}

- (void)setDataWithCoinlistModel:(CoinlistModel *)model
{
    if (model.used) {
       _checkImage.hidden = NO;
    }else{
        _checkImage.hidden = YES;
    }
    _currencyLab.text = model.Name;
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
