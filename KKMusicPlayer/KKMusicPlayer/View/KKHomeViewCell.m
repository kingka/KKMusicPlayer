//
//  KKHomeViewCell.m
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/21.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import "KKHomeViewCell.h"
#import "KKMusic.h"

@implementation KKHomeViewCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
    
    static NSString *identifier = @"KKHomeViewCell";
    KKHomeViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if(cell == nil){
        cell = [[KKHomeViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    
    return cell;
}

-(void)setMusic:(KKMusic *)music{
    
    _music = music;
    self.textLabel.text = music.name;
    self.detailTextLabel.text = music.singer;
}

@end
