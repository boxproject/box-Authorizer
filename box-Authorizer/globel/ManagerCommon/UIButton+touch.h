//
//  UIButton+touch.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/5/25.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#define defaultInterval .7  // 默认间隔时间
@interface UIButton (touch)
/**
 *  设置点击时间间隔
 */
@property (nonatomic, assign) NSTimeInterval timeInterVal;
@end
