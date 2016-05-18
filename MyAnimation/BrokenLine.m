//
//  BrokenLine.m
//  MyAnimation
//
//  Created by tuyunfeng on 16/3/30.
//  Copyright © 2016年 tcl. All rights reserved.
//

#import "BrokenLine.h"

@implementation BrokenLine

- (void)setProgress:(CGFloat)progress
{
    _progress = MIN(1.f, MAX(0.f, progress));
    [self setNeedsDisplay];
}

- (void)drawInContext:(CGContextRef)ctx
{
    CGFloat y = 30;
    CGFloat x = 0;
    CGFloat width = self.frame.size.width - 30;
    CGFloat leftW = x + width * _progress;
    CGFloat bottom = y + 30 - fabs(_progress - 0.5) * 30 * 2;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, nil, x, y);
    CGPathAddLineToPoint(path, nil, leftW, bottom);
    CGPathAddLineToPoint(path, nil, x + width, y);
    
    CGContextAddPath(ctx, path);
    CGContextSetLineWidth(ctx, 3);
    CGContextSetRGBStrokeColor(ctx, 0, 1, 0, 1);
    CGContextStrokePath(ctx);
//    CGContextDrawPath(ctx, kCGPathStroke);
    
    CGPathRelease(path);
}
@end
