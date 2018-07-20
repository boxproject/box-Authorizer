//
//  ApprovalBusinessTopView.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/3.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApprovalBusinessTopDelegate <NSObject>

@optional
- (void)queryForLimitTime;
@end

@interface ApprovalBusinessTopView : UIView

-(id)initWithFrame:(CGRect)frame dic:(NSDictionary *)dic;

-(void)setValueWithData:(NSDictionary *)dic;

@property (nonatomic,weak) id <ApprovalBusinessTopDelegate> delegate;
@property (nonatomic,strong)UILabel *rightLab;

@end
