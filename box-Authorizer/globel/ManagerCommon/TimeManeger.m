//
//  TimeManeger.m
//  box-Authorizer
//
//  Created by Yu Huang on 2018/3/15.
//  Copyright © 2018年 2se. All rights reserved.
//

#import "TimeManeger.h"

@implementation TimeManeger


+ (NSString *)minutesFormatString:(int)totalSeconds{
    
    int seconds = totalSeconds % 60;
    int minutes = totalSeconds / 60;
    //int hours = totalSeconds / 3600;
    
    //return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    if (minutes < 10) {
        return [NSString stringWithFormat:@"0%d:%02d", minutes, seconds];
    }else{
        return [NSString stringWithFormat:@"%d:%02d", minutes, seconds];
    }
    
}


@end
