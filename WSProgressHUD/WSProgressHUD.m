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
    WSProgressHUDTypeProgress,
};

@interface WSProgressHUD ()

@property (nonatomic, strong) UIControl *overlayView;

@property (nonatomic, strong) UILabel *labelView;

@property (nonatomic, strong) UIView *hudView;

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) FBShimmeringView *shimmeringView;

@property (nonatomic, strong) UILabel *shimmeringLabel;

@property (nonatomic, strong) CAShapeLayer *backgroundRingLayer;

@property (nonatomic, strong) CAShapeLayer *ringLayer;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) WSIndefiniteAnimationView *indefiniteAnimationView;

@property (nonatomic, strong) MMMaterialDesignSpinner *spinnerView;

@property (nonatomic, assign) CGFloat progress;

@property (nonatomic, copy) NSString *currentString;


@property (nonatomic) BOOL isRotate;

@property (nonatomic) BOOL isTempIndicatorStyle;

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
static UIColor *WSProgressHUDBackGroundColor;

static UIImage *WSProgressHUDSuccessImage;
static UIImage *WSProgressHUDErrorImage;

static CGFloat const WSProgressHUDIndicatorBig = 31;
static CGFloat const WSProgressHUDIndicatorSmall = 20;

static CGFloat WSProgressHUDRingThickness = 2;
static CGFloat WSProgressHUDShowDuration = 0.3;
static CGFloat WSProgressHUDDismissDuration = 0.15;
static CGFloat const WSProgressHUDWidthEdgeOffset = 10;
static CGFloat const WSProgressHUDHeightEdgeOffset = 8;
static CGFloat const WSProgressHUDImageTypeWidthEdgeOffset = 16;


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
+ (void)showWithStatus:(NSString *)string
{
    [self showWithStatus:string maskType:WSProgressHUDMaskTypeDefault];
}

+ (void)showWithStatus: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{
    [self showWithStatus:string maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}

+ (void)showWithStatus: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [[self shareInstance] addOverlayViewToWindow];
    [[self shareInstance] showWithString:string maskType:maskType maskWithout:withoutType];
}


#pragma mark - Show image

+ (void)showSuccessWithStatus: (NSString *)string
{
    [self showImage:WSProgressHUDSuccessDefaultImage() status:string];
}

+ (void)showErrorWithStatus: (NSString *)string
{
    [self showImage:WSProgressHUDErrorDefaultImage() status:string];
}


+ (void)showImage:(UIImage *)image status:(NSString *)title
{
    [self showImage:image status:title maskType:WSProgressHUDMaskTypeDefault];
}

+ (void)showImage:(UIImage *)image status:(NSString *)title maskType: (WSProgressHUDMaskType)maskType
{
    [self showImage:image status:title maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}


+ (void)showImage:(UIImage *)image status:(NSString *)title maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [[self shareInstance] addOverlayViewToWindow];
    [[self shareInstance] showImage:image status:title maskType:maskType maskWithout:withoutType];
}

#pragma mark - Progress

+ (void)showProgress:(CGFloat)progress
{
    [self showProgress:progress maskType:WSProgressHUDMaskTypeDefault];
}
+ (void)showProgress:(CGFloat)progress maskType:(WSProgressHUDMaskType)maskType
{
    [self showProgress:progress maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}
+ (void)showProgress:(CGFloat)progress maskType:(WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [[self shareInstance] addOverlayViewToWindow];
    [[self shareInstance] showProgress:progress status:nil maskType:maskType maskWithout:withoutType];
}

+ (void)showProgress:(CGFloat)progress status:(NSString*)string
{
    [self showProgress:progress status:string maskType:WSProgressHUDMaskTypeDefault];
}
+ (void)showProgress:(CGFloat)progress status:(NSString*)string maskType:(WSProgressHUDMaskType)maskType
{
    [self showProgress:progress status:string maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}
+ (void)showProgress:(CGFloat)progress status:(NSString*)string maskType:(WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [[self shareInstance] addOverlayViewToWindow];
    [[self shareInstance] showProgress:progress status:string maskType:maskType maskWithout:withoutType];
}


#pragma mark - Shimmering String
+ (void)showShimmeringString: (NSString *)string
{
    [self showShimmeringString:string maskType:WSProgressHUDMaskTypeDefault];
}

+ (void)showShimmeringString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{
    [self showShimmeringString:string maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}
+ (void)showShimmeringString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [[self shareInstance] addOverlayViewToWindow];
    [[self shareInstance] showShimmeringString:string maskType:maskType maskWithout:withoutType];
}


+ (void)dismiss {
    [[self shareInstance] dismiss];
}


#pragma mark - Instance method

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


#pragma mark - OnlyString
- (void)showShimmeringString: (NSString *)string
{
    [self showShimmeringString:string maskType:WSProgressHUDMaskTypeDefault];
}
- (void)showShimmeringString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{
    [self showShimmeringString:string maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}

#pragma mark - Progress
- (void)showProgress:(CGFloat)progress
{
    [self showProgress:progress maskType:WSProgressHUDMaskTypeDefault];
}
- (void)showProgress:(CGFloat)progress maskType:(WSProgressHUDMaskType)maskType
{
    [self showProgress:progress maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}
- (void)showProgress:(CGFloat)progress maskType:(WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [self showProgress:progress status:nil maskType:maskType maskWithout:withoutType];
}


- (void)showProgress:(CGFloat)progress status:(NSString*)string
{
    [self showProgress:progress status:string maskType:WSProgressHUDMaskTypeDefault];
}
- (void)showProgress:(CGFloat)progress status:(NSString*)string maskType:(WSProgressHUDMaskType)maskType
{
    [self showProgress:progress status:string maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
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
    [self showImage:WSProgressHUDSuccessDefaultImage() status:string];
}
- (void)showErrorWithString: (NSString *)string
{
    [self showImage:WSProgressHUDErrorDefaultImage() status:string];
}

- (void)showWithMaskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [self showWithString:nil maskType:maskType maskWithout:withoutType];
}


- (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    NSAssert([NSThread isMainThread], @"WSProgressHUD show Must on main thread");
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeStatus), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(withoutType), @(withoutType), OBJC_ASSOCIATION_ASSIGN);
    
    [self invalidateTimer];
    
    [self setMaskEdgeWithType:self.maskType];
    
    self.currentString = string;

    [self updateSubviewsPosition];
    
    [self showHudViewWithAnimation];
}


- (void)showShimmeringString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    NSAssert([NSThread isMainThread], @"WSProgressHUD show Must on main thread");
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeString), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(withoutType), @(withoutType), OBJC_ASSOCIATION_ASSIGN);
    
    [self invalidateTimer];
    
    [self setMaskEdgeWithType:self.maskType];
    
    self.currentString = string;
    if (string) {
        objc_setAssociatedObject(self, @selector(onlyShowTitle), @(1), OBJC_ASSOCIATION_ASSIGN);
        
        [self updateSubviewsPosition];
        
        [self showHudViewWithAnimation];
        
    } else {
        [self showWithString:nil maskType:maskType maskWithout:withoutType];
    }
    
}

- (void)showProgress:(CGFloat)progress status:(NSString*)string maskType:(WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    NSAssert([NSThread isMainThread], @"WSProgressHUD show Must on main thread");
    if (self.hudIsShowing && self.hudType == WSProgressHUDTypeProgress) {
        self.ringLayer.strokeEnd = progress;
        return;
    }
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeProgress), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(withoutType), @(withoutType), OBJC_ASSOCIATION_ASSIGN);
    
    [self invalidateTimer];
    
    [self setMaskEdgeWithType:self.maskType];

    self.currentString = string;

    [self updateSubviewsPosition];
    
    [self showHudViewWithAnimation];
    
}


- (void)showImage:(UIImage *)image status:(NSString *)title maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    NSAssert([NSThread isMainThread], @"WSProgressHUD show Must on main thread");
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(showImage), @(1), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeImage), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(withoutType), @(withoutType), OBJC_ASSOCIATION_ASSIGN);
    
    self.imageView.image = image;
    
    [self setMaskEdgeWithType:self.maskType];
    
    self.currentString = title;

    [self updateSubviewsPosition];
    
    [self showHudViewWithAnimation];

    self.timer = [NSTimer timerWithTimeInterval:[self displayDurationForString:title] target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}


#pragma mark - Pravite Method

- (void)showHudViewWithAnimation
{

    if (self.maskType != WSProgressHUDMaskTypeDefault) {
        if (self.showOnTheWindow) {
            self.overlayView.userInteractionEnabled = YES;
        } else {
            self.userInteractionEnabled = YES;
        }
    } else {
        if (self.showOnTheWindow) {
            self.overlayView.userInteractionEnabled = NO;
        } else {
            self.userInteractionEnabled = NO;
        }
    }
    if (self.hudView.alpha == 0) {
    
        objc_setAssociatedObject(self, @selector(hudIsShowing), @(1), OBJC_ASSOCIATION_ASSIGN);
        self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.2, 1.2);

        [UIView animateWithDuration:WSProgressHUDShowDuration
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.2, 1/1.2);
                             self.hudView.alpha = 1;
                         }
                         completion:^(BOOL finished){
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
    [self invalidateTimer];
    objc_setAssociatedObject(self, @selector(onlyShowTitle), @(0), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(showImage), @(0), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudIsShowing), @(0), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(maskType), WSProgressHUDMaskTypeDefault, OBJC_ASSOCIATION_ASSIGN);
    WSProgressHUDNewBounds = CGRectZero;

    self.hudView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:WSProgressHUDDismissDuration
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut
                     animations:^{
                         self.hudView.transform = CGAffineTransformScale(self.hudView.transform, .8, .8);
                         self.hudView.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         self.hudView.transform = CGAffineTransformIdentity;
                         
                         [self.overlayView removeFromSuperview];
                         
                         self.userInteractionEnabled = NO;
                         
                         [self stopIndicatorAnimation];
                         
                         //Call drawInRact
                         [self setNeedsDisplay];
                         
                         [self setProgressHUDIndicatorStyle:self.indicatorStyle];
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
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if (!self.superview) {
        [self.overlayView addSubview:self];
    }
    
    objc_setAssociatedObject(self, @selector(showOnTheWindow), @(1), OBJC_ASSOCIATION_ASSIGN);
}


- (void)updateSubviewsPosition
{
    NSString *string = self.currentString;
    
    CGSize hudSize = [self hudSizeWithString:string];
    CGRect hudBounds = CGRectMake(0, 0, hudSize.width, hudSize.height);
    
    if (self.hudIsShowing) {
        if (self.isRotate) {
            [self updatePositionWithString:string hudBounds:hudBounds];
            self.isRotate = NO;
        } else {
            WSProgressHUDNewBounds = hudBounds;
            [self stopIndicatorAnimation];
        }
    } else {
        [self updatePositionWithString:string hudBounds:hudBounds];
    }
}

- (void)updatePositionWithString: (NSString *)string hudBounds: (CGRect)bounds
{
    CGFloat centerX = self.bounds.size.width / 2;
    CGFloat centerY = self.bounds.size.height / 2 - 20;
    
    self.hudView.bounds = bounds;
    self.labelView.frame = WSProgressHUDStringRect;//Reset the view frame
    self.hudView.center = CGPointMake(centerX, centerY);
    self.hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
    
    CGFloat hudCenterX = CGRectGetWidth(bounds)/2;
    CGFloat hudCenterY = CGRectGetHeight(bounds)/2;
    
    switch (self.hudType) {
        case WSProgressHUDTypeStatus: {
            
            [self startIndicatorAnimation:YES];
            
            if (string) {

                if (self.indicatorStyle == WSProgressHUDIndicatorGray ||
                    self.indicatorStyle == WSProgressHUDIndicatorBigGray ||
                    [self secondProrityIndicatorStyle] == WSProgressHUDIndicatorGray) { //如果第二优先级的是gray
//                    if ([self secondProrityIndicatorStyle] == WSProgressHUDIndicatorGray) {
//                    }
                    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite; //设置为白色
                }

                self.labelView.frame = WSProgressHUDStringRect;
                self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY);
                self.spinnerView.center = self.indefiniteAnimationView.center = self.indicatorView.center = CGPointMake(15, hudCenterY);
                
            } else {
                
                if (self.indicatorStyle == WSProgressHUDIndicatorGray  ||
                    self.indicatorStyle == WSProgressHUDIndicatorBigGray ) {
                    
                    self.hudView.backgroundColor = [UIColor clearColor];
                    
                    if (self.maskType == WSProgressHUDMaskTypeBlack || self.maskType == WSProgressHUDMaskTypeGradient) {
                        self.indicatorView.color = [UIColor whiteColor];
                    } else {
                        self.indicatorView.color = [UIColor grayColor];
                    }
                }
                self.spinnerView.center = self.indefiniteAnimationView.center = self.indicatorView.center = CGPointMake(hudCenterX, hudCenterY);
            }
            
        }break;
            
        case WSProgressHUDTypeString: {
            self.labelView.frame = WSProgressHUDStringRect;
            
            self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY);
            
            self.shimmeringView.frame = WSProgressHUDStringRect;
            [self setShimmeringLabelSize:WSProgressHUDStringRect.size];
            
            self.shimmeringView.center = CGPointMake(hudCenterX, hudCenterY);
            [self startIndicatorAnimation:NO];
        }break;
            
        case WSProgressHUDTypeProgress: {
            if (string) {
                self.ringLayer.position = self.backgroundRingLayer.position = CGPointMake(15, hudCenterY);
                self.labelView.frame = WSProgressHUDStringRect;
                self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY);
            } else {
                self.ringLayer.position = self.backgroundRingLayer.position = CGPointMake(hudCenterX, hudCenterY);
            }
            
        }break;
        case WSProgressHUDTypeImage: {
            
            if (self.imageView.image) {
                WSProgressHUDStringRect.origin.y = imageOffset;
                [self startIndicatorAnimation:NO];
                self.labelView.center = CGPointMake(hudCenterX , hudCenterY + 20);
                self.labelView.textAlignment = NSTextAlignmentCenter;
                self.imageView.center = CGPointMake(hudCenterX, 30);
            } else {
                self.labelView.text = string;
                self.labelView.center = CGPointMake(hudCenterX, hudCenterY);
            }
            
        }break;
            
        default:
            break;
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
    self.ringLayer.hidden = YES;
    self.backgroundRingLayer.hidden = YES;
    [self startIndicatorAnimation:NO];
    
    
    switch (self.hudType) {
        case WSProgressHUDTypeStatus: {
            self.labelView.text = string;
            if (string) {
                self.labelView.hidden = NO;
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
        case WSProgressHUDTypeProgress: {
            
            self.ringLayer.hidden = NO;
            self.backgroundRingLayer.hidden = NO;
            self.labelView.text = string;
            if (string) {
                self.labelView.hidden = NO;
                WSProgressHUDDefaultWidth = stringWidth + 40; // indicationWidth = 40
                WSProgressHUDDefaultHeight = stringHeight + WSProgressHUDHeightEdgeOffset;
                [self exchangeIndicatorSizeToBig:NO];
            }  else {
                [self exchangeIndicatorSizeToBig:YES];
            }
            
        }break;
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
        self.shimmeringView.shimmeringSpeed = [self shimmingSpeedWithString:self.shimmeringLabel.text];
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
    self.hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];

    CGFloat hudCenterX = CGRectGetWidth(self.hudView.bounds)/2;
    CGFloat hudCenterY = CGRectGetHeight(self.hudView.bounds)/2;
    
    switch (self.hudType) {
        case WSProgressHUDTypeStatus: {
            
            
            if (self.labelView.text) {
                if (self.indicatorStyle == WSProgressHUDIndicatorGray ||
                    self.indicatorStyle == WSProgressHUDIndicatorBigGray ||
                    [self secondProrityIndicatorStyle] == WSProgressHUDIndicatorGray) {
                    
                    self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
                }

                self.labelView.frame = WSProgressHUDStringRect;
                self.spinnerView.center = self.indefiniteAnimationView.center = self.indicatorView.center = CGPointMake(15, hudCenterY);
                self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY);
                
            } else {
                if (self.indicatorStyle == WSProgressHUDIndicatorGray  ||
                    self.indicatorStyle == WSProgressHUDIndicatorBigGray ) {
                    self.hudView.backgroundColor = [UIColor clearColor];
                    if (self.maskType == WSProgressHUDMaskTypeBlack || self.maskType == WSProgressHUDMaskTypeGradient) {
                        self.indicatorView.color = [UIColor whiteColor];
                    } else {
                        self.indicatorView.color = [UIColor grayColor];
                    }
                }
                self.spinnerView.center = self.indefiniteAnimationView.center = self.indicatorView.center = CGPointMake(hudCenterX, hudCenterY);
            }
            
            [self startIndicatorAnimation:YES];
            
        }break;
            
        case WSProgressHUDTypeString: {
            self.shimmeringView.frame = WSProgressHUDStringRect;
            [self setShimmeringLabelSize:WSProgressHUDStringRect.size];
            
            self.shimmeringView.center = CGPointMake(hudCenterX, hudCenterY);
            [self startIndicatorAnimation:NO];
            
        }break;
        case WSProgressHUDTypeProgress: {
            if (self.labelView.text) {
                self.labelView.frame = WSProgressHUDStringRect;
                self.ringLayer.position = self.backgroundRingLayer.position = CGPointMake(15, hudCenterY);
                self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY);
            } else {
                self.ringLayer.position = self.backgroundRingLayer.position = CGPointMake(hudCenterX, hudCenterY);
            }
        }break;
        case WSProgressHUDTypeImage: {
            self.labelView.frame = WSProgressHUDStringRect;
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

    CGPoint center = CGPointMake(CGRectGetWidth(self.hudView.frame)/2, CGRectGetHeight(self.hudView.frame)/2);
    
    if (self.hudType == WSProgressHUDTypeProgress) {
        //ProgressLayer
        {
            [self.ringLayer removeFromSuperlayer];
            [self.backgroundRingLayer removeFromSuperlayer];
            
            self.ringLayer = [self createRingLayerWithCenter:center radius:size/2 lineWidth:1 color:WSProgressHUDForeGroundDefaultColor()];
            self.backgroundRingLayer = [self createRingLayerWithCenter:center radius:size/2 lineWidth:1 color:WSProgressHUDBackGroundDefaultColor()];
            self.ringLayer.strokeEnd = 0;
            self.backgroundRingLayer.strokeEnd = 1;
            [self.hudView.layer addSublayer:self.backgroundRingLayer];
            [self.hudView.layer addSublayer:self.ringLayer];
        }
    }
    
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
        case WSProgressHUDIndicatorGray: {
            
            self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            
            self.indefiniteAnimationView.hidden = YES;
            self.spinnerView.hidden = YES;
            if (start) {
                [self.indicatorView startAnimating];
            } else {
                [self.indicatorView stopAnimating];
            }
        }break;
        case WSProgressHUDIndicatorBigGray: {
            
            if (self.labelView.text) {
                [self startSecondProrityIndicatorAnimation:start];
            } else {
                self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
                self.indefiniteAnimationView.hidden = YES;
                self.spinnerView.hidden = YES;
                if (start) {
                    [self.indicatorView startAnimating];
                } else {
                    [self.indicatorView stopAnimating];
                }
            }
        }break;

        default:
            break;
    }
}

- (void)startSecondProrityIndicatorAnimation: (BOOL)start
{
    switch ([self secondProrityIndicatorStyle]) {
            
        case WSProgressHUDIndicatorSmallLight: {
            self.indefiniteAnimationView.hidden = YES;
            self.spinnerView.hidden = YES;
            if (start) {
                [self.indicatorView startAnimating];
            } else {
                [self.indicatorView stopAnimating];
            }
        }break;
            
        case WSProgressHUDIndicatorBigGray:
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
        case WSProgressHUDIndicatorGray: {
            
            self.indicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            
            self.indefiniteAnimationView.hidden = YES;
            self.spinnerView.hidden = YES;
            if (start) {
                [self.indicatorView startAnimating];
            } else {
                [self.indicatorView stopAnimating];
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
                maskTopEdge = [self maskTopEdge];
            }break;
            case WSProgressHUDMaskWithoutTabbar: {
                maskBottomEdge = 49;
                maskTopEdge = 0;
            }break;
            case WSProgressHUDMaskWithoutNavAndTabbar: {
                maskBottomEdge = 49;
                maskTopEdge = [self maskTopEdge];
            }break;
                
            default:
                break;
        }
    } else {
        maskBottomEdge = 0;
        maskTopEdge = 0;
    }
    
    self.overlayView.frame = CGRectMake(0, maskTopEdge, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - maskTopEdge - maskBottomEdge);
    if (self.showOnTheWindow) {
        CGRect rect = self.bounds;
        rect.size = self.overlayView.frame.size;
        self.bounds = rect;
    }
}

- (void)invalidateTimer
{
    if (self.timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)setTimer:(NSTimer *)timer
{
    [self invalidateTimer];
    if (timer) {
        _timer = timer;
    }
}

- (NSTimeInterval)displayDurationForString:(NSString*)string {
    CGFloat duration = MIN((CGFloat)string.length*0.06 + 0.5, 5.0);
    if (duration < 1.0) {
        duration = 1.0;
    }
    return duration;
}


- (CGFloat)shimmingSpeedWithString: (NSString *)string
{
    return string.length > 10 ? 100 : 50;
}


- (CGFloat)visibleKeyboardHeight {
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
    return 0;
}

- (CAShapeLayer *)createRingLayerWithCenter:(CGPoint)center radius:(CGFloat)radius lineWidth:(CGFloat)lineWidth color:(UIColor *)color {
    
    UIBezierPath* smoothedPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(radius, radius) radius:radius startAngle:-M_PI_2 endAngle:(M_PI + M_PI_2) clockwise:YES];
    
    CAShapeLayer *slice = [CAShapeLayer layer];
    slice.contentsScale = [[UIScreen mainScreen] scale];
    slice.frame = CGRectMake(center.x-radius, center.y-radius, radius*2, radius*2);
    slice.fillColor = [UIColor clearColor].CGColor;
    slice.strokeColor = color.CGColor;
    slice.lineWidth = lineWidth;
    slice.lineCap = kCALineCapRound;
    slice.lineJoin = kCALineJoinBevel;
    slice.path = smoothedPath.CGPath;
    
    return slice;
}

- (CGFloat)maskTopEdge
{
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        return 32;
    } else {
        return 64;
    }
}


#pragma mark - Custom
+ (void)setProgressHUDIndicatorStyle: (WSProgressHUDIndicatorStyle)style {
    [[self shareInstance] setProgressHUDIndicatorStyle:style];
}

/// if you set WSProgressHUDIndicatorBigGray style you should set second prority indicator Style ->no use
+ (void)setSecondProrityIndicatorStyle:(WSProgressHUDIndicatorStyle)style
{
    [[self shareInstance] setSecondProrityIndicatorStyle:style];
}

+ (void)setProgressHUDFont: (UIFont *)font
{
    [[self shareInstance] setProgressHUDFont:font];
}

- (void)setProgressHUDFont: (UIFont *)font
{
    self.labelView.font = self.shimmeringLabel.font = font;
}



- (void)setProgressHUDIndicatorStyle: (WSProgressHUDIndicatorStyle)style {
    objc_setAssociatedObject(self, @selector(indicatorStyle), @(style), OBJC_ASSOCIATION_ASSIGN);
}

/// if you set WSProgressHUDIndicatorBigGray style you should set second prority indicator Style ->no use
- (void)setSecondProrityIndicatorStyle:(WSProgressHUDIndicatorStyle)style
{
    objc_setAssociatedObject(self, @selector(secondProrityIndicatorStyle), @(style), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - Draw rect
- (void)drawRect:(CGRect)rect
{
    switch (self.maskType) {
        case WSProgressHUDMaskTypeClear: {
            CGContextRef context = UIGraphicsGetCurrentContext();
			[[UIColor clearColor] set];
            CGRect bounds = self.bounds;
            CGContextFillRect(context, bounds);
        }break;
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
            
        default: {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [[UIColor colorWithWhite:0 alpha:0] set];
            CGRect bounds = self.bounds;
            CGContextFillRect(context, bounds);
        }break;
    }
}

#pragma mark - Observe

- (void)registerOrientationDidChangeObserve
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(statusBarOrientationDidChange:) name:UIApplicationDidChangeStatusBarOrientationNotification object:nil];
    
}

- (void)statusBarOrientationDidChange: (NSNotification *)notification {
    if (self.superview) {
        self.bounds = self.superview.bounds;
        
        if (self.hudIsShowing) {
            //更新Frame
            self.isRotate = YES;
            
            [self setMaskEdgeWithType:self.maskType];
            
            [self updateSubviewsPosition];
            
            [self setNeedsDisplay];
        }
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
        
        self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin        | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
        
        [self registerOrientationDidChangeObserve];
    }
    return self;
}

#pragma mark - INLine Utils Method

CG_INLINE UIColor * WSProgressHUDForeGroundDefaultColor()
{
    if (WSProgressHUDForeGroundColor == nil) {
        WSProgressHUDForeGroundColor = [UIColor whiteColor];
    }
    return WSProgressHUDForeGroundColor;
}

CG_INLINE UIColor * WSProgressHUDBackGroundDefaultColor()
{
    if (WSProgressHUDBackGroundColor == nil) {
        WSProgressHUDBackGroundColor = [UIColor colorWithWhite:0.3 alpha:1];
    }
    return WSProgressHUDBackGroundColor;
}


CG_INLINE UIImage * WSProgressHUDImageWithName(NSString *imageName, NSString *imageType)
{
    NSBundle *bundle = [NSBundle bundleForClass:[WSProgressHUD class]];
    NSURL *bundleUrl = [bundle URLForResource:@"WSProgressBundle" withExtension:@"bundle"];
    NSBundle *defaultBundle = [NSBundle bundleWithURL:bundleUrl];
    return [UIImage imageWithContentsOfFile:[defaultBundle pathForResource:imageName ofType:imageType]];
}

CG_INLINE UIImage * WSProgressHUDSuccessDefaultImage()
{
    if (WSProgressHUDSuccessImage == nil) {
        UIImage *successImage = WSProgressHUDImageWithName(@"success@2x", @"png");
        WSProgressHUDSuccessImage = WSImageByAddTintColr(successImage, WSProgressHUDForeGroundDefaultColor());
    }
    return WSProgressHUDSuccessImage;
}

CG_INLINE UIImage * WSProgressHUDErrorDefaultImage()
{
    if (WSProgressHUDErrorImage == nil) {
        UIImage *failurImage = WSProgressHUDImageWithName(@"error@2x", @"png");
        WSProgressHUDErrorImage = WSImageByAddTintColr(failurImage, WSProgressHUDForeGroundDefaultColor());
    }
    return WSProgressHUDErrorImage;
}


CG_INLINE UIImage * WSImageByAddTintColr(UIImage *image, UIColor *color)
{
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
        _labelView.backgroundColor = [UIColor clearColor];
        if ([UIFont respondsToSelector:@selector(preferredFontForTextStyle:)]) {
            _labelView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
        } else {
            _labelView.font = [UIFont systemFontOfSize:14];
        }
        _labelView.adjustsFontSizeToFitWidth = YES;
        _labelView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _labelView.textAlignment = NSTextAlignmentCenter;
        _labelView.numberOfLines = 0;
    }
    return _labelView;
}
- (FBShimmeringView *)shimmeringView
{
    if (!_shimmeringView) {
        _shimmeringView = [[FBShimmeringView alloc] initWithFrame:CGRectZero];
        _shimmeringView.shimmeringBeginFadeDuration = WSProgressHUDShowDuration;
        _shimmeringView.shimmeringSpeed = 50;
        _shimmeringView.shimmeringOpacity = 1;
        _shimmeringView.shimmeringAnimationOpacity = 0.3;
        _shimmeringView.layer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _shimmeringView;
}

- (UILabel *)shimmeringLabel {
    if (!_shimmeringLabel) {
        _shimmeringLabel = [[UILabel alloc] initWithFrame:self.shimmeringView.bounds];
        _shimmeringLabel.backgroundColor = [UIColor clearColor];
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
    }
    return _overlayView;
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
        _imageView.hidden = YES;
    }
    return _imageView;
}

- (WSIndefiniteAnimationView *)indefiniteAnimationView
{
    if (!_indefiniteAnimationView) {
        _indefiniteAnimationView = [[WSIndefiniteAnimationView alloc] initWithFrame:CGRectZero];
        _indefiniteAnimationView.strokeColor = WSProgressHUDForeGroundDefaultColor();
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
        [_spinnerView setSpinnerColor:[UIColor whiteColor]];
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
- (WSProgressHUDIndicatorStyle)indicatorStyle {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}
- (BOOL)showOnTheWindow
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (WSProgressHUDIndicatorStyle)secondProrityIndicatorStyle
{
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
