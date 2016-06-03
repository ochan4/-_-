//
//  BarView.m
//  笑话大全_设置页面
//
//  Created by AierChen on 1/6/16.
//  Copyright © 2016年 Canterbury Tale Inc. All rights reserved.
//

#import "BarView.h"

@implementation BarView

-(void)awakeFromNib{
    
    self.likedImageButton.selected = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(firstButtonNoti:) name:@"ScrollView第一页面监听" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(secondButtonNoti:) name:@"ScrollView第二页面监听" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(thirdButtonNoti:) name:@"ScrollView第三页面监听" object:nil];
}

-(void)firstButtonNoti:(NSNotification *)noti{
    [self buttonHighlight:self.likedImageButton];
    [self orangeLinePosition:125/2];
}

-(void)secondButtonNoti:(NSNotification *)noti{
    [self buttonHighlight:self.likedTextButton];
    [self orangeLinePosition:125+125/2];
}

-(void)thirdButtonNoti:(NSNotification *)noti{
    [self buttonHighlight:self.profileButton];
    [self orangeLinePosition:125+125+125/2];
}

//按钮
- (IBAction)likeImageAction:(UIButton *)sender {
    
    [self buttonHighlight:self.likedImageButton];
    
    [self orangeLinePosition:125/2];
    
    //发出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"喜欢的图片监听" object: @"barView1"];
    
}

- (IBAction)likeTextAction:(UIButton *)sender {
    
    [self buttonHighlight:self.likedTextButton];
    
    [self orangeLinePosition:125+125/2];
    
    //发出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"喜欢的笑话监听" object: @"barView2"];
}

- (IBAction)profileAction:(UIButton *)sender {
    
    [self buttonHighlight:self.profileButton];
    
    [self orangeLinePosition:125+125+125/2];
    
    //发出通知
    [[NSNotificationCenter defaultCenter]postNotificationName:@"设置监听" object: @"barView3"];
}

-(void)buttonHighlight:(UIButton *)sender{
    for (UIButton *btn in self.allButtons) {
        if (![sender isEqual:btn]) {
            btn.selected = NO;
        }
    }
    sender.selected = YES;
}

-(void)orangeLinePosition:(float)x{
    //直接做动画
    [UIView animateWithDuration:0.3 animations:^{
        self.orangeLine.center = CGPointMake(x, self.orangeLine.center.y);
    }];
}

@end
