//
//  ApprovalBusinessTableViewCell.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/19.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessTableViewCell.h"
 
@interface ApprovalBusinessTableViewCell()

@property (nonatomic,strong) UILabel *approvalTitleLab;

@property (nonatomic,strong) UIView *lineView;

@property (nonatomic,strong) UILabel *approvalStateLab;

@property (nonatomic,strong) UIImageView *rightIcon;

@end

@implementation ApprovalBusinessTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.backgroundColor = [UIColor whiteColor];
    [self createView];
    return self;
}

- (void)createView{
    
    UIImageView *leftImg = [[UIImageView alloc] init];
    leftImg.image = [UIImage imageNamed:@"leftImg_icon"];
    [self.contentView addSubview:leftImg];
    [leftImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.offset(20);
        make.height.offset(20);
    }];
    
    _approvalTitleLab = [[UILabel alloc]init];
    _approvalTitleLab.font = Font(14);
    _approvalTitleLab.textColor = [UIColor colorWithHexString:@"#333333"];
    [self.contentView addSubview:_approvalTitleLab];
    [_approvalTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.equalTo(leftImg.mas_right).offset(9);
        make.right.offset(-130);
    }];
    
    _rightIcon = [[UIImageView alloc] init];
    _rightIcon.image = [UIImage imageNamed:@"right_icon"];
    [self.contentView addSubview:_rightIcon];
    [_rightIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-12);
        make.centerY.equalTo(self.contentView);
        make.width.offset(20);
        make.height.offset(22);
    }];
    
    _approvalStateLab = [[UILabel alloc]init];
    _approvalStateLab.font = Font(14);
    _approvalStateLab.textAlignment = NSTextAlignmentRight;
    _approvalStateLab.textColor = [UIColor colorWithHexString:@"#666666"];
    [self.contentView addSubview:_approvalStateLab];
    [_approvalStateLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(0);
        make.bottom.offset(0);
        make.left.equalTo(_approvalTitleLab.mas_right).offset(10);
        make.right.equalTo(_rightIcon.mas_left).offset(-2);
    }];
    
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

/*
 HASH_STATUS_0 = "0" //待申请
 HASH_STATUS_1 = "1" //私钥已申请提交
 HASH_STATUS_2 = "2" //私钥已拒绝提交 私钥A拒绝
 HASH_STATUS_3 = "3" //私链已申请确认(日志)
 HASH_STATUS_4 = "4" //私链已同意确认 私钥B、私钥C均同意
 HASH_STATUS_5 = "5" //私链已拒绝确认 私钥B、私钥C有不同意
 HASH_STATUS_6 = "6" //私链已同意(日志)
 HASH_STATUS_7 = "7" //公链已同意
 HASH_STATUS_8 = "8" //公链已拒绝
 */

- (void)setDataWithModel:(ApprovalBusinessModel *)model
{
    _approvalTitleLab.text = model.Name;
    if ([model.Status isEqualToString:@"0"] || [model.Status isEqualToString:@"3"]) {
        _approvalStateLab.text = ApprovalAwaitBusiness;
    }else if([model.Status isEqualToString:@"5"] || [model.Status isEqualToString:@"2"]){
        _approvalStateLab.text = ApprovalFailBusiness;
    }else if([model.Status isEqualToString:@"7"]){
        _approvalStateLab.text = ApprovalSucceedBusiness;
    }else if([model.Status isEqualToString:@"9"]){
        _approvalStateLab.text = ApprovalCancel;
    }
    else {
        _approvalStateLab.text = ApprovalingBusiness;
    }
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
