//
//  KeyAnimationViewController.m
//  MyAnimation
//
//  Created by tuyunfeng on 15/9/10.
//  Copyright (c) 2015年 tcl. All rights reserved.
//

#import "KeyAnimationViewController.h"

@interface KeyAnimationViewController ()
{
    CALayer *layer;
}
@end

@implementation KeyAnimationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Keyfram Animation";
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self loadSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSubview
{
    layer = [[CALayer alloc] init];
    layer.bounds = CGRectMake(0, 0, 50, 50);
    layer.position = CGPointMake(self.view.frame.size.width/2, 100);
    layer.contents = (id)[UIImage imageNamed:@"share_zone"].CGImage;
    [self.view.layer addSublayer:layer];
    
    [self groupAnimation];
}

- (CAKeyframeAnimation *)translationAnimation
{
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGFloat x = layer.position.x;
    
#if 1
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, x, layer.position.y);
    CGPathAddCurveToPoint(path, NULL, x+250, 250, x-250, 400, x, 550);
    
    animation.path = path;
    CGPathRelease(path);
    
    [animation setValue:[NSValue valueWithCGPoint:CGPointMake(x, 550)] forKey:@"location"];
#else
    NSValue *key1 = [NSValue valueWithCGPoint:layer.position];
    NSValue *key2 = [NSValue valueWithCGPoint:CGPointMake(x + 20, 200)];
    NSValue *key3 = [NSValue valueWithCGPoint:CGPointMake(x - 5, 300)];
    NSValue *key4 = [NSValue valueWithCGPoint:CGPointMake(x + 15, 400)];
    NSValue *key5 = [NSValue valueWithCGPoint:CGPointMake(x - 10, 500)];
    
    animation.values = @[key1, key2, key3, key4, key5];
    [animation setValue:key5 forKey:@"location"];
#endif
//    animation.duration = 3.0;
//    animation.beginTime = CACurrentMediaTime() + 1;
    
//    animation.delegate = self;
    
//    [layer addAnimation:animation forKey:@"Keyframe_Translation"];
    return animation;
}

- (CABasicAnimation *)rotationAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    animation.toValue = @(M_PI_2 * 3);
    animation.repeatCount = HUGE_VAL;
    animation.autoreverses = YES;
    animation.removedOnCompletion = NO;
    
    [animation setValue:animation.toValue forKey:@"rotation"];
    
    return animation;
}

- (void)groupAnimation
{
    CAAnimationGroup *groupAnim = [CAAnimationGroup animation];
    
    groupAnim.animations = @[[self translationAnimation], [self rotationAnimation]];
    groupAnim.duration = 2;
    groupAnim.beginTime = CACurrentMediaTime() + 1;
    
    groupAnim.delegate = self;
    
    [layer addAnimation:groupAnim forKey:@"Group_Animation"];
}

#pragma mark - Animation delegate
- (void)animationDidStart:(CAAnimation *)anim
{
    CAAnimationGroup *groupAnim = (CAAnimationGroup *)anim;
    CAKeyframeAnimation *keyAnim = groupAnim.animations[0];
    CABasicAnimation *baseAnim = groupAnim.animations[1];
    
    [CATransaction begin];
    
    [CATransaction setDisableActions:YES];
    
//    layer.position = [[anim valueForKey:@"location"] CGPointValue];
    
    layer.position = [[keyAnim valueForKey:@"location"] CGPointValue];
    layer.transform = CATransform3DMakeRotation([[baseAnim valueForKey:@"rotation"] floatValue], 0, 0, 1);
    
    [CATransaction commit];
}
@end
