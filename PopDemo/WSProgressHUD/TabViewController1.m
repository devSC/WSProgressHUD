//
//  TabViewController1.m
//  WSProgressHUD
//
//  Created by YSC on 15/7/21.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "TabViewController1.h"
#import "WSProgressHUD.h"
@interface TabViewController1 ()

@end

@implementation TabViewController1

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)show:(id)sender {
    
    [WSProgressHUD showWithString:@"Loading..." maskType:WSProgressHUDMaskTypeGradient maskWithout:WSProgressHUDMaskWithoutNavAndTabbar];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
