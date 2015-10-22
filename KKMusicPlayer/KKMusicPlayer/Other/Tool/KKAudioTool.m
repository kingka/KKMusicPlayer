//
//  KKAudioTool.m
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/22.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import "KKAudioTool.h"

/// 存放所有的音效ID
static NSMutableDictionary *_soundIDS;
///存放所有的音乐播放器
static NSMutableDictionary *_musicPlayers;

@implementation KKAudioTool

+(void)initialize{
    
    //音频会话
    AVAudioSession *session = [AVAudioSession sharedInstance];
    
    //设置会话类型（播放类型，播放模式，会自动停止其他音乐的播放）
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    //激活会话
    [session setActive:YES error:nil];
}

+ (NSMutableDictionary *)soundIDS{
    
    if(_soundIDS == nil){
        
        _soundIDS = [NSMutableDictionary dictionary];
    }
    
    return _soundIDS;
}

+ (NSMutableDictionary *)musicPlayers
{
    if (!_musicPlayers) {
        _musicPlayers = [NSMutableDictionary dictionary];
    }
    return _musicPlayers;
}

+(AVAudioPlayer *)playMusic:(NSString *)fileName{
    
    if(fileName == nil) return nil;
    
    //取出对应的播放器
    AVAudioPlayer *player = [self musicPlayers][fileName];
    //播放器没有创建就进行初始化
    if(player == nil){
        
        NSURL *url = [[NSBundle mainBundle]URLForResource:fileName withExtension:nil];
        if(!url){
            
            return nil;
        }
        player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
        
        //缓冲
        if(![player prepareToPlay])return nil;
        
        //把player 存起来
        [self musicPlayers][fileName] = player;
    }
    
    //播放
    if(!player.isPlaying){
    
        [player play];
    }
    
    //正在播放
    return player;
}

+(void)stopMusic:(NSString *)fileName{
    
    if(fileName == nil) return ;
    //取出对应的播放器
    AVAudioPlayer *player = [self musicPlayers][fileName];
    //stop
    [player stop];
    //remove
    [[self musicPlayers]removeObjectForKey:fileName];
    
}


+(void)pauseMusic:(NSString *)fileName{
    
    if(fileName == nil) return ;
    //取出对应的播放器
    AVAudioPlayer *player = [self musicPlayers][fileName];
    if(player.isPlaying){
        [player pause];
    }
}

/**
 *  播放音效
 *
 *  @param filename 音效的文件名
 */
+ (void)playSound:(NSString *)filename
{
    if (!filename) return;
    
    // 1.取出对应的音效ID
    SystemSoundID soundID = [[self soundIDS][filename] unsignedLongValue];
    
    // 2.初始化
    if (!soundID) {
        // 音频文件的URL
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
        if (!url) return;
        
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        
        // 存入字典
        [self soundIDS][filename] = @(soundID);
    }
    
    // 3.播放
    AudioServicesPlaySystemSound(soundID);
}

/**
 *  销毁音效
 *
 *  @param filename 音效的文件名
 */
+ (void)disposeSound:(NSString *)filename
{
    if (!filename) return;
    
    // 1.取出对应的音效ID
    SystemSoundID soundID = [[self soundIDS][filename] unsignedLongValue];
    
    // 2.销毁
    if (soundID) {
        AudioServicesDisposeSystemSoundID(soundID);
        
        [[self soundIDS] removeObjectForKey:filename];
    }
}

@end
