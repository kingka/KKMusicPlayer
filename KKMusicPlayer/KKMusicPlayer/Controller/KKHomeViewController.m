//
//  KKHomeViewController.m
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/21.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import "KKHomeViewController.h"
#import "KKHomeViewCell.h"
#import "KKMusciTool.h"
#import "KKPlayingMusicViewController.h"

@interface KKHomeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) KKPlayingMusicViewController *playVc;
@end

@implementation KKHomeViewController

-(KKPlayingMusicViewController *)playVc{
    
    if(_playVc == nil){
        
        self.playVc = [[KKPlayingMusicViewController alloc]init];
    }
    return _playVc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [KKMusciTool musics].count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    KKHomeViewCell *cell = [KKHomeViewCell cellWithTableView:tableView];
    cell.music = [KKMusciTool musics][indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置playingMusci
    [KKMusciTool setPlayingMusic:[KKMusciTool musics][indexPath.row]];
    
    [self.playVc show];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 70;
}

@end
