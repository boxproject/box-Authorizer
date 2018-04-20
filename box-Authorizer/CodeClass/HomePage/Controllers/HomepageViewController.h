//
//  HomepageViewController.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/15.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ShowAgentStatus) {
    AgentStatusError,     //异常
    AgentStatusNoStable,  //不稳定
    AgentStatusStable     //稳定
};

@interface HomepageViewController : UIViewController

@property(nonatomic, assign)ShowAgentStatus showAgentStatus;

@end
