//
//  TransitionViewController.m
//  MyAnimation
//
//  Created by tuyunfeng on 15/9/10.
//  Copyright (c) 2015年 tcl. All rights reserved.
//

#import "TransitionViewController.h"

#define IMAGE_COUNT 5

@interface TransitionViewController ()
{
    UIImageView *imageView;
    NSInteger currIndex;
}
@end

@implementation TransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self loadSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSubview
{
    imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.image = [UIImage imageNamed:@"0.jpg"];
    
    [self.view addSubview:imageView];
    
    UISwipeGestureRecognizer *leftSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftSwipe:)];
    leftSwipeGesture.direction = UISwipeGestureRecognizerDirectionLeft;
    
    UISwipeGestureRecognizer *rightSwipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightSwipe:)];
    rightSwipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:leftSwipeGesture];
    [self.view addGestureRecognizer:rightSwipeGesture];
}

- (void)leftSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self transitionAnimation:YES];
}

- (void)rightSwipe:(UISwipeGestureRecognizer *)gesture
{
    [self transitionAnimation:NO];
}

/**************
--------公开API--------------
fade 	淡出效果 	kCATransitionFade 	是
movein 	新视图移动到旧视图上 	kCATransitionMoveIn 	是
push 	新视图推出旧视图 	kCATransitionPush 	是
reveal 	移开旧视图显示新视图 	kCATransitionReveal 	是
-----私有API 	  	私有API只能通过字符串访问-----------
cube 	立方体翻转效果 	无 	是
oglFlip 	翻转效果 	无 	是
suckEffect 	收缩效果 	无 	否
rippleEffect 	水滴波纹效果 	无 	否
pageCurl 	向上翻页效果 	无 	是
pageUnCurl 	向下翻页效果 	无 	是
cameralIrisHollowOpen 	摄像头打开效果 	无 	否
cameraIrisHollowClose 	摄像头关闭效果 	无 	否

另外对于支持方向设置的动画类型还包含子类型：
---------动画子类型 	说明--------------
kCATransitionFromRight 	从右侧转场
kCATransitionFromLeft 	从左侧转场
kCATransitionFromTop 	从顶部转场
kCATransitionFromBottom 	从底部转场
***********************/
- (void)transitionAnimation:(BOOL)isNext
{
    CATransition *trasition = [[CATransition alloc] init];
    
    trasition.type = @"cube";
    trasition.duration = 0.8;
    
    if (isNext)
        trasition.subtype = kCATransitionFromRight;
    else
        trasition.subtype = kCATransitionFromLeft;
    
    imageView.image = [self getImage:isNext];
    [imageView.layer addAnimation:trasition forKey:@"trasition"];
}

- (UIImage *)getImage:(BOOL)isNext
{
    if (isNext)
        currIndex = (currIndex + 1) % IMAGE_COUNT;
    else
        currIndex = (currIndex - 1 + IMAGE_COUNT) % IMAGE_COUNT;
    
    NSString *name = [NSString stringWithFormat:@"%zd.jpg", currIndex];
    return [UIImage imageNamed:name];
}
@end
