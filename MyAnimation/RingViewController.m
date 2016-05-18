//
//  RingViewController.m
//  MyAnimation
//
//  Created by tuyunfeng on 16/4/13.
//  Copyright © 2016年 tcl. All rights reserved.
//

#import "RingViewController.h"

@interface RingViewController ()
{
    CGSize size;
    CAShapeLayer *ringLayer;
}
@end

@implementation RingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    size = self.view.frame.size;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self drawRing];
}

- (void)drawRing
{
    CGFloat width = 200;
    CGFloat lineWidth = 16;
    CAShapeLayer *layer = [CAShapeLayer layer];
    
//    layer.position = CGPointMake(size.width/2, size.height/2);
//    layer.bounds = CGRectMake(0, 0, width, width);
    layer.lineWidth = lineWidth;
    layer.lineCap = kCALineCapButt;
    layer.lineDashPhase = 1.0;
    layer.lineDashPattern = @[@5.0, @2.5];
    layer.strokeColor = [UIColor greenColor].CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    ringLayer = layer;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(width/2, width/2) radius:width/2 - lineWidth/2 startAngle:0 endAngle:M_PI*2 clockwise:YES];
    layer.path = path.CGPath;
    
    CAGradientLayer *colorLayer = [CAGradientLayer layer];
    colorLayer.position = CGPointMake(size.width/2, size.height/2);
    colorLayer.bounds = CGRectMake(0, 0, width, width);
    colorLayer.startPoint = CGPointMake(0, 0);
    colorLayer.endPoint = CGPointMake(1, 1);
    colorLayer.colors = @[(__bridge id)[UIColor redColor].CGColor,
                          (__bridge id)[UIColor orangeColor].CGColor,
                          (__bridge id)[UIColor yellowColor].CGColor,
                          (__bridge id)[UIColor greenColor].CGColor,
                          (__bridge id)[UIColor blueColor].CGColor];
    colorLayer.mask = layer;
    
    [self.view.layer addSublayer:colorLayer];

    [self ringAnimation];
}

- (void)ringAnimation
{
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 2.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    [ringLayer addAnimation:pathAnimation forKey:nil];
}

@end
