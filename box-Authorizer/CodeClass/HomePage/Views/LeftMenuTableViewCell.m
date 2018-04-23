//
//  LeftMenuTableViewCell.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/21.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "LeftMenuTableViewCell.h"

@interface LeftMenuTableViewCell()

@property (nonatomic,strong) UILabel *titleLab;

@property (nonatomic,strong) UIView *lineView;

@end

@implementation LeftMenuTableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor colorWithHexString:@"#2e334f"];
    [self createView];
    return self;
}

- (void)createView{
    
    _titleLab = [[UILabel alloc]init];
    _titleLab.font = Font(14);
    _titleLab.textColor = [UIColor colorWithHexString:@"#d2d7f1"];
    [self.contentView addSubview:_titleLab];
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(20);
        make.right.offset(-20);
        
    }];
    
    _lineView = [[UIView alloc]init];
    _lineView.backgroundColor = [UIColor colorWithHexString:@"#222239"];
    [self.contentView addSubview:_lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(0);
        make.left.offset(0);
        make.right.offset(0);
        make.height.offset(1);
    }];
}

- (void)setDataWithModel:(LeftMenuModel *)model
{
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
