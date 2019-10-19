//
//  WSProgressHUD.h
//  WSProgressHUD
//
//  Created by Wilson-Yuan on 15/7/17.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WSProgressHUDMaskType) {
    WSProgressHUDMaskTypeDefault, //allow user touch when hud display
    WSProgressHUDMaskTypeClear, //dont allowed user touch
    WSProgressHUDMaskTypeBlack, //dont allowed user touch
    WSProgressHUDMaskTypeGradient //dont allowed user touch
};

typedef NS_ENUM(NSInteger, WSProgressHUDMaskWithoutType) { //
    WSProgressHUDMaskWithoutDefault, // default mask all
    WSProgressHUDMaskWithoutNavigation, //show mask without navigation
    WSProgressHUDMaskWithoutTabbar, //show mask without tabbar
    WSProgressHUDMaskWithoutNavAndTabbar, //show mask without tabbar and navigation
};

typedef NS_ENUM(NSInteger, WSProgressHUDIndicatorStyle) {
    WSProgressHUDIndicatorCustom,
    WSProgressHUDIndicatorMMSpinner,
    WSProgressHUDIndicatorSmallLight,
    WSProgressHUDIndicatorGray,
    WSProgressHUDIndicatorBigGray,
};


@interface WSProgressHUD : UIView

/*----------------------Show On the Window------------------------------*/
+ (void)show;
+ (void)showWithMaskType:(WSProgressHUDMaskType)maskType;
+ (void)showWithMaskType:(WSProgressHUDMaskType)maskType maskWithout:(WSProgressHUDMaskWithoutType)withoutType;


+ (void)showWithStatus:(nullable NSString *)string;
+ (void)showWithStatus:(nullable NSString *)string maskType:(WSProgressHUDMaskType)maskType;
+ (void)showWithStatus:(nullable NSString *)string maskType:(WSProgressHUDMaskType)maskType maskWithout:(WSProgressHUDMaskWithoutType)withoutType;


+ (void)showShimmeringString:(nullable NSString *)string;
+ (void)showShimmeringString:(nullable NSString *)string maskType:(WSProgressHUDMaskType)maskType;
+ (void)showShimmeringString:(nullable NSString *)string maskType:(WSProgressHUDMaskType)maskType maskWithout:(WSProgressHUDMaskWithoutType)withoutType;

+ (void)showProgress:(CGFloat)progress;
+ (void)showProgress:(CGFloat)progress maskType:(WSProgressHUDMaskType)maskType;
+ (void)showProgress:(CGFloat)progress maskType:(WSProgressHUDMaskType)maskType maskWithout:(WSProgressHUDMaskWithoutType)withoutType;

+ (void)showProgress:(CGFloat)progress status:(nullable NSString *)string;
+ (void)showProgress:(CGFloat)progress status:(nullable NSString *)string maskType:(WSProgressHUDMaskType)maskType;
+ (void)showProgress:(CGFloat)progress status:(nullable NSString *)string maskType:(WSProgressHUDMaskType)maskType maskWithout:(WSProgressHUDMaskWithoutType)withoutType;

//imageSize is 28*28
+ (void)showImage:(nullable UIImage *)image status:(nullable NSString *)title;
+ (void)showImage:(nullable UIImage *)image status:(nullable NSString *)title maskType:(WSProgressHUDMaskType)maskType;
+ (void)showImage:(nullable UIImage *)image status:(nullable NSString *)title maskType:(WSProgressHUDMaskType)maskType maskWithout:(WSProgressHUDMaskWithoutType)withoutType;

+ (void)showSuccessWithStatus:(nullable NSString *)string;
+ (void)showErrorWithStatus:(nullable NSString *)string;
+ (void)dismiss;

/*----------------------------Custom---------------------------------*/

+ (void)setProgressHUDIndicatorStyle:(WSProgressHUDIndicatorStyle)style;

/// if you set WSProgressHUDIndicatorBigGray style you should set second prority indicator Style
+ (void)setSecondProrityIndicatorStyle:(WSProgressHUDIndicatorStyle)style; //Default is small SmallLight

+ (void)setProgressHUDFont:(nonnull UIFont *)font;

/*----------------------Show On the view------------------------------*/

- (WSProgressHUD *_Nonnull)initWithView:(nonnull UIView *)view;
- (WSProgressHUD *_Nonnull)initWithFrame:(CGRect)frame;

- (void)show;
- (void)showWithMaskType:(WSProgressHUDMaskType)maskType;

- (void)showWithString:(nullable NSString *)string;
- (void)showWithString:(nullable NSString *)string maskType:(WSProgressHUDMaskType)maskType;


- (void)showShimmeringString:(nullable NSString *)string;
- (void)showShimmeringString:(nullable NSString *)string maskType:(WSProgressHUDMaskType)maskType;

- (void)showProgress:(CGFloat)progress;
- (void)showProgress:(CGFloat)progress maskType:(WSProgressHUDMaskType)maskType;

- (void)showProgress:(CGFloat)progress status:(nullable NSString *)status;
- (void)showProgress:(CGFloat)progress status:(nullable NSString *)status maskType:(WSProgressHUDMaskType)maskType;



- (void)showImage:(nullable UIImage *)image status:(nullable NSString *)title;
- (void)showImage:(nullable UIImage *)image status:(nullable NSString *)title maskType:(WSProgressHUDMaskType)maskType;

- (void)showSuccessWithString:(nullable NSString *)string;
- (void)showErrorWithString:(nullable NSString *)string;

- (void)dismiss;

/*----------------------------Custom---------------------------------*/
- (void)setProgressHUDIndicatorStyle:(WSProgressHUDIndicatorStyle)style;

/// if you set WSProgressHUDIndicatorBigGray style you should set second prority indicator Style
- (void)setSecondProrityIndicatorStyle:(WSProgressHUDIndicatorStyle)style; //Default is small SmallLight

- (void)setProgressHUDFont:(nonnull UIFont *)font;

@end
