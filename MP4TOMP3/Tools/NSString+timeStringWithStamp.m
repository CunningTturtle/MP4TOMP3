//
//  NSString+timeStringWithStamp.m
//  MobileMan
//
//  Created by Asuo on 16/7/4.
//  Copyright © 2016年 liWai. All rights reserved.
//

#import "NSString+timeStringWithStamp.h"

@implementation NSString (timeStringWithStamp)

//@"yyyy-MM-dd"
+ (NSString *)timeStringWithTimeStamp:(NSString *)timeStamp andFormater:(NSString *)formatter
{
    if (timeStamp.length == 0) {
        return @"";
    }
    NSString *newStr = [[NSString stringWithFormat:@"%@",timeStamp] substringWithRange:NSMakeRange(0, [NSString stringWithFormat:@"%@",timeStamp].length-3)];
    long stamp = [newStr longLongValue];
    //    stamp = stamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter *currentFormatter = [[NSDateFormatter alloc] init];
    currentFormatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];

    [currentFormatter setDateFormat:formatter];
    NSString *timeStr = [currentFormatter stringFromDate:date];
    return timeStr;
}


+ (NSString *)timeStringWithAMOrPMWithStamp:(NSString *)timeStamp
{
    NSString *newStr = [timeStamp substringWithRange:NSMakeRange(0, timeStamp.length-3)];
    long stamp = [newStr longLongValue];
    //    stamp = stamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:stamp];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale=[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"];
    [dateFormatter setDateFormat:@"yyyy.MM.dd hh:mm a"];
//    NSLog([dateFormatter stringFromDate:[NSDate date]]);
    
    NSString *timeString = [dateFormatter stringFromDate:date];
                            
    return timeString;
    
}

+(NSString *)timeStringWithTimeStame:(double)timeStamp
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timeStamp/1000];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateStyle:kCFDateFormatterShortStyle];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ch"];
    
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:startDate];
    return dateStr;
}

+(NSString *)timeStringWithMsgTimeStame:(double)timeStamp
{
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:timeStamp/1000];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    //    [dateFormatter setDateStyle:kCFDateFormatterShortStyle];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ch"];
    
    dateFormatter.timeZone = [NSTimeZone systemTimeZone];
    [dateFormatter setDateFormat:@"MM-dd HH:mm"];
    NSString *dateStr = [dateFormatter stringFromDate:startDate];
    return dateStr;
}

+ (NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:format]; //(@"YYYY-MM-dd hh:mm:ss") ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    
    
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    
    
    NSDate* date = [formatter dateFromString:formatTime]; //------------将字符串按formatter转成nsdate
    
    //时间转时间戳的方法:
    
//    NSInteger timeSp = [[NSNumber numberWithDouble:[date timeIntervalSince1970]] integerValue];
//    return timeSp;
    return [[NSNumber numberWithDouble:[date timeIntervalSince1970] * 1000] stringValue];
    
}
@end
