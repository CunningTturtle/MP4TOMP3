//
//  UIViewController+Share.m
//  MP4TOMP3
//
//  Created by mc309 on 2019/4/11.
//  Copyright © 2019年 iOS. All rights reserved.
//

#import "UIViewController+Share.h"

@implementation UIViewController (Share)
- (void)shareWithImg:(UIImage *)img {
    //分享的标题
//    NSString *textToShare = @"分享的标题。";
    //分享的图片
    UIImage *imageToShare = img;
    //分享的url
//    NSURL *urlToShare = [NSURL URLWithString:@"http://www.baidu.com"];
    //在这里呢 如果想分享图片 就把图片添加进去  文字什么的通上
    NSArray *activityItems = @[imageToShare];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:nil];
    //不出现在活动项目
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard,UIActivityTypeAssignToContact,UIActivityTypeSaveToCameraRoll];
    [self presentViewController:activityVC animated:YES completion:nil];
    // 分享之后的回调
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"completed");
            //分享 成功
        } else  {
            NSLog(@"cancled");
            //分享 取消
        }
    };
}
@end
