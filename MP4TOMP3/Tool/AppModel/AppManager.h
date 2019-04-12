//
//  AppManager.h
//  MP4TOMP3
//
//  Created by iOS on 2019/3/25.
//  Copyright © 2019 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppManager : NSObject

#pragma mark - 单例
+ (AppManager *)shareInstance;


/**
 *@ switch
 *@ 开/关
 */
@property(nonatomic,copy) NSString *userof;
/**
 *@ url
 *@ 链接
 */
@property(nonatomic,copy) NSString *useropen;


@end

NS_ASSUME_NONNULL_END
