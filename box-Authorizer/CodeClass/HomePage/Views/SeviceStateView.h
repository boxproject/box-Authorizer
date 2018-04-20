//
//  SeviceStateView.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
 
@protocol SeviceStateViewDelegate <NSObject>

@optional
- (void)SeviceState:(NSInteger)state;
@end

@interface SeviceStateView : UIView

-(id)initWithFrame:(CGRect)frame state:(NSInteger)state;

@property (nonatomic,weak) id <SeviceStateViewDelegate> delegate;

@end
