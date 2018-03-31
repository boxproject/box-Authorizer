//
//  PrintAlertView.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/13.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, printState) {
    BTConnectFail,        //连接失败
    BTConnectSuccess,     //连接成功
    BTPrinting,           //正在打印
    BTPrintSuccess,       //打印成功
    BTPrintFail,          //打印失败
};

@protocol PrintAlertViewDelegate <NSObject>

@optional
- (void)printRightNow;
- (void)printNew;
- (void)generateContract;
@end

@interface PrintAlertView : UIView

-(id)initWithFrame:(CGRect)frame;

@property (nonatomic,weak) id <PrintAlertViewDelegate> delegate;
//state: 0-连接失败  1-连接成功  2-正在打印 3-打印成功  4-打印失败
-(void)changePrintState:(NSInteger)state;

@end
