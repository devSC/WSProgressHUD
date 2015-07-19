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
- (IBAction)show:(id)sender {
//    [WSProgressHUD showWithString:@"获取城市数据..."];
    [WSProgressHUD showOnlyString:@"获取城市数据..."];
}
- (IBAction)dismiss:(id)sender {
    [WSProgressHUD dismiss];
}
- (IBAction)showNoString:(id)sender {
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeGradient];
}

@end
