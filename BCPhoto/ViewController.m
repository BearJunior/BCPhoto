//
//  ViewController.m
//  BCPhoto
//
//  Created by admin on 16/12/5.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "ViewController.h"
#import "BCMainVC.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [UIButton new];
    button.frame = CGRectMake(100, 100, 100, 40);
    [button setTitle:@"跳转" forState:0];
    [button setBackgroundColor:[UIColor cyanColor]];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)buttonAction:(UIButton*)sender
{
    [self presentViewController:[BCMainVC new] animated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
