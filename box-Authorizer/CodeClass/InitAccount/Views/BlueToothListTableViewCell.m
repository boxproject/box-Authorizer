//
//  BlueToothListTableViewCell.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/13.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "BlueToothListTableViewCell.h"
#import <Masonry/Masonry.h>

@interface BlueToothListTableViewCell()
/** 蓝牙名称 */
@property (nonatomic,strong) UILabel *nameLabel;
/** 连接状态 */
@property (nonatomic,strong) UILabel *linkLabel;

@end

@implementation BlueToothListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

- (void)createView{
    
    _nameLabel = [[UILabel alloc]init];
    _nameLabel.font = [UIFont systemFontOfSize:16];
    _nameLabel.textColor = [UIColor colorWithHexString:@"#474747"];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.contentView).offset(15);
        make.top.offset(0);
        make.bottom.offset(0);
    }];
    
    _linkLabel = [[UILabel alloc]init];
    _linkLabel.text = @"未连接";
    _linkLabel.textAlignment = NSTextAlignmentRight;
    _linkLabel.font = [UIFont systemFontOfSize:16];
    _linkLabel.textColor = [UIColor colorWithHexString:@"#474747"];
    [self.contentView addSubview:_linkLabel];
    _linkLabel.hidden = YES;
    [_linkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_nameLabel);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.width.offset(80);
        make.height.offset(20);
        
    }];
    
    UIView *lineView = [[UIView alloc]init];
    lineView.backgroundColor = [UIColor colorWithHexString:@"#eaeaea"];
    [self.contentView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-1);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
    }];
    
}


- (void)setDataWithModel:(BlueToothListModel *)model
{
    _nameLabel.text = model.blueTooth;
    if (model.isSelect) {
        _linkLabel.text = @"连接成功";
        _linkLabel.textColor = [UIColor colorWithHexString:@"#f96268"];
    }else{
        _linkLabel.text = @"未连接";
        _linkLabel.textColor = [UIColor colorWithHexString:@"#50b4ff"];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
