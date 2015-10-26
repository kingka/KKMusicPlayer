//
//  KKLrcView.m
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/26.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import "KKLrcView.h"

@interface KKLrcView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;

@end

@implementation KKLrcView

#pragma mark - init
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super initWithCoder:decoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    UITableView *tableView = [[UITableView alloc]init];
    [self addSubview:tableView];
    
    self.tableView = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"lrcCell"];
}

-(void)layoutSubviews{
    self.tableView.frame = self.bounds;
}
#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lrcCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    return cell;
}
#pragma mark -UITableViewDelegate
@end
