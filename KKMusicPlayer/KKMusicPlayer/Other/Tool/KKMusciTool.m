//
//  KKMusciTool.m
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/21.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import "KKMusciTool.h"
#import "KKMusic.h"
#import "MJExtension.h"
static NSArray *_musics;
@implementation KKMusciTool

+(NSArray *)musics{
    
    if (!_musics) {
        _musics = [KKMusic objectArrayWithFilename:@"Musics.plist"];
    }
    return _musics;
}


@end
