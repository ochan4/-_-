//
//  ViewController.m
//  笑话大全_设置页面
//
//  Created by AierChen on 1/6/16.
//  Copyright © 2016年 Canterbury Tale Inc. All rights reserved.
//

#import "ViewController.h"
#import "SettingsViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)SettingsButton:(UIButton *)sender {
    SettingsViewController *vc = [[SettingsViewController alloc]init];
    [self presentViewController:vc animated:YES completion:nil];
}


@end
