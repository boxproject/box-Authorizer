//
//  NewsTableViewCell.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/12.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "NewsTableViewCell.h"

@interface NewsTableViewCell()

@property (nonatomic,strong) UILabel *leftLab;
@property (nonatomic,strong) UILabel *rightLab;

@end

@implementation NewsTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

- (void)createView{
    
    _leftLab = [[UILabel alloc]init];
    _leftLab.font = Font(14);
    _leftLab.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:_leftLab];
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.offset(15);
        make.left.equalTo(_leftLab.mas_right).offset(9);
        make.right.offset(-115);
    }];
    
    _rightLab = [[UILabel alloc]init];
    _rightLab.font = Font(13);
    _rightLab.textAlignment = NSTextAlignmentRight;
    _rightLab.textColor = [UIColor lightGrayColor];;
    [self.contentView addSubview:_rightLab];
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.width.offset(100);
        make.right.offset(-15);
    }];
    
}

- (void)setDataWithModel:(NewsModel *)model
{
    _leftLab.text = model.content;
    _rightLab.text = [TimeManeger getElapseTimeToStringHelp:[model.newsId integerValue] ];
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
