//
//  KKPlayingMusicViewController.m
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/21.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import "KKPlayingMusicViewController.h"
#import "UIView+Extension.h"
#import "KKMusciTool.h"
#import "KKMusic.h"
#import "KKAudioTool.h"

#define duration 0.25
@interface KKPlayingMusicViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *songNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *singerNameLabel;
- (IBAction)exit:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *lyrcBtn;
- (IBAction)lyrcBtnClick:(UIButton *)sender;
- (IBAction)play:(UIButton *)sender;
- (IBAction)previous:(UIButton *)sender;
- (IBAction)next:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) KKMusic *playingMusic;
@end

@implementation KKPlayingMusicViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
}

-(KKMusic *)playingMusic{
    
    if(_playingMusic == nil){
        
        self.playingMusic = [[KKMusic alloc]init];
    }
    
    return _playingMusic;
}
#pragma mark - public methods
-(void)show{
    // 0.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    
    // 1.添加播放界面
    [window addSubview:self.view];
    self.view.frame = window.bounds;
    self.view.y = self.view.height;
    self.view.hidden = NO;
    
    //2.判断是否切换了歌曲
    if(self.playingMusic != [KKMusciTool playingMusci]){
        [self resetPlayingMusic];
    }
    
    // 3.动画显示
    [UIView animateWithDuration:duration animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        // 开始播放音乐
        [self startPlayingMusic];
    }];
}

#pragma mark - private methods
-(void)resetPlayingMusic{
    
    //设置基本属性
    self.imageView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.singerNameLabel.text = nil;
    self.songNameLabel.text = nil;
    
    [KKAudioTool stopMusic:self.playingMusic.filename];
}
-(void)startPlayingMusic{
    
    if(self.playingMusic == [KKMusciTool playingMusci])return;
    self.playingMusic = [KKMusciTool playingMusci];
    //设置基本属性
    self.imageView.image = [UIImage imageNamed:self.playingMusic.icon];
    self.singerNameLabel.text = self.playingMusic.singer;
    self.songNameLabel.text = self.playingMusic.name;
    
    //play
    [KKAudioTool playMusic:self.playingMusic.filename];
    
}
- (IBAction)exit:(UIButton *)sender {

    // 0.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    
    //动画
    [UIView animateWithDuration:duration animations:^{
        self.view.y = self.view.height;
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
        window.userInteractionEnabled = YES;
    }];
}
- (IBAction)lyrcBtnClick:(UIButton *)sender {
}

- (IBAction)play:(UIButton *)sender {
}

- (IBAction)previous:(UIButton *)sender {
}

- (IBAction)next:(UIButton *)sender {
}
@end
