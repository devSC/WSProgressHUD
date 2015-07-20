//
//  WSProgressHUD.h
//  WSProgressHUD
//
//  Created by Wilson-Yuan on 15/7/17.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WSProgressHUDMaskType) {
    WSProgressHUDMaskTypeDefault,
    WSProgressHUDMaskTypeClear,
    WSProgressHUDMaskTypeBlack,
    WSProgressHUDMaskTypeGradient
};

@interface WSProgressHUD : UIView

+ (void)show;
+ (void)showWithMaskType: (WSProgressHUDMaskType)maskType;

+ (void)showWithString: (NSString *)string;
+ (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType;

+ (void)showOnlyString: (NSString *)string;
+ (void)showOnlyString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType;


+ (void)showImage:(UIImage *)image title:(NSString *)title;
+ (void)showImage:(UIImage *)image title:(NSString *)title maskType: (WSProgressHUDMaskType)maskType;

//+ (void)showSuccessWithString: (NSString *)string;
+ (void)dismiss;

@end
