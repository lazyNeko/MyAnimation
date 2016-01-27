//
//  BasicAnimationViewController.m
//  MyAnimation
//
//  Created by tuyunfeng on 15/9/10.
//  Copyright (c) 2015年 tcl. All rights reserved.
//

#import "BasicAnimationViewController.h"

@interface BasicAnimationViewController ()
{
    CALayer *layer;
}
@end

@implementation BasicAnimationViewController

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
    //    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 50, 50)];
    layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, 50, 50);
    layer.position = CGPointMake(self.view.frame.size.width/2, 100);
    [layer setContents:(id)[UIImage imageNamed:@"share_wx"].CGImage];
    [self.view.layer addSublayer:layer];
    //    [self.view addSubview:view];
}

- (void)translationAnimation:(CGPoint)location
{
    id value = [NSValue valueWithCGPoint:location];
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"position";
    animation.fromValue = [NSValue valueWithCGPoint:layer.position];
    animation.toValue = value;
    animation.duration = 2;
    animation.removedOnCompletion = NO;
    animation.delegate = self;
    [animation setValue:value forKey:@"location"];
    [layer addAnimation:animation forKey:@"KCBasicAnimation_Position"];
}

- (void)rotationAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animation];
    animation.keyPath = @"transform.rotation.z";
    animation.toValue = @(M_PI_2 * 3);
    animation.duration = 1.1;
    animation.repeatCount = HUGE_VAL;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    [layer addAnimation:animation forKey:@"KCBasicAnimation_Transform"];
}

- (void)animationResume
{
    CFTimeInterval beginTime = CACurrentMediaTime() - layer.timeOffset;
    layer.timeOffset = 0;
    layer.beginTime = beginTime;
    layer.speed = 1;
}

- (void)animationPuase
{
    CFTimeInterval interval = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    
    layer.timeOffset = interval;
    layer.speed = 0;
}


#pragma mark - Animation delegate
- (void)animationDidStart:(CAAnimation *)anim
{
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    
    layer.position = [[anim valueForKey:@"location"] CGPointValue];
    
    [CATransaction commit];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    //    [CATransaction begin];
    //
    //    [CATransaction setDisableActions:YES];
    //
    //    layer.position = [[anim valueForKey:@"location"] CGPointValue];
    //
    //    [CATransaction commit];
}

#pragma mark - touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = touches.anyObject;
    CGPoint location = [touch locationInView:self.view];
    CAAnimation *anim = [layer animationForKey:@"KCBasicAnimation_Position"];
    
    if (anim)
    {
        if (layer.speed == 0)
            [self animationResume];
        else
            [self animationPuase];
    }
    else
    {
        [self translationAnimation:location];
        [self rotationAnimation];
    }
}
@end
