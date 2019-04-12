//
//  ProductManager.m
//  Epoch
//
//  Created by iOS on 2018/11/19.
//  Copyright © 2018 iOS. All rights reserved.
//

#define TIME_ZONE @"Asia/Beijing"

#import "MyProductManager.h"
#import "sys/utsname.h"
#include <sys/socket.h> // Per msqr
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#include <ifaddrs.h>
#include <arpa/inet.h>
#include <netdb.h>
#import <dlfcn.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import <SystemConfiguration/SystemConfiguration.h>

#define kDataPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"audio.json"]


static MyProductManager *sectionInstance;

@implementation MyProductManager

+ (id)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sectionInstance = [super allocWithZone:zone];
    });
    return sectionInstance;
}

+ (MyProductManager *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sectionInstance = [[self alloc] init];
    });
    return sectionInstance;
}

- (instancetype)init {
    self = [super init];
    return self;
}

#pragma mark - 获取Window当前显示的ViewController
+ (UIViewController*)getMycurrentViewController{
    UIViewController* vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    while (1) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
        }
        if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
        }
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
        }else{
            break;
        }
    }
    return vc;
}
@end
