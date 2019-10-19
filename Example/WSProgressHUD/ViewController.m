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

#define isIphoneX ({\
BOOL isPhoneX = NO;\
if (@available(iOS 11.0, *)) {\
    if (!UIEdgeInsetsEqualToEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets, UIEdgeInsetsZero)) {\
    isPhoneX = YES;\
    }\
}\
isPhoneX;\
})



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

    //Add HUD to view
    hud = [[WSProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:hud];
    
    //show
    [hud showWithString:@"Wating..." maskType:WSProgressHUDMaskTypeBlack];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud dismiss];
    });
    
    
    NSLog(@"isPhoneX: %@ safeAreaInsets: %@", @(isIphoneX), NSStringFromUIEdgeInsets([UIApplication sharedApplication].delegate.window.safeAreaInsets));
    
    //IpHONE11 : 2019-10-12 13:47:13.977848+0800 WSProgressHUD-Demo[11856:364632] safeAreaInsets: {44, 0, 34, 0}
    //IPhone8 2019-10-12 13:48:20.355807+0800 WSProgressHUD-Demo[12002:367684] safeAreaInsets: {0, 0, 0, 0}
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)show:(id)sender {

    [WSProgressHUD setProgressHUDIndicatorStyle:WSProgressHUDIndicatorBigGray];
    [WSProgressHUD show];
    [self autoDismiss];
}

- (IBAction)showShimmeringString:(id)sender {

    [WSProgressHUD showShimmeringString:@"WSProgressHUD Loading..." maskType:WSProgressHUDMaskTypeBlack maskWithout:WSProgressHUDMaskWithoutNavigation];

    [self autoDismiss];
}
- (IBAction)showWithString:(id)sender {
    [WSProgressHUD showWithStatus:@"Loading..." maskType:WSProgressHUDMaskTypeBlack];
    [self autoDismiss];

}
- (IBAction)showProgress:(id)sender {
    [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];
}


static float progress = 0.0f;

- (void)increaseProgress {
    progress+=0.1f;
    [WSProgressHUD showProgress:progress status:@"Updating..."];
    
    if(progress < 1.0f) {
        [self performSelector:@selector(increaseProgress) withObject:nil afterDelay:0.3f];
    } else {
        [WSProgressHUD showImage:nil status:@"Success Update"];
        progress = 0;
    }
}


- (IBAction)showImage:(id)sender {
    
    [WSProgressHUD showSuccessWithStatus:@"I was not delivered unto this world in defeat, nor does failure course in my veins. I am not a sheep waiting to be prodded by my shepherd. I am a lion and I refuse to talk, to walk, to sleep with the sheep. I will hear not those who weep and complain, for their disease is contagious. Let them join the sheep. The slaughterhouse of failure is not my destiny."];

}
- (IBAction)showString:(id)sender {
    [WSProgressHUD showImage:nil status:@"WSProgressHUD"];
}

- (IBAction)dismiss:(id)sender {
    [WSProgressHUD dismiss];
}


- (void)autoDismiss
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [WSProgressHUD dismiss];
    });

}


@end
