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
{
    KCView *kcView;
}
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
    kcView = [[KCView alloc] init];
    kcView.frame = CGRectMake(50, 100, 300, 400);
    kcView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:kcView];
    
    UISlider *slider = [[UISlider alloc] init];
    slider.frame = CGRectMake(15, 310, 300, 30);
    slider.minimumValue = 0;
    slider.maximumValue = 1;
    [slider addTarget:self action:@selector(progressChanged:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:slider];
    
    [kcView drawMutableLine:0.0];
}

- (void)progressChanged:(UISlider *)sender
{
    [kcView drawMutableLine:sender.value];
}
@end
