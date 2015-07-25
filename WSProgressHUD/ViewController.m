//
//  ViewController.m
//  WSProgressHUD
//
//  Created by Wilson-Yuan on 15/7/17.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "ViewController.h"
#import "WSProgressHUD.h"

#import "MMMaterialDesignSpinner.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet MMMaterialDesignSpinner *spinner;

@end

@implementation ViewController
{
    WSProgressHUD *hud;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    [self.spinner startAnimating];
    hud = [[WSProgressHUD alloc] initWithView:self.navigationController.view];
    
    [self.view addSubview:hud];
    [hud showWithString:@"LaMaMa..."];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud dismiss];
    });

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)show:(id)sender {
//    [hud dismiss];
    
    [WSProgressHUD setProgressHUDIndicatorStyle:WSProgressHUDIndicatorMMSpinner];
//    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack maskWithout:WSProgressHUDMaskWithoutNavigation];
    [WSProgressHUD show];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });
}

- (IBAction)showOnlyString:(id)sender {
//    [hud show];
    [WSProgressHUD showShimmeringString:@"WSProgressHUD正在刷新..."];

    
}
- (IBAction)showWithString:(id)sender {
//    [WSProgressHUD showShimmeringString:@"正在刷新..."];
    progress+=0.05f;
    [WSProgressHUD showProgress:progress status:@"Loading"];
    
    if(progress < 1.0f)
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];
    else
        [WSProgressHUD performSelector:@selector(dismiss) withObject:nil afterDelay:0.4f];

}
static float progress = 0.0f;

- (void)increaseProgress {
    progress+=0.05f;
    [WSProgressHUD showProgress:progress status:@"Loading"];
    
    if(progress < 1.0f)
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];
    else {
        [self performSelector:@selector(showOnlyString:) withObject:nil afterDelay:0.4f];
        progress = 0;
    }
}


- (IBAction)showImage:(id)sender {
    [WSProgressHUD showSuccessWithStatus:@"I was not delivered unto this world in defeat, nor does failure course in my veins. I am not a sheep waiting to be prodded by my shepherd. I am a lion and I refuse to talk, to walk, to sleep with the sheep. I will hear not those who weep and complain, for their disease is contagious. Let them join the sheep. The slaughterhouse of failure is not my destiny."];

}
- (IBAction)showString:(id)sender {
//    [WSProgressHUD showImage:nil status:@"WSProgressHUD"];
    progress+=0.005f;
    [WSProgressHUD showProgress:progress status:nil];
    
    if(progress < 1.0f)
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];
    else
        [WSProgressHUD performSelector:@selector(dismiss) withObject:nil afterDelay:0.4f];

}

- (IBAction)dismiss:(id)sender {
    [WSProgressHUD dismiss];
}

@end
