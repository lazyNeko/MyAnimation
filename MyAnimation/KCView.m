//
//  KCView.m
//  MyAnimation
//
//  Created by tuyunfeng on 15/9/11.
//  Copyright (c) 2015年 tcl. All rights reserved.
//

#import "KCView.h"
#import "BrokenLine.h"

@interface KCView ()
{
    CAShapeLayer *lineLayer;
    BrokenLine *bLine;
}
@end

@implementation KCView

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [self drawLine2];
//    [self drawMutableLine:0.5];
}

- (instancetype)init
{
    if (self = [super init])
    {
        [self loadSubLayer];
    }
    
    return self;
}

- (void)drawLine1
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 20, 50);
    CGPathAddLineToPoint(path, nil, 20, 200);
    CGPathAddLineToPoint(path, nil, 250, 200);
    
    CGContextAddPath(context, path);
    
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    CGContextSetRGBFillColor(context, 0, 1, 0, 1);
    CGContextSetLineWidth(context, 6);
    CGContextSetLineCap(context, kCGLineCapRound);
    CGContextSetLineJoin(context, kCGLineJoinRound);
    
    CGFloat lengths[] = {24, 12};
    CGContextSetLineDash(context, 0, lengths, 2);
    
    CGSize offset = CGSizeMake(3, 2);
    //    CGContextSetShadow(context, offset, 2);
    CGContextSetShadowWithColor(context, offset, 2, [UIColor grayColor].CGColor);
    
    CGContextDrawPath(context, kCGPathStroke);
    CGPathRelease(path);
}

- (void)drawLine2
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 15, 30);
    CGPathAddLineToPoint(path, nil, 150, 60);
    CGPathAddLineToPoint(path, nil, 285, 30);
    
    CGContextAddPath(context, path);
    CGContextSetLineWidth(context, 3);
    CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);
    
    CGContextDrawPath(context, kCGPathStroke);
    
    CGPathRelease(path);
}

- (void)drawMutableLine:(CGFloat)progress
{
#if 1
    CGFloat y = 30;
    CGFloat width = self.frame.size.width - 30;
    CGFloat leftW = 15 + width * progress;
    CGFloat bottom = y + 30 - fabs(progress - 0.5) * 30 * 2;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, 15, y);
    CGPathAddLineToPoint(path, nil, leftW, bottom);
    CGPathAddLineToPoint(path, nil, 15 + width, y);
    
    lineLayer.path = path;
#else
    UIBezierPath * path = [UIBezierPath bezierPath];
    [path moveToPoint: CGPointMake(15, 30)];
    [path addLineToPoint: CGPointMake((CGRectGetWidth([UIScreen mainScreen].bounds) - 50) * progress + 25, 30 + (25.f * (1 - fabs(progress - 0.5) * 2)))];
    [path addLineToPoint: CGPointMake(CGRectGetWidth([UIScreen mainScreen].bounds) - 25, 30)];
    
    lineLayer.path = path.CGPath;
#endif
    
    bLine.progress = progress;
}

- (void)loadSubLayer
{
    lineLayer = [CAShapeLayer layer];
    lineLayer.fillColor = [UIColor clearColor].CGColor;
    lineLayer.strokeColor = [UIColor greenColor].CGColor;
    lineLayer.lineWidth = 3.0;
    lineLayer.lineJoin = kCALineJoinRound;
    lineLayer.lineCap = kCALineCapRound;
    
//    [self drawMutableLine:0.0];
    [self.layer addSublayer:lineLayer];
    
    bLine = [BrokenLine layer];
    bLine.frame = CGRectMake(15, 100, 300, 60);
    [self.layer addSublayer:bLine];
}
@end
