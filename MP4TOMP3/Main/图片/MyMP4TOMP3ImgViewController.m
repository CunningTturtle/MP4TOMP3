//
//  MP4TOMP3ImgViewController.m
//  MP4TOMP3
//
//  Created by iOS on 2019/3/21.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "MyMP4TOMP3ImgViewController.h"
#import "HXPhotoPicker.h"
#import <AVFoundation/AVFoundation.h>
#import "UIViewController+Share.h"
#import "SaveTools.h"

@interface MyMP4TOMP3ImgViewController ()<HXPhotoViewDelegate,UIImagePickerControllerDelegate>


@property (strong, nonatomic) HXPhotoManager *manager;

@property (strong, nonatomic) HXPhotoView *photoView;

@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;


@end

@implementation MyMP4TOMP3ImgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self settingManager];
    [self settingImg];
    [self settingUI];
    
}
- (void)settingManager {
    _toolManager = [[HXDatePhotoToolManager alloc] init];
}

- (void)settingImg {
    _manager = [[HXPhotoManager alloc] initWithType:HXPhotoManagerSelectedTypeVideo];
    _manager.configuration.openCamera = NO;
    _manager.configuration.lookLivePhoto = YES;
    _manager.configuration.videoMaxNum = 1;
    _manager.configuration.maxNum = 1;
    _manager.configuration.languageType = HXPhotoLanguageTypeSc;
    _manager.configuration.creationDateSort = NO;
    _manager.configuration.saveSystemAblum = NO;
    _manager.configuration.showOriginalBytes = YES;
    _manager.configuration.selectTogether = NO;
    _manager.configuration.videoCanEdit = YES;
    _manager.configuration.hideOriginalBtn = YES;
    _manager.configuration.statusBarStyle = UIStatusBarStyleLightContent;
}

- (IBAction)addNew:(id)sender {
    if (self.manager.afterSelectedCount <1) {
        [MBProgressHUD showWarnMessage:@"请选择视频"];
        return;
    }
    //拿到图片
    [self.manager.afterSelectedVideoArray hx_requestImageWithOriginal:YES completion:^(NSArray<UIImage *> * _Nullable imageArray, NSArray<HXPhotoModel *> * _Nullable errorArray) {
        NSLog(@"imageArray=%@",imageArray);
        for (UIImage *img in imageArray) {
            NSData *imageData = UIImagePNGRepresentation(img);
            UIImage *image2 = [UIImage imageWithData:imageData];
            UIImageWriteToSavedPhotosAlbum(image2, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
            [[SaveTools new] saveImageWithImg:image2];
        }
    }];
}

// 成功保存图片到相册中, 必须调用此方法, 否则会报参数越界错误
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [TSMessage showNotificationInViewController:self title:@"保存失败" subtitle:@"请重新选择视频文件" type:TSMessageNotificationTypeError];
    }else {
        [MBProgressHUD showSuccessMessage:@"保存成功"];
    }
}


- (void)settingUI {
    CGFloat width = self.view.frame.size.width;
    HXPhotoView *photoView = [HXPhotoView photoManager:self.manager];
    photoView.frame = CGRectMake(15.0f,kStatusBarHeight + kNavBarHeight + 15.0f, width - 30.0f * 2, 122);
    photoView.delegate = self;
    photoView.outerCamera = NO;
    photoView.previewStyle = HXPhotoViewPreViewShowStyleDefault;
    photoView.previewShowDeleteButton = YES;
    photoView.showAddCell = YES;
    [photoView.collectionView reloadData];
    photoView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:photoView];
    self.photoView = photoView;
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)photoView:(HXPhotoView *)photoView changeComplete:(NSArray<HXPhotoModel *> *)allList photos:(NSArray<HXPhotoModel *> *)photos videos:(NSArray<HXPhotoModel *> *)videos original:(BOOL)isOriginal {
    NSLog(@"选择完成");
}

- (void)photoView:(HXPhotoView *)photoView deleteNetworkPhoto:(NSString *)networkPhotoUrl {
    NSSLog(@"%@",networkPhotoUrl);
}

- (void)photoView:(HXPhotoView *)photoView updateFrame:(CGRect)frame {
    NSSLog(@"%@",NSStringFromCGRect(frame));
}

- (void)photoView:(HXPhotoView *)photoView currentDeleteModel:(HXPhotoModel *)model currentIndex:(NSInteger)index {
    NSSLog(@"%@ --> index - %ld",model,index);
}

- (BOOL)photoView:(HXPhotoView *)photoView collectionViewShouldSelectItemAtIndexPath:(NSIndexPath *)indexPath model:(HXPhotoModel *)model {
    return YES;
}

- (void)photoView:(HXPhotoView *)photoView gestureRecognizerBegan:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    NSSLog(@"长按手势开始了 - %ld",indexPath.item);
}

- (void)photoView:(HXPhotoView *)photoView gestureRecognizerChange:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    NSSLog(@"长按手势改变了-%ld",indexPath.item);
}

- (void)photoView:(HXPhotoView *)photoView gestureRecognizerEnded:(UILongPressGestureRecognizer *)longPgr indexPath:(NSIndexPath *)indexPath {
    NSSLog(@"长按手势结束了 - %ld",indexPath.item);
}
@end
