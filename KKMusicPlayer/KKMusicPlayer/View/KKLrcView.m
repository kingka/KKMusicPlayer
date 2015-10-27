//
//  KKLrcView.m
//  KKMusicPlayer
//
//  Created by Imanol on 15/10/26.
//  Copyright (c) 2015年 Imanol. All rights reserved.
//

#import "KKLrcView.h"
#import "KKLrcLine.h"
#import "UIView+Extension.h"
@interface KKLrcView() <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *lrcArray;
@property (assign, nonatomic) NSInteger currentIndex;
@end

@implementation KKLrcView

#pragma mark - lazyloading
-(NSMutableArray *)lrcArray{
    
    if(_lrcArray == nil){
        self.lrcArray = [NSMutableArray array];
    }
    return _lrcArray;
}
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
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
    self.tableView.contentInset = UIEdgeInsetsMake(self.height * 0.5, 0, self.height * 0.5, 0);
}

#pragma mark - publicMethod
-(void)setCurrentTime:(NSTimeInterval)currentTime{
    _currentTime = currentTime;
    int minute = currentTime / 60;
    int second = (int)currentTime % 60;
    int msecond = (currentTime - (int)currentTime) * 100;
    NSString *timeStr = [NSString stringWithFormat:@"%02d:%02d.%02d",minute,second,msecond];
    [self.lrcArray enumerateObjectsUsingBlock:^(KKLrcLine *lrcLine, NSUInteger idx, BOOL *stop) {
        
        NSString *tTime = lrcLine.time;
        NSString *nextTime = nil;
        NSUInteger nextIndex = idx + 1;
        
        if(nextIndex < self.lrcArray.count){
            KKLrcLine *nextLine = self.lrcArray[nextIndex];
            nextTime = nextLine.time;
            
            //需要的条件为：当前时间要大于或等于当前循环到的 time,并且下一个time 要大于当前时间，这中间的，就是我们要的歌词，添加 currentIdx是为了防止tableView滚动的次数太多
            if(
                [timeStr compare:tTime]!= NSOrderedAscending
               &&[timeStr compare:nextTime] == NSOrderedAscending
               && self.currentIndex != idx){
                
                self.currentIndex = idx;
                NSIndexPath *path = [NSIndexPath indexPathForRow:idx inSection:0];
                [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
                *stop = YES;
            }
        }
    }];
}

-(void)setLrcName:(NSString *)lrcName{
    
    _lrcName = [lrcName copy];
    // 0.清空之前的歌词数据
    [self.lrcArray removeAllObjects];
    
    // 1.加载歌词文件
    NSURL *url = [[NSBundle mainBundle]URLForResource:lrcName withExtension:nil];
    NSString *lrc = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    //得到每一条包含歌词和时间的 str
    NSArray *lrcCmps = [lrc componentsSeparatedByString:@"\n"];
    //截取歌词和时间
    for(NSString *lrcCmp in lrcCmps){
        KKLrcLine *lrcLine = [[KKLrcLine alloc]init];
        [self.lrcArray addObject:lrcLine];
        if (![lrcCmp hasPrefix:@"["]) continue;
        // 如果是歌词的头部信息（歌名、歌手、专辑）
        if ([lrcCmp hasPrefix:@"[ti:"] || [lrcCmp hasPrefix:@"[ar:"] || [lrcCmp hasPrefix:@"[al:"] ) {
            NSString *word = [[lrcCmp componentsSeparatedByString:@":"] lastObject];
            lrcLine.word = [word substringToIndex:word.length - 1];
        }else{// 非头部信息
            NSArray *array = [lrcCmp componentsSeparatedByString:@"]"];
            lrcLine.time = [[array firstObject] substringFromIndex:1];
            lrcLine.word = [array lastObject];
        }
    }
    [self.tableView reloadData];
}
#pragma mark -UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.lrcArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lrcCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor whiteColor];
    [cell.textLabel setTextAlignment:NSTextAlignmentCenter];
    KKLrcLine *line = self.lrcArray[indexPath.row];
    cell.textLabel.text = line.word;
    
    return cell;
}
#pragma mark -UITableViewDelegate
@end
