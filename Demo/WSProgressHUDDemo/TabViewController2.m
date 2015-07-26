//
//  TabViewController2.m
//  WSProgressHUD
//
//  Created by YSC on 15/7/23.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "TabViewController2.h"
#import "WSProgressHUD.h"

@interface TabViewController2 ()

@end

@implementation TabViewController2
{
    WSProgressHUD *hud;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    hud = [[WSProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:hud];
    
    [hud showShimmeringString:@"Loading...."];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud dismiss];
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
