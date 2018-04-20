//
//  ScanCodeViewController.h
//  box-Staff-Manager
//
//  Created by Rony on 2018/3/2.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, FromFunction) {
    fromInitAccount,
    fromHomeBox
};

typedef void(^Block)(NSString *codeText);

@interface ScanCodeViewController : UIViewController

@property(nonatomic, assign)FromFunction fromFunction;

@property (nonatomic, copy) Block codeBlock;

@end
