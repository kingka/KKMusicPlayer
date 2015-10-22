//
//  KKAudioTool.h
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/22.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface KKAudioTool : NSObject

+ (AVAudioPlayer *)playMusic:(NSString *)fileName;

+ (void)pauseMusic :(NSString *)fileName;

+ (void)stopMusic :(NSString *)fileName;

+ (void)playSound :(NSString *)fileName;

+ (void)disposeSound :(NSString *)fileName;
@end
