//
//  languageSwitchTableViewCell.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/7/24.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "languageSwitchTableViewCell.h"

@interface languageSwitchTableViewCell()

@property (nonatomic,strong) UILabel *titleLab;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIImageView *checkImage;

@end

@implementation languageSwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

- (void)createView{
    _titleLab = [[UILabel alloc]init];
    _titleLab.font = Font(14);
    _titleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
    }];
    
    _checkImage = [[UIImageView alloc] init];
    _checkImage.image = [UIImage imageNamed:@"icon_check"];
    [self.contentView addSubview:_checkImage];
    [_checkImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_titleLab);
        make.right.offset(-18);
        make.height.offset(13);
        make.width.offset(18);
    }];
    _checkImage.hidden = YES;
}

- (void)setDataWithModel:(LanguageSwitchModel *)model
{
    if (model.select) {
        _checkImage.hidden = NO;
    }else{
        _checkImage.hidden = YES;
    }
    _titleLab.text = model.titleName;
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
