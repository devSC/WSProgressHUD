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
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeClear maskWithout:WSProgressHUDMaskWithoutNavigation];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
}

- (IBAction)showOnlyString:(id)sender {
    [WSProgressHUD showOnlyString:@"正在刷新..."];
    
}
- (IBAction)show:(id)sender {
    [WSProgressHUD showWithString:@"请等待,刷新中..."];
}
- (IBAction)showImage:(id)sender {
//    [WSProgressHUD showImage:nil title:@"WSProgressHUD获取成功"];
//    [WSProgressHUD showImage:[UIImage imageNamed:@"error"] title:@"Do not pray for tasks equal to your powers.Pray for powers equal to your tasks.Then the doing of work shall be no miracle,but you shall be the miracle."];
    [WSProgressHUD showSuccessWithString:@"I was not delivered unto this world in defeat, nor does failure course in my veins. I am not a sheep waiting to be prodded by my shepherd. I am a lion and I refuse to talk, to walk, to sleep with the sheep. I will hear not those who weep and complain, for their disease is contagious. Let them join the sheep. The slaughterhouse of failure is not my destiny."];

}

- (IBAction)dismiss:(id)sender {
    [WSProgressHUD dismiss];
}

@end
