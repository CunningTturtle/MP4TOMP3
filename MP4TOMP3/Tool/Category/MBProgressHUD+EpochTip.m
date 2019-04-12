//
//  MBProgressHUD+EpochTip.m
//  Epoch
//
//  Created by iOS on 2018/11/19.
//  Copyright © 2018 iOS. All rights reserved.
//

#import "MBProgressHUD+EpochTip.h"

@implementation MBProgressHUD (EpochTip)

+ (MBProgressHUD*)createMBProgressHUDviewWithMessage:(NSString*)message isWindiw:(BOOL)isWindow {
    UIView  *view = isWindow? (UIView*)[UIApplication sharedApplication].delegate.window:[MyProductManager getMycurrentViewController].view;
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text=message?message:@"加载中.....";
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

#pragma mark-------------------- show Tip----------------------------

+ (void)showTipMessageInWindow:(NSString*)message {
    [self showTipMessage:message isWindow:true timer:1.5];
}
+ (void)showTipMessageInView:(NSString*)message {
    [self showTipMessage:message isWindow:false timer:1.5];
}
+ (void)showTipMessageInWindow:(NSString*)message timer:(int)aTimer {
    [self showTipMessage:message isWindow:true timer:aTimer];
}
+ (void)showTipMessageInView:(NSString*)message timer:(int)aTimer {
    [self showTipMessage:message isWindow:false timer:aTimer];
}
+ (void)showTipMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer {
    MBProgressHUD *hud = [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeText;
    [hud hideAnimated:YES afterDelay:aTimer];
}


#pragma mark-------------------- show Activity----------------------------

+ (void)showActivityMessageInWindow:(NSString*)message {
    [self showActivityMessage:message isWindow:true timer:0];
}
+ (void)showActivityMessageInView:(NSString*)message {
    [self showActivityMessage:message isWindow:false timer:0];
}
+ (void)showActivityMessageInWindow:(NSString*)message timer:(int)aTimer {
    [self showActivityMessage:message isWindow:true timer:aTimer];
}
+ (void)showActivityMessageInView:(NSString*)message timer:(int)aTimer {
    [self showActivityMessage:message isWindow:false timer:aTimer];
}
+ (void)showActivityMessage:(NSString*)message isWindow:(BOOL)isWindow timer:(int)aTimer {
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.mode = MBProgressHUDModeIndeterminate;
    if (aTimer>0) {
        [hud hideAnimated:YES afterDelay:aTimer];
    }
    hud.label.numberOfLines = 2;
    hud.label.textColor = [UIColor flatBlackColor];
    hud.label.font = [UIFont systemFontOfSize:15.0f];
    hud.animationType = MBProgressHUDAnimationFade;
    [hud hideAnimated:YES afterDelay:1.0f];
}

#pragma mark-------------------- show Image----------------------------

+ (void)showSuccessMessage:(NSString *)Message {
    [self showCustomIconInWindow:@"成功" message:Message];
}
+ (void)showErrorMessage:(NSString *)Message {
    [self showCustomIconInWindow:@"错误" message:Message];
}
+ (void)showInfoMessage:(NSString *)Message {
    [self showCustomIconInWindow:@"消息" message:Message];
}
+ (void)showWarnMessage:(NSString *)Message {
    [self showCustomIconInWindow:@"信息" message:Message];
}
+ (void)showCustomIconInWindow:(NSString *)iconName message:(NSString *)message {
    [self showCustomIcon:iconName message:message isWindow:true];
}
+ (void)showCustomIconInView:(NSString *)iconName message:(NSString *)message {
    [self showCustomIcon:iconName message:message isWindow:false];
}
+ (void)showCustomIcon:(NSString *)iconName message:(NSString *)message isWindow:(BOOL)isWindow {
    MBProgressHUD *hud  =  [self createMBProgressHUDviewWithMessage:message isWindiw:isWindow];
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:iconName]];
    hud.mode = MBProgressHUDModeCustomView;
    hud.label.numberOfLines = 2;
    hud.label.textColor = [UIColor flatBlackColor];
    hud.label.font = [UIFont systemFontOfSize:15.0f];
    hud.animationType = MBProgressHUDAnimationFade;
    [hud hideAnimated:YES afterDelay:1.0f];
}

+ (void)hideHUD {
    UIView  *winView =(UIView*)[UIApplication sharedApplication].delegate.window;
    [self hideHUDForView:winView animated:YES];
    [self hideHUDForView:[MyProductManager getMycurrentViewController].view animated:YES];
}


@end
