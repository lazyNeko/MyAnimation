//
//  KCView.m
//  MyAnimation
//
//  Created by tuyunfeng on 15/9/11.
//  Copyright (c) 2015年 tcl. All rights reserved.
//

#import "KCView.h"

@implementation KCView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
//    [self drawLine1];
    
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
    CGPathMoveToPoint(path, nil, 20, 50);
    CGPathAddLineToPoint(path, nil, 20, 200);
    CGPathAddLineToPoint(path, nil, 250, 200);
    
    CGContextAddPath(context, path);
    
    [[UIColor redColor] set];
}
@end
