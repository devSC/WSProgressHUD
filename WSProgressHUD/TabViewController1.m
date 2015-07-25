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
{
    WSProgressHUD *hud;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [WSProgressHUD dismiss];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    hud = [[WSProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    [hud showWithString:nil maskType:WSProgressHUDMaskTypeBlack];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud dismiss];
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)show:(id)sender {
    [hud showWithString:@"Loading..."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud dismiss];
    });
    

}
- (IBAction)showOnTheWindow:(id)sender {
    [WSProgressHUD showWithStatus:@"Loading..." maskType:WSProgressHUDMaskTypeBlack maskWithout:WSProgressHUDMaskWithoutNavAndTabbar];
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
