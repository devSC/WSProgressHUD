//
//  WSProgressHUD.m
//  WSProgressHUD
//
//  Created by Wilson-Yuan on 15/7/17.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSProgressHUD.h"
#import "FBShimmeringView.h"
#import <objc/runtime.h>
#import "WSIndefiniteAnimationView.h"
#import "MMMaterialDesignSpinner.h"

typedef NS_ENUM(NSInteger, WSProgressHUDType) {
    WSProgressHUDTypeStatus,
    WSProgressHUDTypeString,
    WSProgressHUDTypeImage,
};

@interface WSProgressHUD ()

@property (nonatomic, strong) UIControl *overlayView;

@property (strong, nonatomic) UILabel *labelView;

@property (strong, nonatomic) UIView *hudView;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) FBShimmeringView *shimmeringView;

@property (strong, nonatomic) UILabel *shimmeringLabel;

@property (strong, nonatomic) CAShapeLayer *ringLayer;

@property (strong, nonatomic) UIImageView *imageView;

@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) WSIndefiniteAnimationView *indefiniteAnimationView;

@property (strong, nonatomic) MMMaterialDesignSpinner *spinnerView;



@end

static CGFloat stringWidth = 0.0f;
static CGFloat stringHeight = 0.0f;

static CGFloat const imageOffset = 40;

static CGFloat maskTopEdge = 0;
static CGFloat maskBottomEdge = 0;

static CGFloat WSProgressHUDDefaultWidth = 50;
static CGFloat WSProgressHUDDefaultHeight = 50;

static CGRect WSProgressHUDStringRect;
static CGRect WSProgressHUDNewBounds;

static UIColor *WSProgressHUDForeGroundColor;
static UIImage *WSProgressHUDSuccessImage;
static UIImage *WSProgressHUDErrorImage;

static CGFloat const WSProgressHUDIndicatorBig = 35;
static CGFloat const WSProgressHUDIndicatorSmall = 20;

static CGFloat WSProgressHUDRingThickness = 2;
static CGFloat WSProgressHUDShowDuration = 0.3;
static CGFloat WSProgressHUDDismissDuration = 0.3;
static CGFloat const WSProgressHUDWidthEdgeOffset = 20;
static CGFloat const WSProgressHUDHeightEdgeOffset = 10;
static CGFloat const WSProgressHUDImageTypeWidthEdgeOffset = 30;




@implementation WSProgressHUD


+ (WSProgressHUD *)shareInstance {
    static dispatch_once_t once;
    static WSProgressHUD *shareView;
    dispatch_once(&once, ^{
        shareView = [[self alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];

    });
    return shareView;
}


#pragma mark - Show
+ (void)show {
    [self showWithMaskType:WSProgressHUDMaskTypeDefault];
}

+ (void)showWithMaskType: (WSProgressHUDMaskType)maskType
{
    [self showWithMaskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}

+ (void)showWithMaskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [[self shareInstance] addOverlayViewToWindow];
    [[self shareInstance] showWithMaskType:maskType maskWithout:withoutType];
}


#pragma mark - Show with string
+ (void)showWithString:(NSString *)string
{
    [self showWithString:string maskType:WSProgressHUDMaskTypeDefault];
}

+ (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{
    [self showWithString:string maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}

+ (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [[self shareInstance] addOverlayViewToWindow];
    [[self shareInstance] showWithString:string maskType:maskType maskWithout:withoutType];
}


#pragma mark - Show image

+ (void)showSuccessWithString: (NSString *)string
{
    [self showImage:WSProgressHUDSuccessImage status:string];
}

+ (void)showErrorWithString: (NSString *)string
{
    [self showImage:WSProgressHUDErrorImage status:string];
}


+ (void)showImage:(UIImage *)image status:(NSString *)title
{
    [self showImage:image status:title maskType:WSProgressHUDMaskTypeDefault];
}

+ (void)showImage:(UIImage *)image status:(NSString *)title maskType: (WSProgressHUDMaskType)maskType
{
//    [[self shareInstance] showImage:image title:title maskType:maskType];
    [self showImage:image status:title maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}


+ (void)showImage:(UIImage *)image status:(NSString *)title maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [[self shareInstance] addOverlayViewToWindow];
    [[self shareInstance] showImage:image status:title maskType:maskType maskWithout:withoutType];
}


#pragma mark - Only String
+ (void)showOnlyString: (NSString *)string
{
    [self showOnlyString:string maskType:WSProgressHUDMaskTypeDefault];
}

+ (void)showOnlyString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{
    [self showOnlyString:string maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}
+ (void)showOnlyString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [[self shareInstance] addOverlayViewToWindow];
    [[self shareInstance] showOnlyString:string maskType:maskType maskWithout:withoutType];
}


+ (void)dismiss {
    [[self shareInstance] dismiss];
}


#pragma mark - Show & dismiss method

- (void)show
{
    [self showWithMaskType:WSProgressHUDMaskTypeDefault];
}
- (void)showWithMaskType: (WSProgressHUDMaskType)maskType
{
    [self showWithMaskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}


- (void)showWithString: (NSString *)string
{
    [self showWithString:string maskType:WSProgressHUDMaskTypeDefault];
}
- (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{
    [self showWithString:string maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}


- (void)showOnlyString: (NSString *)string
{
    [self showOnlyString:string maskType:WSProgressHUDMaskTypeDefault];
}
- (void)showOnlyString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{
    [self showOnlyString:string maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}

- (void)showImage:(UIImage *)image status:(NSString *)title
{
    [self showImage:image status:title maskType:WSProgressHUDMaskTypeDefault];
}
- (void)showImage:(UIImage *)image status:(NSString *)title maskType: (WSProgressHUDMaskType)maskType
{
    [self showImage:image status:title maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}

- (void)showSuccessWithString: (NSString *)string
{
    [self showImage:WSProgressHUDSuccessImage status:string];
}
- (void)showErrorWithString: (NSString *)string
{
    [self showImage:WSProgressHUDErrorImage status:string];
}

- (void)showWithMaskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [self showWithString:nil maskType:maskType maskWithout:withoutType];
}


- (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeStatus), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(withoutType), @(withoutType), OBJC_ASSOCIATION_ASSIGN);
    
    [self invalidateTimer];
    
    [self setMaskEdgeWithType:self.maskType];
    
    self.labelView.text = string;
    
    [self updateSubviewsPositionWithString:string];
    
    [self showHudViewWithAnimation];
}


- (void)showOnlyString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeString), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(withoutType), @(withoutType), OBJC_ASSOCIATION_ASSIGN);
    
    [self invalidateTimer];
    
    [self setMaskEdgeWithType:self.maskType];

    if (string) {
        objc_setAssociatedObject(self, @selector(onlyShowTitle), @(1), OBJC_ASSOCIATION_ASSIGN);
        
        [self updateSubviewsPositionWithString:string];
        
        [self showHudViewWithAnimation];
        
    } else {
        [self showWithString:nil maskType:maskType maskWithout:withoutType];
    }
    
}


- (void)showImage:(UIImage *)image status:(NSString *)title maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(showImage), @(1), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeImage), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(withoutType), @(withoutType), OBJC_ASSOCIATION_ASSIGN);
    
    self.imageView.image = image;
    
    [self setMaskEdgeWithType:self.maskType];
    
    [self updateSubviewsPositionWithString:title];
    
    [self showHudViewWithAnimation];
    
    self.timer = [NSTimer timerWithTimeInterval:[self displayDurationForString:title] target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

}


#pragma mark - Pravite Method

- (void)showHudViewWithAnimation
{
    
    if (self.maskType != WSProgressHUDMaskTypeDefault) {
        self.overlayView.userInteractionEnabled = YES;
    } else {
        self.overlayView.userInteractionEnabled = NO;
    }
    if (self.hudView.alpha == 0) {
        
        self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.2, 1.2);
        [UIView animateWithDuration:WSProgressHUDShowDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.2, 1/1.2);
                             self.hudView.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             
                             objc_setAssociatedObject(self, @selector(hudIsShowing), @(1), OBJC_ASSOCIATION_ASSIGN);
                             
                             [self updateShimmingViewIfNeed];
                             
                             
                         }];
    } else {
        if ([UIView respondsToSelector:@selector(animateWithDuration:delay:usingSpringWithDamping:initialSpringVelocity:options:animations:completion:)]) {
            [UIView animateWithDuration:WSProgressHUDShowDuration
                                  delay:0
                 usingSpringWithDamping:0.8
                  initialSpringVelocity:1
                                options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut |UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self updateSubview];
            } completion:^(BOOL finished) {
                [self updateShimmingViewIfNeed];

            }];
        } else {
            [UIView animateWithDuration:WSProgressHUDShowDuration
                                  delay:0
                                options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState animations:^{
                                    
                                    [self updateSubview];
                                    
                                } completion:^(BOOL finished) {
                                    [self updateShimmingViewIfNeed];
                                }];
        }
    }
   
    [self setNeedsDisplay];
    
}


- (void)dismiss
{
    if (!self.hudIsShowing || self.hudView.alpha != 1) {
        return;
    }
    
    self.hudView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:WSProgressHUDDismissDuration
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.hudView.transform = CGAffineTransformScale(self.hudView.transform, .8, .8);
                         self.hudView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         self.hudView.transform = CGAffineTransformIdentity;
                         
                         [self.overlayView removeFromSuperview];
                         objc_setAssociatedObject(self, @selector(onlyShowTitle), @(0), OBJC_ASSOCIATION_ASSIGN);
                         objc_setAssociatedObject(self, @selector(showImage), @(0), OBJC_ASSOCIATION_ASSIGN);
                         objc_setAssociatedObject(self, @selector(hudIsShowing), @(0), OBJC_ASSOCIATION_ASSIGN);
                         
                         [self stopIndicatorAnimation];
                         
                         [self.timer invalidate];
                         self.timer = nil;
                         
                         WSProgressHUDNewBounds = CGRectZero;
                     }];
}


- (void)stopIndicatorAnimation {
    if (self.hudType == WSProgressHUDTypeString) {
        [self.shimmeringView setShimmering:NO];
    } else if (self.hudType == WSProgressHUDTypeStatus && self.indicatorStyle == WSProgressHUDIndicatorMMSpinner) {
        [self.spinnerView stopAnimating];
    }
}


- (void)addOverlayViewToWindow
{
    if(!self.overlayView.superview){
#if !defined(SV_APP_EXTENSIONS)
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
        }
#else
        if(SVProgressHUDExtensionView){
            [SVProgressHUDExtensionView addSubview:self.overlayView];
        }
#endif
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if (!self.superview) {
        [self.overlayView addSubview:self];
    }
}


- (void)updateSubviewsPositionWithString: (NSString *)string
{
    CGSize hudSize = [self hudSizeWithString:string];
    
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat centerY = self.frame.size.height / 2 - 20;
    CGRect hudBounds = CGRectMake(0, 0, hudSize.width, hudSize.height);
    if (self.hudIsShowing) {
        WSProgressHUDNewBounds = hudBounds;
        [self stopIndicatorAnimation];
    } else {
        self.hudView.bounds = hudBounds;
        self.labelView.frame = WSProgressHUDStringRect;//设置完hud的frame后需要重新设置
        self.hudView.center = CGPointMake(centerX, centerY);
        
        CGFloat hudCenterX = CGRectGetWidth(hudBounds)/2;
        CGFloat hudCenterY = CGRectGetHeight(hudBounds)/2;
        
        switch (self.hudType) {
            case WSProgressHUDTypeStatus: {
                
                [self startIndicatorAnimation:YES];
                
                if (string) {
                    self.labelView.frame = WSProgressHUDStringRect;//设置完hud的frame后需要重新设置
                    
                    self.spinnerView.center = self.indefiniteAnimationView.center = self.indicatorView.center = CGPointMake(15, hudCenterY);
                    self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY);
                    
                } else {
                    self.spinnerView.center = self.indefiniteAnimationView.center = self.indicatorView.center = CGPointMake(hudCenterX, hudCenterY);
                }
                
            }break;
                
            case WSProgressHUDTypeString: {
                self.shimmeringView.frame = WSProgressHUDStringRect;//设置完hud的frame后需要重新设置
                [self setShimmeringLabelSize:WSProgressHUDStringRect.size];
                
                self.shimmeringView.center = CGPointMake(hudCenterX, hudCenterY);
                [self startIndicatorAnimation:NO];
            }break;
                
            case WSProgressHUDTypeImage: {
                
                if (self.imageView.image) {
                    WSProgressHUDStringRect.origin.y = imageOffset;
                    [self startIndicatorAnimation:NO];
                    self.labelView.center = CGPointMake(hudCenterX , hudCenterY + 20);
                    self.imageView.center = CGPointMake(hudCenterX, 30);
                } else {
                    self.labelView.center = CGPointMake(hudCenterX, hudCenterY);
                }
                
            }break;
                
            default:
                break;
        }

    }
}

- (CGFloat)valueByScreenScale: (CGFloat)value
{
    return ([UIScreen mainScreen].bounds.size.width / 320 * value);
}

- (CGSize)hudSizeWithString: (NSString *)string
{
    
    WSProgressHUDStringRect = CGRectZero;
    
    WSProgressHUDDefaultHeight = 50;
    WSProgressHUDDefaultWidth = 50;
    UILabel *contentLabel = self.onlyShowTitle ? self.shimmeringLabel : self.labelView;
    CGSize constraintSize = CGSizeMake([self valueByScreenScale:200], [self valueByScreenScale:300]);
    
    // > iOS7
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        WSProgressHUDStringRect.size = [string boundingRectWithSize:constraintSize
                                                            options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                                         attributes:@{NSFontAttributeName: contentLabel.font}
                                                            context:NULL].size;
        
    } else {
        CGSize stringSize;
        if ([string respondsToSelector:@selector(sizeWithAttributes:)]){
            stringSize = [string sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:contentLabel.font.fontName size:contentLabel.font.pointSize]}];
        } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            stringSize = [string sizeWithFont:contentLabel.font constrainedToSize:constraintSize];
#pragma clang diagnostic pop
        }
        WSProgressHUDStringRect.size = stringSize;
    }
    
    stringWidth =  ceilf(WSProgressHUDStringRect.size.width);
    stringHeight = ceilf(WSProgressHUDStringRect.size.height);
    
    
    self.shimmeringView.hidden = YES;
    self.labelView.hidden = YES;
    self.imageView.hidden = YES;
    [self startIndicatorAnimation:NO];
    
    
    switch (self.hudType) {
        case WSProgressHUDTypeStatus: {
            if (string) {
                self.labelView.hidden = NO;
                self.labelView.text = string;
                WSProgressHUDDefaultWidth = stringWidth + 40; // indicationWidth = 40
                WSProgressHUDDefaultHeight = stringHeight + WSProgressHUDHeightEdgeOffset;
                [self exchangeIndicatorSizeToBig:NO];
            }  else {
                [self exchangeIndicatorSizeToBig:YES];
                self.shimmeringView.hidden = YES;
                self.labelView.hidden = YES;
            }
            
        } break;
            
        case WSProgressHUDTypeString: {
            WSProgressHUDDefaultWidth = stringWidth + WSProgressHUDWidthEdgeOffset; // indicationWidth = 40
            WSProgressHUDDefaultHeight = stringHeight + WSProgressHUDHeightEdgeOffset;
            
            self.shimmeringView.hidden = NO;
            self.shimmeringLabel.text = string;
            
        } break;
        case WSProgressHUDTypeImage: {
            
            self.labelView.hidden = NO;
            self.labelView.text = string;
            
            if (self.imageView.image) {
                
                WSProgressHUDDefaultHeight = stringHeight + imageOffset + WSProgressHUDHeightEdgeOffset;
                self.imageView.hidden = NO;
                
                WSProgressHUDDefaultWidth = stringWidth + WSProgressHUDImageTypeWidthEdgeOffset;
                
                WSProgressHUDDefaultWidth = WSProgressHUDDefaultWidth < 100 ? 120 : WSProgressHUDDefaultWidth + 10;
                
                WSProgressHUDDefaultHeight = WSProgressHUDDefaultHeight < 80 ? 100 : WSProgressHUDDefaultHeight + 10;
                
            } else {
                WSProgressHUDDefaultHeight = stringHeight + WSProgressHUDHeightEdgeOffset;
                WSProgressHUDDefaultWidth = stringWidth + WSProgressHUDImageTypeWidthEdgeOffset;
            }
            
        } break;
            
        default:
            break;
    }
    
    return CGSizeMake(WSProgressHUDDefaultWidth, WSProgressHUDDefaultHeight);
}


- (void)updateShimmingViewIfNeed
{
    if (self.hudType == WSProgressHUDTypeString) {
        [self.shimmeringView setShimmering:YES];
    } else {
        if (self.shimmeringView.shimmering) {
            [self.shimmeringView setShimmering:NO];
        }
    }
}

- (void)updateSubview
{
    self.hudView.bounds = WSProgressHUDNewBounds;
    
    CGFloat hudCenterX = CGRectGetWidth(self.hudView.bounds)/2;
    CGFloat hudCenterY = CGRectGetHeight(self.hudView.bounds)/2;
    
    switch (self.hudType) {
        case WSProgressHUDTypeStatus: {
            
            [self startIndicatorAnimation:YES];
            
            if (self.labelView.text) {
                self.labelView.frame = WSProgressHUDStringRect;//设置完hud的frame后需要重新设置
                
                self.spinnerView.center = self.indefiniteAnimationView.center = self.indicatorView.center = CGPointMake(15, hudCenterY);
                self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY);
                
            } else {
                self.spinnerView.center = self.indefiniteAnimationView.center = self.indicatorView.center = CGPointMake(hudCenterX, hudCenterY);
            }
            
        }break;
            
        case WSProgressHUDTypeString: {
            self.shimmeringView.frame = WSProgressHUDStringRect;//设置完hud的frame后需要重新设置
            [self setShimmeringLabelSize:WSProgressHUDStringRect.size];
            
            self.shimmeringView.center = CGPointMake(hudCenterX, hudCenterY);
            [self startIndicatorAnimation:NO];
            
        }break;
        case WSProgressHUDTypeImage: {
            self.labelView.frame = WSProgressHUDStringRect;//设置完hud的frame后需要重新设置
            if (self.imageView.image) {
                WSProgressHUDStringRect.origin.y = imageOffset;
                [self startIndicatorAnimation:NO];
                self.labelView.center = CGPointMake(hudCenterX , hudCenterY + 20);
                self.imageView.center = CGPointMake(hudCenterX, 30);
            } else {
                self.labelView.center = CGPointMake(hudCenterX, hudCenterY);
            }
        }break;
            
        default:
            break;
    }
}


- (void)exchangeIndicatorSizeToBig:(BOOL)big
{
    CGFloat size = big ? WSProgressHUDIndicatorBig : WSProgressHUDIndicatorSmall;
    self.indefiniteAnimationView.radius = size / 2;
    [self.indefiniteAnimationView sizeToFit];
    self.spinnerView.bounds = CGRectMake(0, 0, size, size);
}

- (void)startIndicatorAnimation: (BOOL)start
{
    switch (self.indicatorStyle) {
        case WSProgressHUDIndicatorSmallLight: {
            self.indefiniteAnimationView.hidden = YES;
            self.spinnerView.hidden = YES;
            if (start) {
                [self.indicatorView startAnimating];
            } else {
                [self.indicatorView stopAnimating];
            }
        }break;
        case WSProgressHUDIndicatorCustom: {
            [self.indicatorView stopAnimating];
            self.spinnerView.hidden = YES;
            self.indicatorView.hidden = YES;
            if (start) {
                self.indefiniteAnimationView.hidden = NO;
            } else {
                self.indefiniteAnimationView.hidden = YES;
            }
        }break;
        case WSProgressHUDIndicatorMMSpinner: {
            self.indicatorView.hidden = YES;
            self.indefiniteAnimationView.hidden = YES;
            if (start) {
                self.spinnerView.hidden = NO;
                [self.spinnerView startAnimating];
            } else {
                self.spinnerView.hidden = YES;
            }
        }break;
        default:
            break;
    }
}

- (void)setShimmeringLabelSize: (CGSize)size
{
    CGRect bounds = self.shimmeringLabel.bounds;
    bounds.size = size;
    self.shimmeringLabel.bounds = bounds;
}


- (void)setMaskEdgeWithType: (WSProgressHUDMaskType)maskType
{
    if (maskType != WSProgressHUDMaskTypeDefault) {
        switch (self.withoutType) {
            case WSProgressHUDMaskWithoutDefault: {
                maskBottomEdge = 0;
                maskTopEdge = 0;
                
            }break;
            case WSProgressHUDMaskWithoutNavigation: {
                maskBottomEdge = 0;
                maskTopEdge = 64; //判断StatusBarHidden
            }break;
            case WSProgressHUDMaskWithoutTabbar: {
                maskBottomEdge = 0;
                maskTopEdge = 64;
            }break;
            case WSProgressHUDMaskWithoutNavAndTabbar: {
                maskBottomEdge = 49;
                maskTopEdge = 64;
            }break;
                
            default:
                break;
        }
    } else {
        maskBottomEdge = 0;
        maskTopEdge = 0;
    }
    
    self.overlayView.frame = CGRectMake(0, maskTopEdge, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - maskTopEdge - maskBottomEdge);
    CGRect rect = self.frame;
    rect.size = self.overlayView.frame.size;
    self.frame = rect;
}



- (UIImage *)image:(UIImage *)image withTintColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


- (void)invalidateTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)setTimer:(NSTimer *)timer
{
    [self invalidateTimer];
    _timer = timer;
}

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    return MIN((float)string.length*0.06 + 0.5, 4.0);
}




- (CGFloat)visibleKeyboardHeight {
#if !defined(SV_APP_EXTENSIONS)
    UIWindow *keyboardWindow = nil;
    for (UIWindow *testWindow in [[UIApplication sharedApplication] windows]) {
        if(![[testWindow class] isEqual:[UIWindow class]]) {
            keyboardWindow = testWindow;
            break;
        }
    }
    
    for (__strong UIView *possibleKeyboard in [keyboardWindow subviews]) {
        if ([possibleKeyboard isKindOfClass:NSClassFromString(@"UIPeripheralHostView")] || [possibleKeyboard isKindOfClass:NSClassFromString(@"UIKeyboard")]) {
            return CGRectGetHeight(possibleKeyboard.bounds);
        } else if ([possibleKeyboard isKindOfClass:NSClassFromString(@"UIInputSetContainerView")]) {
            for (__strong UIView *possibleKeyboardSubview in [possibleKeyboard subviews]) {
                if ([possibleKeyboardSubview isKindOfClass:NSClassFromString(@"UIInputSetHostView")]) {
                    return CGRectGetHeight(possibleKeyboardSubview.bounds);
                }
            }
        }
    }
#endif
    return 0;
}

#pragma mark - Custom
+ (void)setProgressHUDIndicatorStyle: (WSProgressHUDIndicatorStyle)style {
    [[self shareInstance] setProgressHUDIndicatorStyle:style];
}

- (void)setProgressHUDIndicatorStyle: (WSProgressHUDIndicatorStyle)style {
    objc_setAssociatedObject(self, @selector(indicatorStyle), @(style), OBJC_ASSOCIATION_ASSIGN);
}


#pragma mark - Super Method
- (void)drawRect:(CGRect)rect
{
    switch (self.maskType) {
        case WSProgressHUDMaskTypeBlack: {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [[UIColor colorWithWhite:0 alpha:0.5] set];
            CGRect bounds = self.bounds;
            CGContextFillRect(context, bounds);
        } break;
        case WSProgressHUDMaskTypeGradient: {
            CGContextRef context = UIGraphicsGetCurrentContext();
            size_t locationCount = 2;
            CGFloat locations[2] = {0.0, 1.0};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.65f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationCount);
            
            CGColorSpaceRelease(colorSpace);
            
            CGRect bounds = self.bounds;
            
            CGFloat freeHeight = CGRectGetHeight(bounds) - self.visibleKeyboardHeight;
            
            CGPoint center = CGPointMake(CGRectGetWidth(bounds)/2, freeHeight/2);
            float radius = MIN(CGRectGetWidth(bounds) , CGRectGetHeight(bounds)) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
        } break;
            
        default:
            break;
    }
}


#pragma mark - Init View
- (instancetype)initWithView:(UIView *)view {
    return [self initWithFrame:view.bounds];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        WSProgressHUDForeGroundColor = [UIColor whiteColor];
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        NSURL *bundleUrl = [bundle URLForResource:@"WSProgressBundle" withExtension:@"bundle"];
        NSBundle *imageBundle = [NSBundle bundleWithURL:bundleUrl];
        
        UIImage *successImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"success@2x" ofType:@"png"]];
        UIImage *failurImage = [UIImage imageWithContentsOfFile:[imageBundle pathForResource:@"error@2x" ofType:@"png"]];
        
        if ([[UIImage class] instancesRespondToSelector:@selector(imageWithRenderingMode:)]) {
            WSProgressHUDSuccessImage = [successImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            WSProgressHUDErrorImage = [failurImage imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else {
            WSProgressHUDErrorImage = failurImage;
            WSProgressHUDSuccessImage = successImage;
        }
        
        [self addSubview:self.hudView];
        [self.hudView addSubview:self.indicatorView];
        [self.hudView addSubview:self.indefiniteAnimationView];
        [self.hudView addSubview:self.shimmeringView];
        [self.hudView addSubview:self.labelView];
        [self.hudView addSubview:self.imageView];
        [self.hudView addSubview:self.spinnerView];
        
        self.shimmeringView.contentView = self.shimmeringLabel;
        
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}


- (UIView *)hudView
{
    if (!_hudView) {
        _hudView = [[UIView alloc] init];
        _hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
        _hudView.layer.cornerRadius = 3.5;
        _hudView.layer.masksToBounds = YES;
        _hudView.alpha = 0;
        _hudView.contentScaleFactor = [UIScreen mainScreen].scale;
    }
    return _hudView;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    }
    return _indicatorView;
}

- (UILabel *)labelView
{
    if (!_labelView) {
        _labelView = [[UILabel alloc] initWithFrame:CGRectZero];
        _labelView.textColor = [UIColor whiteColor];
        
        if ([UIFont respondsToSelector:@selector(preferredFontForTextStyle:)]) {
            _labelView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        } else {
            _labelView.font = [UIFont systemFontOfSize:14];
        }
        _labelView.adjustsFontSizeToFitWidth = YES;
        _labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _labelView.textAlignment = NSTextAlignmentLeft;
        _labelView.numberOfLines = 0;
    }
    return _labelView;
}
- (FBShimmeringView *)shimmeringView
{
    if (!_shimmeringView) {
        _shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectZero];
        _shimmeringView.shimmeringBeginFadeDuration = 0.8;
        _shimmeringView.shimmeringSpeed = 100;
        _shimmeringView.shimmeringOpacity = 1;
        _shimmeringView.shimmeringAnimationOpacity = 0.3;
        _shimmeringView.layer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _shimmeringView;
}

- (UILabel *)shimmeringLabel {
    if (!_shimmeringLabel) {
        _shimmeringLabel = [[UILabel alloc] initWithFrame:self.shimmeringView.bounds];
        _shimmeringLabel.textColor = [UIColor whiteColor];
        if ([UIFont respondsToSelector:@selector(preferredFontForTextStyle:)]) {
            _shimmeringLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        } else {
            _shimmeringLabel.font = [UIFont systemFontOfSize:15];
        }
        _shimmeringLabel.contentScaleFactor = [UIScreen mainScreen].scale;
        _shimmeringLabel.adjustsFontSizeToFitWidth = YES;
        _shimmeringLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _shimmeringLabel.textAlignment = NSTextAlignmentLeft;
        _shimmeringLabel.numberOfLines = 0;
    }
    return _shimmeringLabel;
}

- (UIControl *)overlayView {
    if(!_overlayView) {
        CGRect windowBounds = [UIApplication sharedApplication].keyWindow.bounds;
        _overlayView = [[UIControl alloc] initWithFrame:windowBounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
//        [_overlayView addTarget:self action:@selector(overlayViewDidReceiveTouchEvent:forEvent:) forControlEvents:UIControlEventTouchDown];
    }
    return _overlayView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _imageView.hidden = YES;
        if ([_imageView respondsToSelector:@selector(setTintColor:)]) {
            [_imageView setTintColor:WSProgressHUDForeGroundColor];
        } else {
            
        }
    }
    return _imageView;
}

- (WSIndefiniteAnimationView *)indefiniteAnimationView
{
    if (!_indefiniteAnimationView) {
        _indefiniteAnimationView = [[WSIndefiniteAnimationView alloc] initWithFrame:CGRectZero];
        _indefiniteAnimationView.strokeColor = WSProgressHUDForeGroundColor;
        _indefiniteAnimationView.strokeThickness = WSProgressHUDRingThickness;
        _indefiniteAnimationView.radius = 10;
        [_indefiniteAnimationView sizeToFit];
    }
    return _indefiniteAnimationView;
}

- (MMMaterialDesignSpinner *)spinnerView
{
    if (!_spinnerView) {
        _spinnerView = [[MMMaterialDesignSpinner alloc] initWithFrame:CGRectZero];
        _spinnerView.bounds = CGRectMake(0, 0, 20, 20);
        _spinnerView.tintColor = WSProgressHUDForeGroundColor;
    }
    return _spinnerView;
}


- (BOOL)onlyShowTitle
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (BOOL)showImage
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (WSProgressHUDMaskType)maskType
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (WSProgressHUDType)hudType
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (WSProgressHUDMaskWithoutType)withoutType
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}

- (BOOL)hudIsShowing
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}
- (WSProgressHUDIndicatorStyle )indicatorStyle {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}



@end
