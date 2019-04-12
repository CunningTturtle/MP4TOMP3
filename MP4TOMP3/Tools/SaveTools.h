//
//  SaveTools.h
//  EventToRemind
//
//  Created by mc309 on 2018/12/17.
//  Copyright © 2018年 mc309. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SaveTools : NSObject
//保存图片 返回图片名字
- (NSString *)saveImageWithImg:(UIImage *)img;
//删除图片
- (NSMutableArray *)getAllSaveImageArrays;
//通过图片名字获取图片
- (UIImage *)imageWithImageName:(NSString *)imgName;
//删除图片
- (void)deleteOldImageWithImageName:(NSString *)imageName;

//获取图片file
- (NSString *)getFilePathWithImageName:(NSString *)imageName;
@end

NS_ASSUME_NONNULL_END
