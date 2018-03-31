//
//  CIQRCodeManager.h
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/14.
//  Copyright © 2018年 2se. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CIQRCodeManager : NSObject

/**  生成二维码 */
+ (UIImage *)createImageWithString:(NSString *)string;

@end
