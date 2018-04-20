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


//根据时间戳计算已过时间
+ (NSString *)getElapseTimeToStringHelp:(NSInteger)second{
    if (second <= 0) {
        return @"";
    }
    NSInteger currentTime = [[NSDate date]timeIntervalSince1970] * 1000;
    NSInteger elapseTime = (currentTime - second)/1000;
    //如果逝去时间大于24小时则直接显示日期，如果小于24小时显示已逝去小时，如果不足1小时则按照分钟计算
    int month=((int)elapseTime)/(3600*24*30);
    int days=((int)elapseTime)/(3600*24);
    int hours=((int)elapseTime)%(3600*24)/3600;
    int minute=((int)elapseTime)%(3600*24)/60;
    int seconds=((int)elapseTime)%(3600*24)%60;
    
    NSString *dateContent;
    NSDateFormatter  *dateformatter1 = [[NSDateFormatter alloc] init];
    [dateformatter1 setDateFormat:@"yyyy.M.d HH:mm"];
    NSTimeInterval timeInterval1 = second/1000;
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:timeInterval1];
    NSString *dateStr1=[dateformatter1 stringFromDate:date1];
    
    NSDateFormatter  *dateformatter2 = [[NSDateFormatter alloc] init];
    [dateformatter2 setDateFormat:@"HH:mm"];
    NSTimeInterval timeInterval2 = second/1000;
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:timeInterval2];
    NSString *dateStr2=[dateformatter2 stringFromDate:date2];
    if(month!=0){
        //dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",month,@"个月前"];
        dateContent = dateStr1;
    }else if(days!=0){
        if (days == 1) {
            dateContent = [NSString stringWithFormat:@"昨天 %@",dateStr2];
        }else if(days == 2){
            dateContent = [NSString stringWithFormat:@"前天 %@",dateStr2];
        }else{
            dateContent = dateStr1;
        }
        //dateContent = [NSString stringWithFormat:@"%@%i%@",@"   ",days,@"天前"];
    }else if(hours!=0){
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"",hours,@"小时前"];
    }else if(minute <= 0){
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"",seconds,@"秒前"];
        //dateContent = @"刚刚";
    }else{
        dateContent = [NSString stringWithFormat:@"%@%i%@",@"",minute,@"分钟前"];
    }
    return dateContent;
}


@end
