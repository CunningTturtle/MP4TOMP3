//
//  ProductManager.h
//  Epoch
//
//  Created by iOS on 2018/11/19.
//  Copyright © 2018 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MyProductManager : NSObject


//单例
+(MyProductManager*)shareInstance;

#pragma mark - 获取Window当前显示的ViewController
+ (UIViewController*) getMycurrentViewController;
@end
