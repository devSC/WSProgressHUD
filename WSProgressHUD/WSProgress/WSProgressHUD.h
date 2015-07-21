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

typedef NS_ENUM(NSInteger, WSProgressHUDMaskWithoutType) {
    WSProgressHUDMaskWithoutDefault, // default no without
    WSProgressHUDMaskWithoutNavigation, //show mask without navigation
    WSProgressHUDMaskWithoutTabbar, //show mask without tabbar
    WSProgressHUDMaskWithoutNavAndTabbar, //show mask without tabbar and navigation
};


@interface WSProgressHUD : UIView

+ (void)show;
+ (void)showWithMaskType: (WSProgressHUDMaskType)maskType;
+ (void)showWithMaskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType;


+ (void)showWithString: (NSString *)string;
+ (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType;
+ (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType;


+ (void)showOnlyString: (NSString *)string;
+ (void)showOnlyString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType;
+ (void)showOnlyString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType;



+ (void)showImage:(UIImage *)image title:(NSString *)title;
+ (void)showImage:(UIImage *)image title:(NSString *)title maskType: (WSProgressHUDMaskType)maskType;
+ (void)showImage:(UIImage *)image title:(NSString *)title maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType;

+ (void)showSuccessWithString: (NSString *)string;
+ (void)showErrorWithString: (NSString *)string;

+ (void)dismiss;

/* 
 
    1:  我的maskType中, 把navigationBar 和tabbar的位置留出来呗?
    2:不是单纯的改变一个frame和换self.view或是self.nav.view来贴，那样你更要考虑交互问题了
 
    nav的pop和push 还有模态。这个其实也好做，用重载方法，在执行pop,push啊这些之前移除掉你的view就好了
 */
@end
