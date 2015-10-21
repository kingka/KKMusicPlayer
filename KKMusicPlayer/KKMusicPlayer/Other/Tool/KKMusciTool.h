//
//  KKMusciTool.h
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/21.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import <Foundation/Foundation.h>
@class KKMusic;
@interface KKMusciTool : NSObject

+(NSArray*)musics;

+(KKMusic*)playingMusci;

+(KKMusic*)nextMusic;

+(KKMusic*)previousMusic;

+(void)setPlayingMusic:(KKMusic*)music;
@end
