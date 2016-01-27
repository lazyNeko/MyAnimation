//
//  HomeViewController.h
//  MyAnimation
//
//  Created by tuyunfeng on 15/9/10.
//  Copyright (c) 2015年 tcl. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UserDelegate <NSObject>

@property (strong, nonatomic) NSString *name;

@end

@interface HomeViewController : UIViewController <UserDelegate>
@property (strong, nonatomic) NSString *name;
@end


@interface TEKeyChain : NSObject
+ (void)save:(NSString *)service data:(id)data;
+ (id)load:(NSString *)service;

@end

@interface UserDataManager : NSObject
+ (void)savePassword:(NSString *)password;
+ (id)readPassword;

@property (weak, nonatomic) id delegate;
@end

