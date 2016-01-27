//
//  ExternFunction.h
//  MyAnimation
//
//  Created by tuyunfeng on 15/11/12.
//  Copyright © 2015年 tcl. All rights reserved.
//

#ifndef ExternFunction_h
#define ExternFunction_h

#import <UIKit/UIKit.h>
#include <stdio.h>
extern void setSkin(NSString *name);
extern UIImage *getNamedImage(NSString *bundle, NSString *name);
extern UIImage *getImageFromPath(NSString *bundle, NSString *name, NSString *types);
#endif /* ExternFunction_h */
