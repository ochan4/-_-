//
//  BarView.h
//  笑话大全_设置页面
//
//  Created by AierChen on 1/6/16.
//  Copyright © 2016年 Canterbury Tale Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarView : UIView
@property (weak, nonatomic) IBOutlet UIButton *likedImageButton;
@property (weak, nonatomic) IBOutlet UIButton *likedTextButton;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allButtons;
@property (weak, nonatomic) IBOutlet UIView *orangeLine;

@end
