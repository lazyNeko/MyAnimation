//
//  Quartz2DViewController.m
//  MyAnimation
//
//  Created by tuyunfeng on 15/9/11.
//  Copyright (c) 2015年 tcl. All rights reserved.
//

#import "Quartz2DViewController.h"
#import "KCView.h"

@interface Quartz2DViewController ()

@end

@implementation Quartz2DViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Quartz 2D";
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self loadSubview];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadSubview
{
    KCView *view = [[KCView alloc] init];
    view.frame = CGRectMake(50, 100, 300, 400);
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}

@end
