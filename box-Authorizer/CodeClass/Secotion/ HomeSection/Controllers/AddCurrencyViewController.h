//
//  AddCurrencyViewController.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/18.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddCurrencyDelegate <NSObject>

@optional
- (void)addCurrencyDelegateReflesh;
@end

@interface AddCurrencyViewController : UIViewController

@property (nonatomic,weak) id <AddCurrencyDelegate> delegate;

@end
