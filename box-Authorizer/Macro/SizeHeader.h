//
//  SizeHeader.h
//  box-Staff-Manager
//
//  Created by Rony on 2018/2/27.
//  Copyright © 2018年 2se. All rights reserved.
//

#ifndef SizeHeader_h
#define SizeHeader_h

#define SCREEN_WIDTH  [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height

#define kStatusBarHeight [[UIApplication sharedApplication] statusBarFrame].size.height
#define kNavBarHeight 44.0
#define kTabBarHeight ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define kTopHeight ([[UIApplication sharedApplication] statusBarFrame].size.height + 44.0)

#endif /* SizeHeader_h */
