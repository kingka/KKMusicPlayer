//
//  KKHomeViewCell.h
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/21.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import <UIKit/UIKit.h>
@class KKMusic;
@interface KKHomeViewCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView*)tableView;
@property (strong, nonatomic) KKMusic *music;
@end
