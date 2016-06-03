//
//  SettingsViewController.m
//  笑话大全_设置页面
//
//  Created by AierChen on 1/6/16.
//  Copyright © 2016年 Canterbury Tale Inc. All rights reserved.
//

#import "SettingsViewController.h"
#import "BarView.h"
#import "LikedImageUIView.h"
#import "LikedTextUIView.h"
#import "ProfileUIView.h"
#import "UIView+Extend.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height
#define SubScrollViewHeight 500

@interface SettingsViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong)UIScrollView *largeScrollView;
@property (nonatomic, strong)UIView *largeUIView;
@property (nonatomic, strong)UIScrollView *smallScrollView;
@property (nonatomic, strong)UIView *smallUIView;

@property (nonatomic, strong)UIView *fakeNavigationBar;
@property (nonatomic, strong)UIImageView *imageView;
@property (nonatomic, strong)UITextView *nameTextView;
@property (nonatomic, strong)UILabel *descriptionLabel;
@property (nonatomic, strong)BarView *barView;
@property (nonatomic, strong)LikedImageUIView *likedImageUIView;
@property (nonatomic, strong)LikedTextUIView *likedTextUIView;
@property (nonatomic, strong)ProfileUIView *profileUIView;

@property (nonatomic)CGRect *oldFrame;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //************************************************//
    //创建右上角按钮
    UIBarButtonItem *editItem = [[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStyleDone target:self action:@selector(editAction:)];
    self.navigationItem.rightBarButtonItem = editItem;
    //************************************************//
    
    //监听BarView里的按钮
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(likeImageNoti:) name:@"喜欢的图片监听" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(likeTextNoti:) name:@"喜欢的笑话监听" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(profileNoti:) name:@"设置监听" object:nil];
    
    //隐藏头栏
    UIView *controllerBar1 = self.navigationController.navigationBar.subviews[1];
    controllerBar1.hidden = YES;

    
    //创建大ScrollView
    self.largeScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 30, ScreenWidth, ScreenHeight)];
    self.largeScrollView.userInteractionEnabled = YES;
    self.largeScrollView.delegate = self;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    [self.largeScrollView addGestureRecognizer:pan];
    [self.view addSubview: self.largeScrollView];
    
    //创建大UIView
    self.largeUIView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.largeUIView.userInteractionEnabled = YES;
    [self.largeScrollView addSubview:self.largeUIView];
    
    //Name TextView
    self.nameTextView = [[UITextView alloc]initWithFrame:CGRectMake(100, 70, 170, 50)];
    self.nameTextView.text = @"陈爱儿";
    self.nameTextView.textAlignment = NSTextAlignmentCenter;
    self.nameTextView.font = [UIFont systemFontOfSize:17];
    self.nameTextView.tintColor = [UIColor blackColor];
    self.nameTextView.editable = NO;
    [self.largeUIView addSubview:self.nameTextView];
    
    //Description Label
    self.descriptionLabel = [[UILabel alloc]initWithFrame:CGRectMake(123, 104, 129, 12)];
    self.descriptionLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:10];
    self.descriptionLabel.text = @"写了21817字,获得231个喜欢";
    self.descriptionLabel.tintColor = [UIColor grayColor];
    [self.largeUIView addSubview:self.descriptionLabel];
    
    //注册HeaderView UIView
    self.barView = [[[NSBundle mainBundle]loadNibNamed:@"BarView" owner:self options:nil]lastObject];
    self.barView.frame = CGRectMake(0, 130, 375, 40);
    [self.largeUIView addSubview:self.barView];
    
    //创建SmallScrollView
    self.smallScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 170, ScreenWidth, 700)];
    self.smallScrollView.delegate = self;
    self.smallScrollView.pagingEnabled = YES;
    self.smallScrollView.bounces = NO;
    self.smallScrollView.alwaysBounceVertical = YES;
    self.smallScrollView.directionalLockEnabled = YES;
    self.smallScrollView.backgroundColor = [UIColor grayColor];
    [self.largeUIView addSubview: self.smallScrollView];
    
    //在小的scrollerview里面添加2个tableview和一个view
    self.smallScrollView.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight);

    //UIView:图片
    self.likedImageUIView = [[[NSBundle mainBundle]loadNibNamed:@"LikedImageUIView" owner:self options:nil]lastObject];
    self.likedImageUIView.frame = CGRectMake(0, 0, ScreenWidth, self.likedImageUIView.size.height);
    [self.smallScrollView addSubview:self.likedImageUIView];
    
    //UIView:笑话
    self.likedTextUIView = [[[NSBundle mainBundle]loadNibNamed:@"LikedTextUIView" owner:self options:nil]lastObject];
    self.likedTextUIView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.likedTextUIView.size.height);
    [self.smallScrollView addSubview:self.likedTextUIView];
    
    //UIView:设置
    self.profileUIView = [[[NSBundle mainBundle]loadNibNamed:@"ProfileUIView" owner:self options:nil]lastObject];
    self.profileUIView.frame = CGRectMake(ScreenWidth*2, 0, ScreenWidth, self.profileUIView.size.height);
    [self.smallScrollView addSubview:self.profileUIView];
    
    //white top bar
    self.fakeNavigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 65)];
    self.fakeNavigationBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.fakeNavigationBar];
    [self.view bringSubviewToFront:self.fakeNavigationBar];
    
    //Profile Photo
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(157, 35, 60, 60)];
    self.imageView.image = [UIImage imageNamed:@"me.png"];
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 30;
    [self.view addSubview:self.imageView];
    [self.view bringSubviewToFront:self.imageView];
    

}


#pragma mark - 右上角方法
-(void)editAction:(UIBarButtonItem *)item{
    
    //编辑中页面：
    if ([item.title isEqualToString:@"编辑"]) {
        
        self.imageView.userInteractionEnabled =
        self.nameTextView.editable = YES;
        
        item.title = @"保存";//按钮标题
        self.title = @"编辑状态";//头页面标题
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];//头页面的标题颜色

    //正常页面：
    }else{
        item.title = @"编辑";
        self.title = @"";
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
        
        //设置 头像+名字+介绍 可编辑
        self.imageView.userInteractionEnabled =
        self.nameTextView.editable = NO;
    }
}

#pragma mark - 监听按钮方法

-(void)likeImageNoti:(NSNotification *)noti{
    
    NSString *string = noti.object;
    
    [self smallScrollViewMoveLeftRight:0];
    [self largeScrollViewMoveUp];
    [self imageMoveUp];
}

-(void)likeTextNoti:(NSNotification *)noti{
    
    NSString *string = noti.object;

    [self smallScrollViewMoveLeftRight:ScreenWidth];
    [self largeScrollViewMoveUp];
    [self imageMoveUp];
}

-(void)profileNoti:(NSNotification *)noti{
    
    NSString *string = noti.object;
    
    [self smallScrollViewMoveLeftRight:ScreenWidth*2];
    [self largeScrollViewMoveUp];
    [self imageMoveUp];
}

#pragma mark - 控件移位

-(void)imageMoveUp{
    [UIView animateWithDuration:0.5 animations:^{
    
        CGRect frame;
        frame.size.height = 36.57;
        frame.size.width = 35.5;
        self.imageView.frame = frame;
        self.imageView.layer.cornerRadius = self.imageView.width;
        self.imageView.center = CGPointMake(self.view.center.x, 40);
    }];
}

-(void)imageMoveDown{
    [UIView animateWithDuration:0.5 animations:^{
        self.imageView.frame = CGRectMake(157, 35, 60, 60);
        self.imageView.layer.masksToBounds = YES;
        self.imageView.layer.cornerRadius = 30;
    
    }];
}

-(void)largeScrollViewMoveUp{
    [UIView animateWithDuration:0.5 animations:^{
        self.largeScrollView.contentOffset = CGPointMake(0, 95);
    }];
}

-(void)largeScrollViewMoveDown{
    [UIView animateWithDuration:0.2 animations:^{
        self.largeScrollView.contentOffset = CGPointMake(0, 5);
    }];
}

-(void)smallScrollViewMoveLeftRight:(float)x{
    [UIView animateWithDuration:0.5 animations:^{
        self.smallScrollView.contentOffset = CGPointMake(x, 0);
    }];
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //左右滑动小的scrollerview让文字颜色改变和小滑块滑动
    if (scrollView == self.smallScrollView) {
        CGFloat i = self.smallScrollView.contentOffset.x / ScreenWidth;
        if (i == 0) {
            //发出通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ScrollView第一页面监听" object: @"SV1"];
            [self largeScrollViewMoveUp];
            [self imageMoveUp];
            
        }else if ( i == 1){
            //发出通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ScrollView第二页面监听" object: @"SV2"];
            [self largeScrollViewMoveUp];
            [self imageMoveUp];
            
        }else if (i == 2){
            //发出通知
            [[NSNotificationCenter defaultCenter]postNotificationName:@"ScrollView第三页面监听" object: @"SV3"];
            [self largeScrollViewMoveUp];
            [self imageMoveUp];
            
        }
        return;
    }
    
    //大滚动页面
    if (scrollView == self.largeScrollView) {
        
        CGFloat contentY = self.largeScrollView.contentOffset.y / 3;
        
        if (contentY <= 25 && contentY >= 0) {
            
            //改变头像的大小
            NSLog(@"改变了大滚页面");
        }
        
        if (contentY >= 53) {
            
            //让scrollerview停留之
             NSLog(@"改变了大滚页面2");
            
        }
    }
}

-(void)panAction:(UIPanGestureRecognizer*)pan{
    UIView *image = pan.view;
    //locationInView: 在主页面的位置
    CGPoint p = [pan locationInView:self.view];
    
    switch ((int)pan.state) {
        case UIGestureRecognizerStateBegan:
            
            break;
            
        case UIGestureRecognizerStateChanged:
            [self largeScrollViewMoveDown];
            [self imageMoveDown];
            break;
            
        case UIGestureRecognizerStateEnded:
            break;
            
        case UIGestureRecognizerStateCancelled:
            break;
            
    }
}

#pragma mark - 其他

-(void)dealloc{
    //移除监听 不然可能会蹦
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
