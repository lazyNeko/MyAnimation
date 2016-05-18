//
//  DrawGraphicsViewController.m
//  MyAnimation
//
//  Created by tuyunfeng on 16/4/7.
//  Copyright © 2016年 tcl. All rights reserved.
//

#import "DrawGraphicsViewController.h"
#import "KCLayer.h"
#import <objc/runtime.h>

#define WIDTH 50

@interface DrawGraphicsViewController ()
{
    UIView *rocket;
    KCLayer *kcLayer;
    CALayer *lineLayer;
}
@end

@implementation DrawGraphicsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
//    [self drawMyLayer];
//    [self drawShapeLayer];
//    [self drawImageLayer];
//    [self loadRocket];
    [self drawCustomLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    UIView *view = [[UIView alloc] init];
//    view.frame = CGRectMake(50, 100, 200, 200);
//    view.backgroundColor = [UIColor redColor];
//    
//    [self.view addSubview:view];
//    
//    [UIView animateWithDuration:1.0 animations:^{
//        view.backgroundColor = [UIColor blueColor];
//    }];
}

- (void)loadRocket
{
    rocket = [[UIView alloc] init];
    rocket.frame = CGRectMake(50, 50, 50, 50);
    rocket.backgroundColor = [UIColor grayColor];
    [self.view addSubview:rocket];
}

- (void)drawMyLayer
{
    CGSize size = [UIScreen mainScreen].bounds.size;
    
    CALayer *layer = [CALayer layer];
    layer.backgroundColor = [UIColor colorWithRed:0 green:0.54 blue:1 alpha:1].CGColor;
    layer.position = CGPointMake(size.width/2, size.height/2);
    layer.bounds   = CGRectMake(0, 0, WIDTH, WIDTH);
    layer.cornerRadius = WIDTH/2;
    layer.shadowColor  = [UIColor grayColor].CGColor;
    layer.shadowOffset = CGSizeMake(2, 2);
    layer.shadowOpacity = 0.9;
    
    [self.view.layer addSublayer:layer];
}

- (void)drawShapeLayer
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.fillColor = [UIColor grayColor].CGColor;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.lineWidth = 4;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 15, 100);
    CGPathAddLineToPoint(path, nil, 35, 140);
    CGPathAddLineToPoint(path, nil, 15, 180);
    
    layer.path = path;
    
    CGPathRelease(path);
    
    [self.view.layer addSublayer:layer];
}

#pragma mark - touch
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self.view];
#if 1
    [self basicAnimation:location];
//    [self keyframeAnimation:location];
#else
    
    CALayer *layer = self.view.layer.sublayers[0];
    CGFloat width = layer.bounds.size.width;
    
    if (width == WIDTH)
        width = WIDTH * 4;
    else
        width = WIDTH;
    
    layer.bounds = CGRectMake(0, 0, width, width);
    layer.position = location;
    layer.cornerRadius = width/2;
#endif
}

////////layer image////////////
- (void)drawImageLayer
{
    CGSize size = self.view.bounds.size;
    
    CALayer *layer = [CALayer layer];
    layer.position = CGPointMake(size.width/2, size.height/2);
    layer.bounds = CGRectMake(0, 0, WIDTH, WIDTH);
    layer.cornerRadius = WIDTH/2;
    
#if 1
    UIImage *image = [UIImage imageNamed:@"share_zone"];
    [layer setContents:(id)image.CGImage];
#else
    layer.transform = CATransform3DMakeRotation(M_PI, 1, 0, 0);
    
    layer.delegate = self;
    
    [layer setNeedsDisplay];
#endif
    [self.view.layer addSublayer:layer];
}

- (void)drawLayer:(CALayer *)layer inContext:(CGContextRef)ctx
{
    CGContextSaveGState(ctx);
    
//    CGContextScaleCTM(ctx, 1, -1);
//    CGContextTranslateCTM(ctx, 0, -WIDTH);
    
    UIImage *image = [UIImage imageNamed:@"share_zone"];
    
    CGContextDrawImage(ctx, layer.bounds, image.CGImage);
    
    CGContextRestoreGState(ctx);
}

//////////////////////////////
- (void)drawCustomLayer
{
    CGSize size = self.view.bounds.size;
    
    lineLayer = [CALayer layer];
    lineLayer.position = CGPointMake(size.width/2, size.height/2);
    lineLayer.bounds = CGRectMake(0, 0, 300, 8);
    lineLayer.backgroundColor = [UIColor whiteColor].CGColor;
    
    [self.view.layer addSublayer:lineLayer];
    
    KCLayer *layer = [KCLayer layer];
    layer.position = CGPointMake(size.width/2, size.height/2);
    layer.bounds = CGRectMake(0, 0, 185, 185);
    [layer setNeedsDisplay];
    
    [self.view.layer addSublayer:layer];
    
    kcLayer = layer;
}

////////////basic animation///////////
- (void)basicAnimation:(CGPoint)location
{
    CABasicAnimation *am = [CABasicAnimation animationWithKeyPath:@"position"];
//    am.fromValue = [NSValue valueWithCGPoint:kcLayer.position];
    am.toValue = [NSValue valueWithCGPoint:location];
    am.duration = 0.5;
//    am.delegate = self;
    [am setValue:am.toValue forKey:@"test"];
    
    [kcLayer addAnimation:am forKey:@"KCBasicAnimation_Translation"];
    [rocket.layer addAnimation:am forKey:@"rocket"];
}

//////keyframe animation///////////////
- (void)keyframeAnimation:(CGPoint)location
{
    CAKeyframeAnimation *am = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    NSValue *key1 = [NSValue valueWithCGPoint:kcLayer.position];
    NSValue *key2 = [NSValue valueWithCGPoint:location];
    am.values = @[key1, key2];
    am.duration = 3.5;
    am.delegate = self;
    [am setValue:key2 forKey:@"test"];
    
    [kcLayer addAnimation:am forKey:@"KCBasicAnimation_Translation"];
    [lineLayer addAnimation:am forKey:@"line"];
    
    CATransition *trans = [CATransition animation];
    trans.type = kCATransitionFade;
    trans.duration = 3.5;
    lineLayer.backgroundColor = lineLayer.backgroundColor == [UIColor whiteColor].CGColor ? [UIColor blueColor].CGColor : [UIColor whiteColor].CGColor;
    [lineLayer addAnimation:trans forKey:@"trans"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    kcLayer.position = [[anim valueForKey:@"test"] CGPointValue];
    lineLayer.position = kcLayer.position;
    [CATransaction commit];
}


@end
