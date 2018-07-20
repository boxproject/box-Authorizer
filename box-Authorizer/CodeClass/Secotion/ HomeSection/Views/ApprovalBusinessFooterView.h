//
//  ApprovalBusinessFooterView.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/7/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApprovalBusinessFooterDelegate <NSObject>

@optional
- (void)enterViewLog;
@end

@interface ApprovalBusinessFooterView : UIView

-(id)initWithFrame:(CGRect)frame;

@property (nonatomic,weak) id <ApprovalBusinessFooterDelegate> delegate;

@end
