//
//  ViewController.m
//  WSProgressHUD
//
//  Created by Wilson-Yuan on 15/7/17.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "ViewController.h"
#import "WSProgressHUD.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)showNoString:(id)sender {
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeGradient];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
    
}

- (IBAction)showOnlyString:(id)sender {
    [WSProgressHUD showOnlyString:@" WSProgressHUD正在刷新..."];
    
}
- (IBAction)show:(id)sender {
    [WSProgressHUD showWithString:@"刷新中..."];
}
- (IBAction)showImage:(id)sender {
    [WSProgressHUD showImage:nil title:@"获取成功"];
}

- (IBAction)dismiss:(id)sender {
    [WSProgressHUD dismiss];
}

@end
