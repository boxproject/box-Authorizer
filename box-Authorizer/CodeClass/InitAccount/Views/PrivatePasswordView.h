//
//  PrivatePasswordView.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/14.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline UIViewAnimationOptions UIViewAnimationCurveToAnimationOptions(UIViewAnimationCurve curve)
{
    return curve << 16;
}

@protocol PrivatePasswordViewDelegate <NSObject>

@optional
- (void)PrivatePasswordViewDelegate:(NSString *)passwordStr;
@end

@interface PrivatePasswordView : UIView

-(id)initWithFrame:(CGRect)frame;

@property (nonatomic,weak) id <PrivatePasswordViewDelegate> delegate;

@end
