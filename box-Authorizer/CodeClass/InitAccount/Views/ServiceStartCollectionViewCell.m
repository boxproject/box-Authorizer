//
//  ServiceStartCollectionViewCell.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/11.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "ServiceStartCollectionViewCell.h"
#import "AuthorizerInfoModel.h"

@interface ServiceStartCollectionViewCell()

@property (nonatomic,strong) UILabel *nameLab;

@property (nonatomic,strong) UIImageView *img;

@property (nonatomic, strong) NSArray *array;

@end

@implementation ServiceStartCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self createView];
        NSString *KeyStoreStatus = [BoxDataManager sharedManager].KeyStoreStatus;
        _array = [JsonObject dictionaryWithJsonStringArr:KeyStoreStatus];
    }
    return self;
}

-(void)createView
{
    _img = [[UIImageView alloc] init];
    _img.image = [UIImage imageNamed:@"icon_off"];
    [self.contentView addSubview:_img];
    [_img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(5);
        make.centerX.equalTo(self);
        make.width.height.offset(49);
    }];
    
    _nameLab = [[UILabel alloc]init];
    _nameLab.font = Font(15);
    _nameLab.textColor = [UIColor colorWithHexString:@"#ffffff"];
    _nameLab.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_nameLab];
    [_nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_img.mas_bottom).offset(11);
        make.height.offset(21);
        make.centerX.equalTo(self);
    }];
}

- (void)setDataWithModel:(ServiceStartModel *)model
{
    if (model.Authorized) {
        _img.image = [UIImage imageNamed:@"icon_on"];
    }else{
        _img.image = [UIImage imageNamed:@"icon_off"];
    }
    _nameLab.text = @"";
    for (NSDictionary *dic in _array) {
        AuthorizerInfoModel *auModel = [[AuthorizerInfoModel alloc] initWithDict:dic];
        if ([auModel.ApplyerId isEqualToString:model.ApplyerId]) {
             _nameLab.text = auModel.ApplyerName;;
        }
    }
}



@end
