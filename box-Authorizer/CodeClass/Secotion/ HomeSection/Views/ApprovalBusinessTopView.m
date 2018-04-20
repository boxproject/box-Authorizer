//
//  ApprovalBusinessTopView.m
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ApprovalBusinessTopView.h"

#define ApprovalBusinessTopViewAmountlimit  @"金额上限"

@interface ApprovalBusinessTopView ()

@property (nonatomic,strong)UILabel *leftLab;
@property (nonatomic,strong)UILabel *rightLab;

@end

@implementation ApprovalBusinessTopView
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
    mainView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    [self addSubview:mainView];
    [mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.left.offset(0);
        make.right.offset(0);
        make.bottom.offset(0);
    }];
    
    UIImageView *img = [[UIImageView alloc] init];
    img.image = [UIImage imageNamed:@"icon_service_shenpi"];
    [self addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(17);
        make.left.offset(15);
        make.width.offset(27);
        make.height.offset(27);
    }];
    
    _leftLab = [[UILabel alloc] init];
    _leftLab.textAlignment = NSTextAlignmentLeft;
    _leftLab.font = Font(14);
    _leftLab.text = @"";
    _leftLab.textColor = [UIColor colorWithHexString:@"#2b3350"];
    [self addSubview:_leftLab];
    [_leftLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.left.equalTo(img.mas_right).offset(8);
        make.right.offset(-130);
        make.height.offset(20);
    }];
    
    _rightLab = [[UILabel alloc] init];
    _rightLab.textAlignment = NSTextAlignmentRight;
    _rightLab.font = Font(13);
    _rightLab.text = @"";
    _rightLab.textColor = [UIColor colorWithHexString:@"#2b3350"];
    [self addSubview:_rightLab];
    [_rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(img);
        make.right.offset(-15);
        make.left.equalTo(_leftLab.mas_right).offset(10);
        make.height.offset(20);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHexString:@"#e8e8e8"];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(59);
        make.left.offset(15);
        make.right.offset(-15);
        make.height.offset(1);
    }];
   
}

-(void)setValueWithData:(NSDictionary *)dic
{
    NSString *flow_name = dic[@"flow_name"];
    NSString *single_limit = dic[@"single_limit"];
    _leftLab.text = flow_name;
    _rightLab.text = [NSString stringWithFormat:@"%@ %@", ApprovalBusinessTopViewAmountlimit, single_limit];
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
