//
//  KKPlayingMusicViewController.m
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/21.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import "KKPlayingMusicViewController.h"
#import "UIView+Extension.h"

@interface KKPlayingMusicViewController ()

@end

@implementation KKPlayingMusicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - public methods
-(void)show{
    
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    [window addSubview:self.view];
    
    window.userInteractionEnabled = NO;
    
    self.view.frame = window.bounds;
    
    self.view.y = self.view.height;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.view.y = 0;
    } completion:^(BOOL finished) {
        window.userInteractionEnabled = YES;
    }];
}


@end
