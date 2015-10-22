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
static KKMusic *_playingMusic;
@implementation KKMusciTool

+(NSArray *)musics{
    
    if (!_musics) {
        _musics = [KKMusic objectArrayWithFilename:@"Musics.plist"];
    }
    return _musics;
}

+(void)setPlayingMusic:(KKMusic *)music{
    
    if(!music || ![_musics containsObject:music]) return;
    
    if(_playingMusic == music) return;
    
    _playingMusic = music;
    
}
+(KKMusic *)playingMusci{
    
    return _playingMusic;
}

+(KKMusic *)nextMusic{
    
    NSInteger nextIndex = 0;
    if(_playingMusic){
    
        NSInteger playingIndex =  [_musics indexOfObject:_playingMusic];
        nextIndex = playingIndex +1;
        if(nextIndex>=_musics.count){
            
            nextIndex = 0;
        }
    }
    return [_musics objectAtIndex:nextIndex];
}

+(KKMusic *)previousMusic{
    
    NSInteger previousIndex = 0;
    if(_playingMusic){
        
        NSInteger playingIndex =  [_musics indexOfObject:_playingMusic];
        previousIndex = playingIndex -1;
        if(previousIndex<0){
            
            previousIndex = _musics.count - 1;
        }
    }
    return [_musics objectAtIndex:previousIndex];;

}

@end
