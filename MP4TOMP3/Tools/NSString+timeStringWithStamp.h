//
//  NSString+timeStringWithStamp.h
//  MobileMan
//
//  Created by Asuo on 16/7/4.
//  Copyright © 2016年 liWai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (timeStringWithStamp)

/** 用时间戳转时间字符串 yyyy-MM-dd*/
+ (NSString *)timeStringWithTimeStamp:(NSString *)timeStamp andFormater:(NSString *)formatter;


+ (NSString *)timeStringWithAMOrPMWithStamp:(NSString *)timeStamp;

+ (NSString *)timeStringWithTimeStame:(double)timeStamp;

+(NSString *)timeStringWithMsgTimeStame:(double)timeStamp;

// 时间转时间戳
+ (NSString *)timeSwitchTimestamp:(NSString *)formatTime andFormatter:(NSString *)format;


@end
