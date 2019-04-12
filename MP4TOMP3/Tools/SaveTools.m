//
//  SaveTools.m
//  EventToRemind
//
//  Created by mc309 on 2018/12/17.
//  Copyright © 2018年 mc309. All rights reserved.
//

#import "SaveTools.h"

@implementation SaveTools
// 使用NSSearchPathForDirectoriesInDomains创建文件目录
- (void)createDir {
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"AdViewImageS"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    // fileExistsAtPath 判断一个文件或目录是否有效，isDirectory判断是否一个目录
    BOOL existed = [fileManager fileExistsAtPath:dataFilePath isDirectory:&isDir];
    if ( !(isDir == YES && existed == YES) ) {
        // 在 Document 目录下创建一个 head 目录
        [fileManager createDirectoryAtPath:dataFilePath withIntermediateDirectories:YES attributes:nil error:nil];
    }
}
/**
 *  删除旧图片
 */
- (void)deleteOldImageWithImageName:(NSString *)imageName {
    if (imageName.length > 0) {
        NSString *filePath = [self getFilePathWithImageName:imageName];
        NSFileManager *fileManager = [NSFileManager defaultManager];
        BOOL isSucess = [fileManager removeItemAtPath:filePath error:nil];
        if (isSucess) {
            NSLog(@"删除%@成功",imageName);
        }
    }
}
- (NSMutableArray *)getAllSaveImageArrays {
    NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"AdViewImageS"];
    NSDirectoryEnumerator * myDirectoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:dataFilePath];
    NSMutableArray *imageArrays = [[NSMutableArray alloc]init];
    for (NSString *name in myDirectoryEnumerator) {
        [imageArrays addObject:name];
    }
    NSLog(@"save的图片的地址--->>>%@",imageArrays);
    return imageArrays;
}
- (NSString *)saveImageWithImg:(UIImage *)img {
    // 拼接沙盒路径
    NSString *imgName = [self getFileName:YES];
    NSString *filePath = [self getFilePathWithImageName:imgName];
    BOOL isExist = [self isFileExistWithFilePath:filePath];
    if (!isExist){// 如果该图片不存在，则删除老图片，下载新图片
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self createDir];
            NSString *filePath = [self getFilePathWithImageName:imgName]; // 保存文件的名称
            if ([UIImagePNGRepresentation(img) writeToFile:filePath atomically:YES]) {// 保存成功
                NSLog(@"保存成功");
                // 如果有广告链接，将广告链接也保存下来
            } else {
                NSLog(@"保存失败");
            }
        });
    }
    return imgName;
}
//根据时间戳返回一个图片名字
- (NSString *)getFileName:(BOOL)isImg {
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval interval = [currentDate timeIntervalSince1970];
    return [NSString stringWithFormat:@"%f",interval];
}
/**
 *  判断文件是否存在
 */
- (BOOL)isFileExistWithFilePath:(NSString *)filePath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = FALSE;
    return [fileManager fileExistsAtPath:filePath isDirectory:&isDirectory];
}


/**
 *  根据图片名拼接文件路径
 */
- (NSString *)getFilePathWithImageName:(NSString *)imageName {
    if (imageName) {
        NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"AdViewImageS"];
        NSString *filePath = [dataFilePath stringByAppendingPathComponent:imageName];
        return filePath;
    } else {
        NSString * docsdir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString *dataFilePath = [docsdir stringByAppendingPathComponent:@"AdViewImageS"];
        return dataFilePath;
    }
}
- (UIImage *)imageWithImageName:(NSString *)imgName {
    return [UIImage imageWithContentsOfFile:[self getFilePathWithImageName:imgName]];
}
@end
