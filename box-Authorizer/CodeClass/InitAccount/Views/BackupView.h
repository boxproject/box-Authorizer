//
//  BackupView.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/8.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

static inline UIViewAnimationOptions UIViewAnimationCurveToAnimationOptions(UIViewAnimationCurve curve)
{
    return curve << 16;
}

@protocol BackupViewDelegate <NSObject>

@optional
- (void)backupViewDelegate:(NSString *)passwordStr;
@end

@interface BackupView : UIView

-(id)initWithFrame:(CGRect)frame;

@property (nonatomic,weak) id <BackupViewDelegate> delegate;

@end
