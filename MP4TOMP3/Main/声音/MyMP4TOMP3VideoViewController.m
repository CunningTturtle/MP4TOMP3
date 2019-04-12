//
//  MP4TOMP3VideoViewController.m
//  MP4TOMP3
//
//  Created by iOS on 2019/3/21.
//  Copyright © 2019 iOS. All rights reserved.
//

#import "MyMP4TOMP3VideoViewController.h"
#import "HXPhotoPicker.h"
#import <AVFoundation/AVFoundation.h>
#import <lame/lame.h>

@interface MyMP4TOMP3VideoViewController ()<HXPhotoViewDelegate,UIImagePickerControllerDelegate>


@property (strong, nonatomic) HXPhotoManager *manager;

@property (strong, nonatomic) HXPhotoView *photoView;

@property (strong, nonatomic) HXDatePhotoToolManager *toolManager;


@end

@implementation MyMP4TOMP3VideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatData];
    [self settingUI];
    
}
- (void)creatData {
    
    _toolManager = [[HXDatePhotoToolManager alloc] init];
    
    
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
- (IBAction)addNew:(id)sender {
    
    if (self.manager.afterSelectedCount <1) {
        [MBProgressHUD showWarnMessage:@"请选择视频"];
        return;
    }
    //1、获取视频fileURL,提取背景音乐
    HXPhotoModel *model = [self.manager.afterSelectedVideoArray firstObject];
    NSLog(@"%@",model.fileURL);
    NSString *videoUrlStr = [model.fileURL absoluteString];
    if ([videoUrlStr containsString:@"MP4"] || [videoUrlStr containsString:@"mp4"]) {
        [self accessAudioFromVideo:model.fileURL];
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD showErrorMessage:@"抱歉，音乐提取目前只支持MP4文件"];
        });
        return ;
    }
}



/**
 提取视频中的音频
 */
-(void)accessAudioFromVideo:(NSURL *)videoPath {

    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD showActivityMessageInView:@"提取中···"];
    });
    AVAsset *videoAsset = [AVAsset assetWithURL:videoPath];
    //1创建一个AVMutableComposition
    AVMutableComposition *mixComposition = [[AVMutableComposition alloc]init];
    //2 创建一个轨道,类型为AVMediaTypeAudio
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    
    //获取videoPath的音频插入轨道
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration) ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    //4创建输出路径
    NSURL *outputURL = [NSURL fileURLWithPath:[self exporterPath:@"m4a"]];
    
    //5创建输出对象
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc]initWithAsset:mixComposition presetName:AVAssetExportPresetAppleM4A];
    exporter.outputURL = outputURL ;
    exporter.outputFileType = AVFileTypeAppleM4A;
    exporter.shouldOptimizeForNetworkUse = YES;
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        if (exporter.status == AVAssetExportSessionStatusCompleted) {
            NSURL *outputURL = exporter.outputURL;
            //创建MP3输出路径
            NSString *mp3Path = [self exporterPath:@"mp3"];
            if (![mp3Path containsString:@".mp3"]) {
                NSLog(@"不是mp3");
            }
            
            NSString * wavPath = [mp3Path stringByReplacingOccurrencesOfString:@".mp3" withString:@".wav"];
            
            [self convetM4aToWav:outputURL destUrl:wavPath completed:^(NSError *error) {
                if (error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [MBProgressHUD showErrorMessage:@"格式转换错误"];
                    });
                    NSLog(@"M4A转WAV失败\n%@\n%@",[outputURL absoluteString],wavPath);
                }else{
                    NSLog(@"M4A转WAV成功");
                    //由WAV转MP3格式
                    [self changeWavToMp3WithOriginalPath:wavPath withMp3Path:mp3Path completed:^(NSException *exception) {
                        if (exception) {
                            NSLog(@"MP3转换失败");
                            [TSMessage showNotificationInViewController:self title:@"保存失败" subtitle:@"请重新选择视频文件" type:TSMessageNotificationTypeError];
                        }else {
                            NSLog(@"MP3转换成功%@",mp3Path);
                            dispatch_async(dispatch_get_main_queue(), ^{
                                [MBProgressHUD hideHUD];
                                //保存文件
                                [MBProgressHUD showSuccessMessage:[NSString stringWithFormat:@"文件保存成功%@",mp3Path]];
                            });
                        }
                    }];
                }
            }];
        }else {
            NSLog(@"失败%@",exporter.error.description);
        }
    }];
    
}


- (void)convetM4aToWav:(NSURL *)originalUrl
               destUrl:(NSString *)destUrlStr
             completed:(void (^)(NSError *error)) completed {
    
    NSLog(@"\n\n\nM4A-WAV\n\n\n");
    
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:destUrlStr]) {
        [[NSFileManager defaultManager] removeItemAtPath:destUrlStr error:nil];
    }
    NSURL *destUrl     = [NSURL fileURLWithPath:destUrlStr];
    AVURLAsset *songAsset = [AVURLAsset URLAssetWithURL:originalUrl options:nil];
    
    //读取原始文件信息
    NSError *error = nil;
    AVAssetReader *assetReader = [AVAssetReader assetReaderWithAsset:songAsset error:&error];
    if (error) {
        NSLog (@"error: %@", error);
        completed(error);
        return;
    }
    AVAssetReaderOutput *assetReaderOutput = [AVAssetReaderAudioMixOutput
                                              assetReaderAudioMixOutputWithAudioTracks:songAsset.tracks
                                              audioSettings: nil];
    if (![assetReader canAddOutput:assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        completed(error);
        return;
    }
    [assetReader addOutput:assetReaderOutput];
    
    AVAssetWriter *assetWriter = [AVAssetWriter assetWriterWithURL:destUrl
                                                          fileType:AVFileTypeCoreAudioFormat
                                                             error:&error];
    if (error) {
        NSLog (@"error: %@", error);
        completed(error);
        return;
    }
    AudioChannelLayout channelLayout;
    memset(&channelLayout, 0, sizeof(AudioChannelLayout));
    channelLayout.mChannelLayoutTag = kAudioChannelLayoutTag_Stereo;
    NSDictionary *outputSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                    [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                    [NSNumber numberWithFloat:44100], AVSampleRateKey,
                                    [NSNumber numberWithInt:2], AVNumberOfChannelsKey,
                                    [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                    [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                    [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                    nil];
    AVAssetWriterInput *assetWriterInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                              outputSettings:outputSettings];
    if ([assetWriter canAddInput:assetWriterInput]) {
        [assetWriter addInput:assetWriterInput];
    } else {
        NSLog (@"can't add asset writer input... die!");
        completed(error);
        return;
    }
    
    assetWriterInput.expectsMediaDataInRealTime = NO;
    
    [assetWriter startWriting];
    [assetReader startReading];
    
    AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
    [assetWriter startSessionAtSourceTime:startTime];
    
    __block UInt64 convertedByteCount = 0;
    
    dispatch_queue_t mediaInputQueue = dispatch_queue_create("mediaInputQueue", NULL);
    [assetWriterInput requestMediaDataWhenReadyOnQueue:mediaInputQueue
                                            usingBlock: ^
     {
         while (assetWriterInput.readyForMoreMediaData) {
             CMSampleBufferRef nextBuffer = [assetReaderOutput copyNextSampleBuffer];
             if (nextBuffer) {
                 // append buffer
                 [assetWriterInput appendSampleBuffer: nextBuffer];
//                 NSLog (@"appended a buffer (%zu bytes)",
//                        CMSampleBufferGetTotalSampleSize (nextBuffer));
                 convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                 
                 
             } else {
                 [assetWriterInput markAsFinished];
                 [assetWriter finishWritingWithCompletionHandler:^{
                     
                 }];
                 [assetReader cancelReading];
                 NSDictionary *outputFileAttributes = [[NSFileManager defaultManager]
                                                       attributesOfItemAtPath:[destUrl path]
                                                       error:nil];
                 NSLog (@"FlyElephant %lld",[outputFileAttributes fileSize]);
                 break;
             }
         }
         NSLog(@"转换结束");
         // 删除临时temprecordAudio.m4a文件
         NSError *removeError = nil;
         
         if ([[NSFileManager defaultManager] fileExistsAtPath:[originalUrl path]]) {
             BOOL success = [[NSFileManager defaultManager] removeItemAtPath:[originalUrl path] error:&removeError];
             if (!success) {
                 NSLog(@"删除临时temprecordAudio.m4a文件失败:%@",removeError);
                 completed(removeError);
             }else{
                 NSLog(@"删除临时temprecordAudio.m4a文件:%@成功",originalUrl);
                 completed(removeError);
             }
         }else {
             NSLog(@"文件不存在");
         }
     }];
}

-(void *)changeWavToMp3WithOriginalPath:(NSString*)originalPath withMp3Path:(NSString*)mp3Path completed:(void (^)(NSException *exception)) completed
{
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    if([fileManager removeItemAtPath:mp3Path error:nil])
    {
        NSLog(@"删除旧的MP3");
    }
    
    @try {
        int read, write;
        
        FILE *pcm = fopen([originalPath cStringUsingEncoding:1], "rb");  //source 被转换的音频文件位置
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3Path cStringUsingEncoding:1], "wb");  //output 输出生成的Mp3文件位置

        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_in_samplerate(lame, 22050.0 * 2);
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        
        do {
            read = (int)fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    //如果抛出异常
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
        if (exception) {
            completed(exception);
        }else{
            completed(nil);
        }
    }
    @finally {
        // 删除临时wav文件
        NSError *removeError = nil;
        if ([[NSFileManager defaultManager] fileExistsAtPath:originalPath]) {
            BOOL success = [[NSFileManager defaultManager] removeItemAtPath:originalPath error:&removeError];
            if (!success) {
                NSLog(@"删除临时wav文件失败:%@",removeError);
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [MBProgressHUD showSuccessMessage:@"提取成功"];
                });
                NSLog(@"删除临时wav文件:%@成功",originalPath);
                completed(nil);
            }
        }
    }
}

///输出路径
- (NSString *)exporterPath:(NSString *)filename{
    
    NSString *fileName = [NSString stringWithFormat:@"output.%@",filename];
    
    NSString *documentsDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    
    NSString *outputFilePath =[documentsDirectory stringByAppendingPathComponent:fileName];
    
    if([[NSFileManager defaultManager]fileExistsAtPath:outputFilePath]){
        
        [[NSFileManager defaultManager]removeItemAtPath:outputFilePath error:nil];
    }
    
    return outputFilePath;
}




// 成功保存图片到相册中, 必须调用此方法, 否则会报参数越界错误
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        [MBProgressHUD showErrorMessage:@"保存失败"];
    }else {
        [MBProgressHUD showSuccessMessage:@"保存成功"];
    }
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




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
