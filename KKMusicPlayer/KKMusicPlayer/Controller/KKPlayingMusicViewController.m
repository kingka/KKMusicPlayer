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
#import <AVFoundation/AVFoundation.h>
#import "KKLrcView.h"
#import <MediaPlayer/MediaPlayer.h>

#define durations 0.25
@interface KKPlayingMusicViewController ()<AVAudioPlayerDelegate>
@property (weak, nonatomic) IBOutlet KKLrcView *lrcView;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;
@property (weak, nonatomic) IBOutlet UIView *progerssView;
@property (weak, nonatomic) IBOutlet UIButton *indicator;
- (IBAction)tapProgressView:(UITapGestureRecognizer *)sender;
- (IBAction)panSlider:(UIPanGestureRecognizer *)sender;
@property (weak, nonatomic) IBOutlet UIButton *slider;
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
@property (strong, nonatomic) AVAudioPlayer *player;
///进度条定时器
@property (strong, nonatomic) NSTimer *currentTimeTimer;
///歌词定时器
@property (strong, nonatomic) CADisplayLink *lrcTimer;
@end

@implementation KKPlayingMusicViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.indicator.layer.cornerRadius = 7;
}

-(AVAudioPlayer *)player{
    
    if(_player == nil){
        
        self.player = [[AVAudioPlayer alloc]init];
    }
    
    return _player;
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
    [UIView animateWithDuration:durations animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
        // 开始播放音乐
        [self startPlayingMusic];
    }];
}
#pragma mark - Timer
-(void)addLrcTimer{
    //只有在歌曲播放的时候并且歌词显示，才添加
    if(self.player.isPlaying == NO || self.lrcView.hidden)return;
    
    //先清除上一个定时器
    [self removeLrcTimer];
    
    //保证定时器没有延迟1秒更新
    [self updateLrc];
    
    self.lrcTimer = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateLrc)];
    [self.lrcTimer addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    
}

-(void)removeLrcTimer{
    
    [self.lrcTimer invalidate];
    self.lrcTimer = nil;
}

-(void)updateLrc{

    self.lrcView.currentTime = self.player.currentTime;
}
-(void)addCurrentTimeTimer{
    //只有在歌曲播放的时候，才添加
    if(self.player.isPlaying == NO)return;

    //先清除上一个定时器
    [self removeCurrentTimeTimer];
    
    //保证定时器没有延迟1秒更新
    [self updateCurrentTime];
    
    self.currentTimeTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateCurrentTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.currentTimeTimer forMode:NSRunLoopCommonModes];
}

-(void)removeCurrentTimeTimer{
    
    [self.currentTimeTimer invalidate];
    self.currentTimeTimer = nil;
}
-(void)updateCurrentTime{
    
    //计算进度
    double progress = self.player.currentTime / self.player.duration;
    //滑块能滑动的最大值
    CGFloat progressMaxX = self.view.width - self.slider.width;
    
    self.slider.x = progressMaxX * progress;
    self.progerssView.width = self.slider.centerX;
    
    NSString *currentTime = [self strWithTime:self.player.currentTime];
    [self.slider setTitle:currentTime forState:UIControlStateNormal];
    
}
#pragma mark - private methods
-(NSString*)strWithTime:(NSTimeInterval)time{
    
    NSInteger minute = time / 60;
    NSInteger second = (NSInteger)time % 60;
    return [NSString stringWithFormat:@"%ld:%ld", (long)minute, (long)second];
}
-(void)resetPlayingMusic{
    
    self.playBtn.selected = NO;
    //设置基本属性
    self.imageView.image = [UIImage imageNamed:@"play_cover_pic_bg"];
    self.singerNameLabel.text = nil;
    self.songNameLabel.text = nil;
    
    //停止播放歌曲
    [KKAudioTool stopMusic:self.playingMusic.filename];
    self.player = nil;
    //移除定时器
    [self removeCurrentTimeTimer];
    [self removeLrcTimer];
    
}
-(void)startPlayingMusic{
    
    if(self.playingMusic == [KKMusciTool playingMusci]){
        
        [self addCurrentTimeTimer];
        [self addLrcTimer];
        return;
    }
    self.playingMusic = [KKMusciTool playingMusci];
    //设置基本属性
    self.imageView.image = [UIImage imageNamed:self.playingMusic.icon];
    self.singerNameLabel.text = self.playingMusic.singer;
    self.songNameLabel.text = self.playingMusic.name;
    
    //play
    self.player = [KKAudioTool playMusic:self.playingMusic.filename];
    self.player.delegate = self;
    //设置时长
    self.timeLabel.text = [self strWithTime:self.player.duration];
    //加速
//    self.player.enableRate = YES;
//    self.player.rate = 5.0;
    
    //添加定时器
    [self addCurrentTimeTimer];
    [self addLrcTimer];
    //设置播放按钮状态
    self.playBtn.selected = YES;
    //切换歌词（加载新的歌词）
    self.lrcView.lrcName = self.playingMusic.lrcname;
    //切换锁屏界面的歌曲
    [self updateLockedScreenMusic];
    
}

-(void)updateLockedScreenMusic{
    //1播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    //2初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = self.playingMusic.name;
    // 歌手
    info[MPMediaItemPropertyArtist] = self.playingMusic.singer;
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = self.playingMusic.name;
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:self.playingMusic.icon]];
    // 设置持续时间（歌曲的总时间）
    info[MPMediaItemPropertyPlaybackDuration] = @(self.player.duration);
    // 设置当前播放进度
    info[MPNowPlayingInfoPropertyElapsedPlaybackTime] = @(self.player.currentTime);
    
    // 3.切换播放信息
    center.nowPlayingInfo = info;
    // 4.开始监听远程控制事件
    // 4.1.成为第一响应者（必备条件）
    [self becomeFirstResponder];
    // 4.2.开始监控
    //[[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
#warning in ios7 or later
    MPRemoteCommandCenter *rcenter = [MPRemoteCommandCenter sharedCommandCenter];
//    MPRemoteCommand *next = [[MPRemoteCommand alloc]init];
//    [next addTarget:self action:@selector(next:)];
//    rcenter.nextTrackCommand = next;
    [rcenter.previousTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [self previous:nil];
        return MPRemoteCommandHandlerStatusSuccess;
        }
    ];
    
    [rcenter.nextTrackCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [self next:nil];
        return MPRemoteCommandHandlerStatusSuccess;
    }
     ];
    
    [rcenter.playCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [self play:nil];
        return MPRemoteCommandHandlerStatusSuccess;
    }
     ];
    
    [rcenter.pauseCommand addTargetWithHandler:^MPRemoteCommandHandlerStatus(MPRemoteCommandEvent *event) {
        [self play:nil];
        return MPRemoteCommandHandlerStatusSuccess;
    }
     ];


}
- (IBAction)exit:(UIButton *)sender {

    //移除定时器
    [self removeCurrentTimeTimer];
    [self removeLrcTimer];
    // 0.禁用整个app的点击事件
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    
    //动画
    [UIView animateWithDuration:durations animations:^{
        self.view.y = self.view.height;
    } completion:^(BOOL finished) {
        self.view.hidden = YES;
        window.userInteractionEnabled = YES;
    }];
}
- (IBAction)lyrcBtnClick:(UIButton *)sender {
    if(self.lrcView.isHidden){//show
        self.lrcView.hidden = NO;
        self.lyrcBtn.selected = YES;
        [self addLrcTimer];
    }else{
        self.lrcView.hidden = YES;
        self.lyrcBtn.selected = NO;
        [self removeLrcTimer];
    }
}

- (IBAction)play:(UIButton *)sender {
    
    if(self.playBtn.isSelected){//当前播放，所以点击之后暂停
        sender.selected = NO;
        [KKAudioTool pauseMusic:self.playingMusic.filename];
        [self removeCurrentTimeTimer];
        [self removeLrcTimer];
    }else{
        sender.selected = YES;
        [KKAudioTool playMusic:self.playingMusic.filename];
        [self addCurrentTimeTimer];
        [self addLrcTimer];
    }
}

- (IBAction)previous:(UIButton *)sender {
    //防止用户点击过快造成缓冲时候出现的一些问题
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    //重置界面数据
    [self resetPlayingMusic];
    //获得下一首歌曲
    [KKMusciTool setPlayingMusic:[KKMusciTool previousMusic]];
    //播放
    [self startPlayingMusic];
    window.userInteractionEnabled = YES;
}

- (IBAction)next:(UIButton *)sender {
    //防止用户点击过快造成缓冲时候出现的一些问题
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    window.userInteractionEnabled = NO;
    //重置界面数据
    [self resetPlayingMusic];
    //获得下一首歌曲
    [KKMusciTool setPlayingMusic:[KKMusciTool nextMusic]];
    //播放
    [self startPlayingMusic];
    window.userInteractionEnabled = YES;
}
- (IBAction)tapProgressView:(UITapGestureRecognizer *)sender {
    
    CGPoint point = [sender locationInView:sender.view];
    NSInteger progressMaxX = self.view.width;
    self.player.currentTime = (point.x / progressMaxX) * self.player.duration;
    
    self.slider.centerX = point.x;
    self.progerssView.width = self.slider.centerX;
}

- (IBAction)panSlider:(UIPanGestureRecognizer *)sender {
    //获得挪动的距离
    CGPoint point = [sender translationInView:sender.view];
    //清零，因为每次挪动都会获得一个值
    [sender setTranslation:CGPointZero inView:sender.view];
    //控制滑块和进度条的frame
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    self.slider.x += point.x;
    if(self.slider.x <0){
        self.slider.x = 0;
    }else if(self.slider.x > sliderMaxX){
        self.slider.x = sliderMaxX;
    }
    
    self.progerssView.width = self.slider.centerX;
    
    //设置时间
    double progerss = self.slider.x / sliderMaxX;
    NSTimeInterval time = self.player.duration * progerss;
    [self.slider setTitle:[self strWithTime:time] forState:UIControlStateNormal];
    
    //判断手势状态
    if(sender.state == UIGestureRecognizerStateBegan){
        //停止定时器
        [self removeCurrentTimeTimer];
        //显示指示器
        self.indicator.hidden = NO;
        //设置Y值
        self.indicator.y = self.indicator.superview.height - 10 - self.indicator.height;
    }else if(sender.state == UIGestureRecognizerStateEnded){
        //设置播放器时间
        self.player.currentTime = time;
        //开启
        [self addCurrentTimeTimer];
        //隐藏指示器
        self.indicator.hidden = YES;
    }
    //设置指示器的X
    self.indicator.centerX = self.slider.centerX;
    //设置指示器时间
    [self.indicator setTitle:[self strWithTime:time] forState:UIControlStateNormal];
    
}
#pragma mark - AVAudioPlayerDelegate
-(void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    
    [self next:nil];
}

-(void)audioPlayerBeginInterruption:(AVAudioPlayer *)player{
    
    if(player.isPlaying){
        [self play:nil];
    }
}
#pragma mark - remote event monitor
- (BOOL)canBecomeFirstResponder
{
    return YES;
}

- (void)remoteControlReceivedWithEvent:(UIEvent *)event
{
    //    event.type; // 事件类型
    //    event.subtype; // 事件的子类型
    //    UIEventSubtypeRemoteControlPlay                 = 100,
    //    UIEventSubtypeRemoteControlPause                = 101,
    //    UIEventSubtypeRemoteControlStop                 = 102,
    //    UIEventSubtypeRemoteControlTogglePlayPause      = 103,
    //    UIEventSubtypeRemoteControlNextTrack            = 104,
    //    UIEventSubtypeRemoteControlPreviousTrack        = 105,
    //    UIEventSubtypeRemoteControlBeginSeekingBackward = 106,
    //    UIEventSubtypeRemoteControlEndSeekingBackward   = 107,
    //    UIEventSubtypeRemoteControlBeginSeekingForward  = 108,
    //    UIEventSubtypeRemoteControlEndSeekingForward    = 109,
    switch (event.subtype) {
        case UIEventSubtypeRemoteControlPlay:
        case UIEventSubtypeRemoteControlPause:
            [self play:nil];
            break;
            
        case UIEventSubtypeRemoteControlNextTrack:
            [self next:nil];
            break;
            
        case UIEventSubtypeRemoteControlPreviousTrack:
            [self previous:nil];
            
        default:
            break;
    }
}

@end
