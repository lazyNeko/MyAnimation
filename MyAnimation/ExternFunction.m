//
//  ExternFunction.c
//  MyAnimation
//
//  Created by tuyunfeng on 15/11/12.
//  Copyright © 2015年 tcl. All rights reserved.
//

#include "ExternFunction.h"

NSString *skinName = @"Green";

void setSkin(NSString *name)
{
    skinName = name;
}

NSString *getSkinPath(NSString *name)
{
    return [@"Skin" stringByAppendingPathComponent:name];
}

UIImage *getNamedImage(NSString *bundle, NSString *name)
{
    NSString *subPath = [getSkinPath(skinName) stringByAppendingPathComponent:name];
    NSString *subStr = [@".bundle" stringByAppendingPathComponent:subPath];
    NSString *path = [bundle stringByAppendingString:subStr];

    return [UIImage imageNamed:path];
}

UIImage *getImageFromPath(NSString *bundle, NSString *name, NSString *type)
{
    NSString *subPath = [getSkinPath(skinName) stringByAppendingPathComponent:name];
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundle ofType:@"bundle"];
    NSString *path = [[NSBundle bundleWithPath:bundlePath] pathForResource:subPath ofType:type];
    
    return [[UIImage alloc] initWithContentsOfFile:path];
}