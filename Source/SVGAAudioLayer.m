//
//  SVGAAudioLayer.m
//  SVGAPlayer
//
//  Created by PonyCui on 2018/10/18.
//  Copyright © 2018年 UED Center. All rights reserved.
//

#import "SVGAAudioLayer.h"
#import "SVGAAudioEntity.h"
#import "SVGAVideoEntity.h"
#import "ZegoExpressEngine/ZegoExpressEngine.h"

@interface SVGAAudioLayer ()

@property (nonatomic, readwrite) AVAudioPlayer *audioPlayer;
@property (nonatomic, readwrite) SVGAAudioEntity *audioItem;
@property (nonatomic, strong) ZegoAudioEffectPlayer *audioEffectPlayer;

@end

@implementation SVGAAudioLayer

- (instancetype)initWithAudioItem:(SVGAAudioEntity *)audioItem videoItem:(SVGAVideoEntity *)videoItem
{
    self = [super init];
    if (self) {
        _audioItem = audioItem;
        
//        if (audioItem.audioKey != nil && videoItem.audiosData[audioItem.audioKey] != nil) {
//            
//            _audioPlayer = [[AVAudioPlayer alloc] initWithData:videoItem.audiosData[audioItem.audioKey]
//                                                  fileTypeHint:@"mp3"
//                                                         error:NULL];
//            
//            [_audioPlayer prepareToPlay];
//        }
        
        if (audioItem.audioKey != nil && videoItem.audiosPath[audioItem.audioKey] != nil) {
            [self setupZegoSDK];
//            self.audioEffectPlayer = [[ZegoExpressEngine sharedEngine] createAudioEffectPlayer];
            if (!self.audioEffectPlayer) {
                NSLog(@"创建音效播放器失败");
            }
            
            NSString *path = videoItem.audiosPath[audioItem.audioKey];
            
            [self.audioEffectPlayer loadResource:path audioEffectID:0 callback:^(int errorCode) {
                NSLog(@"loadResource result, errorCode: %d", errorCode);
            }];
        }
        
        
    }
    return self;
}

- (ZegoAudioEffectPlayer *)audioEffectPlayer {
    if (!_audioEffectPlayer) {
        _audioEffectPlayer = [[ZegoExpressEngine sharedEngine] createAudioEffectPlayer];
    }
    return _audioEffectPlayer;
}

- (void)setupZegoSDK {
    ZegoEngineProfile *profile = [[ZegoEngineProfile alloc] init];
    profile.appID = 250562886;
    profile.appSign = @"de901de5f3490ba4966be9f6d445a2e44b92f53c746412cdcd42e3b283e46204";
    profile.scenario = ZegoScenarioBroadcast;
    ZegoExpressEngine *zegoEngine = [ZegoExpressEngine createEngineWithProfile:profile eventHandler:self];
    
}



#pragma mark - 缓存 MP3

- (NSString *)cacheMP3Data:(NSData *)data
                  fileName:(NSString *)fileName {
    
    // Cache 目录
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(
                                                              NSCachesDirectory,
                                                              NSUserDomainMask,
                                                              YES
                                                              ).firstObject;
    
    // 创建 mp3 文件路径
    NSString *filePath = [cachePath
                          stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@.mp3", fileName]];
    
    // 写入文件
    BOOL success = [data writeToFile:filePath atomically:YES];
    
    if (success) {
        NSLog(@"MP3 缓存成功：%@", filePath);
        return filePath;
    }
    
    NSLog(@"MP3 缓存失败");
    return nil;
}

#pragma mark - 判断缓存是否存在

- (BOOL)isMP3Cached:(NSString *)fileName {
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(
                                                              NSCachesDirectory,
                                                              NSUserDomainMask,
                                                              YES
                                                              ).firstObject;
    
    NSString *filePath = [cachePath
                          stringByAppendingPathComponent:
                              [NSString stringWithFormat:@"%@.mp3", fileName]];
    
    return [[NSFileManager defaultManager] fileExistsAtPath:filePath];
}

#pragma mark - 获取缓存路径

- (NSString *)getCachedMP3Path:(NSString *)fileName {
    
    NSString *cachePath = NSSearchPathForDirectoriesInDomains(
                                                              NSCachesDirectory,
                                                              NSUserDomainMask,
                                                              YES
                                                              ).firstObject;
    
    return [cachePath
            stringByAppendingPathComponent:
                [NSString stringWithFormat:@"%@.mp3", fileName]];
}

#pragma mark - 播放

//- (void)playMP3:(NSString *)filePath {
//    
//    ZegoAudioEffectPlayer *player =
//    [[ZegoExpressEngine sharedEngine] createAudioEffectPlayer];
//    
//    ZegoAudioEffectPlayConfig *config =
//    [[ZegoAudioEffectPlayConfig alloc] init];
//    
//    // YES：房间内其他用户也能听到
//    // NO：只有自己本地听到
//    config.publishOut = YES;
//    
//    NSInteger effectID = 1;
//    
//    [player start:effectID
//         filePath:filePath
//           config:config];
//}



@end
