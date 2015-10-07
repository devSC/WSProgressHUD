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
+ (void)showWithMaskType: (WSProgressHUDMaskType)maskType;
+ (void)showWithMaskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType;


+ (void)showWithStatus: (NSString *)string;
+ (void)showWithStatus: (NSString *)string maskType: (WSProgressHUDMaskType)maskType;
+ (void)showWithStatus: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType;


+ (void)showShimmeringString: (NSString *)string;
+ (void)showShimmeringString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType;
+ (void)showShimmeringString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType;

+ (void)showProgress:(CGFloat)progress;
+ (void)showProgress:(CGFloat)progress maskType:(WSProgressHUDMaskType)maskType;
+ (void)showProgress:(CGFloat)progress maskType:(WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType;

+ (void)showProgress:(CGFloat)progress status:(NSString*)string;
+ (void)showProgress:(CGFloat)progress status:(NSString*)string maskType:(WSProgressHUDMaskType)maskType;
+ (void)showProgress:(CGFloat)progress status:(NSString*)string maskType:(WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType;

//imageSize is 28*28
+ (void)showImage:(UIImage *)image status:(NSString *)title;
+ (void)showImage:(UIImage *)image status:(NSString *)title maskType: (WSProgressHUDMaskType)maskType;
+ (void)showImage:(UIImage *)image status:(NSString *)title maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType;

+ (void)showSuccessWithStatus: (NSString *)string;
+ (void)showErrorWithStatus: (NSString *)string;
+ (void)dismiss;

/*----------------------------Custom---------------------------------*/

+ (void)setProgressHUDIndicatorStyle: (WSProgressHUDIndicatorStyle)style;

/// if you set WSProgressHUDIndicatorBigGray style you should set second prority indicator Style
+ (void)setSecondProrityIndicatorStyle: (WSProgressHUDIndicatorStyle)style; //Default is small SmallLight

+ (void)setProgressHUDFont: (UIFont *)font;

/*----------------------Show On the view------------------------------*/

- (instancetype)initWithView: (UIView *)view;
- (instancetype)initWithFrame:(CGRect)frame;

- (void)show;
- (void)showWithMaskType: (WSProgressHUDMaskType)maskType;

- (void)showWithString: (NSString *)string;
- (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType;


- (void)showShimmeringString: (NSString *)string;
- (void)showShimmeringString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType;

- (void)showProgress:(CGFloat)progress;
- (void)showProgress:(CGFloat)progress maskType:(WSProgressHUDMaskType)maskType;

- (void)showProgress:(CGFloat)progress status:(NSString*)status;
- (void)showProgress:(CGFloat)progress status:(NSString*)status maskType:(WSProgressHUDMaskType)maskType;



- (void)showImage:(UIImage *)image status:(NSString *)title;
- (void)showImage:(UIImage *)image status:(NSString *)title maskType: (WSProgressHUDMaskType)maskType;

- (void)showSuccessWithString: (NSString *)string;
- (void)showErrorWithString: (NSString *)string;

- (void)dismiss;

/*----------------------------Custom---------------------------------*/
- (void)setProgressHUDIndicatorStyle: (WSProgressHUDIndicatorStyle)style;

/// if you set WSProgressHUDIndicatorBigGray style you should set second prority indicator Style
- (void)setSecondProrityIndicatorStyle: (WSProgressHUDIndicatorStyle)style; //Default is small SmallLight

- (void)setProgressHUDFont: (UIFont *)font;

@end
