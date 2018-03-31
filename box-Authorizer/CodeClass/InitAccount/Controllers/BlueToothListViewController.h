//
//  BlueToothListViewController.h
//  BoxAuthorizer
//
//  Created by Rony on 2018/1/16.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^Block)(NSArray *arrayList);
@interface BlueToothListViewController : UIViewController

@property (nonatomic, strong) Block arrayListBlock;

@property (strong, nonatomic)NSArray *deviArray;  

@end
