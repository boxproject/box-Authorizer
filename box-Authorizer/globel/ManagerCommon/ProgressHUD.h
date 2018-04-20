//
//  ProgressHUD.h
//  box-Staff-Manager
//
//  Created by Yu Huang on 2018/4/1.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressHUD : NSObject

+(void)showProgressHUD;
+(void)showStatus:(NSInteger)code;

@end
