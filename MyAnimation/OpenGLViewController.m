//
//  OpenGLViewController.m
//  MyAnimation
//
//  Created by tuyunfeng on 16/4/13.
//  Copyright © 2016年 tcl. All rights reserved.
//

#import "OpenGLViewController.h"
#import "OpenGLView.h"

@interface OpenGLViewController ()

@end

@implementation OpenGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor lightGrayColor];
    [self loadOpenGLView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadOpenGLView
{
    OpenGLView *glView = [[OpenGLView alloc] initWithFrame:CGRectMake(100, 100, 200, 200)];
    [self.view addSubview:glView];
}

@end
