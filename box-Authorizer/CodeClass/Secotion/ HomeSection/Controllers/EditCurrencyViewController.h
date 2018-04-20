//
//  EditCurrencyViewController.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/4/11.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CurrencyAccountModel.h"

@protocol EditCurrencyDelegate <NSObject>

@optional
- (void)editCurrencyDelegateReflesh;
@end

@interface EditCurrencyViewController : UIViewController

@property(nonatomic, strong)CurrencyAccountModel *model;
@property (nonatomic,weak) id <EditCurrencyDelegate> delegate;

@end
