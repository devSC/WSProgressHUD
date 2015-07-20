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
//#import "WSIndefiniteAnimationView.h"

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

//@property (strong, nonatomic) WSIndefiniteAnimationView *indefiniteAnimatedView;


@end

//static 为静态全局变量
//const 为全局常量
//static const CGFloat WSProgressHUDRingRadius = 10;
//static const CGFloat WSProgressHUDRingNoTextRadius = 17;

static CGFloat hudWidth = 50;
static CGFloat hudHeight = 50;

static CGFloat stringWidth = 0.0f;
static CGFloat stringHeight = 0.0f;

static CGFloat const edgeOffset = 10;
static CGFloat const imageOffset = 40;

static CGRect stringRect;

@implementation WSProgressHUD
{
    WSProgressHUDMaskType _maskType;
    BOOL _onlyShowString;
}

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
+ (WSProgressHUD *)shareInstance {
    static dispatch_once_t once;
    static WSProgressHUD *shareView;
    dispatch_once(&once, ^{
        shareView = [[self alloc] initWithFrame:[UIApplication sharedApplication].keyWindow.bounds];

    });
    return shareView;
}


+ (void)show {
    [self showWithMaskType:WSProgressHUDMaskTypeDefault];
}


+ (void)showWithMaskType: (WSProgressHUDMaskType)maskType
{
    [[self shareInstance] showWithMaskType:maskType];
}



+ (void)showWithString:(NSString *)string
{
    [self showWithString:string maskType:WSProgressHUDMaskTypeDefault];
}

+ (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{
    [[self shareInstance] showWithString:string maskType:maskType];
}



+ (void)showImage:(UIImage *)image title:(NSString *)title
{
    [self showImage:image title:title maskType:WSProgressHUDMaskTypeDefault];
}

+ (void)showImage:(UIImage *)image title:(NSString *)title maskType: (WSProgressHUDMaskType)maskType
{
    [[self shareInstance] showImage:image title:title maskType:maskType];
}


+ (void)showOnlyString: (NSString *)string
{
    [self showOnlyString:string maskType:WSProgressHUDMaskTypeDefault];
}

+ (void)showOnlyString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{
    [[self shareInstance] showOnlyString:string maskType:maskType];
}

+ (void)dismiss {
    [[self shareInstance] dismiss];
}


#pragma mark - Show method
- (void)dismiss
{
    self.hudView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.hudView.transform = CGAffineTransformScale(self.hudView.transform, .8, .8);
                         
                         //                         if(self.isClear) // handle iOS 7 and 8 UIToolbar which not answers well to hierarchy opacity change
                         self.hudView.alpha = 0;
                         //                         else
                         //                             self.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         self.hudView.transform = CGAffineTransformIdentity;
                        [self.overlayView removeFromSuperview];
                         
                         objc_setAssociatedObject(self, @selector(onlyShowTitle), @(0), OBJC_ASSOCIATION_ASSIGN);
                         objc_setAssociatedObject(self, @selector(showImage), @(0), OBJC_ASSOCIATION_ASSIGN);
                         
                         
                     }];
}

- (void)showWithString:(NSString *)string
{
    [self showWithString:string maskType:WSProgressHUDMaskTypeDefault];
}

- (void)showWithMaskType: (WSProgressHUDMaskType)maskType
{
    [self showWithString:nil maskType:maskType];
}


- (void)showImage:(UIImage *)image title:(NSString *)title
{
   
    [self showImage:image title:title maskType:WSProgressHUDMaskTypeDefault];
}



- (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeStatus), OBJC_ASSOCIATION_ASSIGN);
    
    [self addOverlayViewToWindow];
    
    self.labelView.text = string;
    
    [self updateSubviewsPositionWithString:string];
    
    [self showHUDViewWithAnimation];
}



- (void)showOnlyString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{

    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeString), OBJC_ASSOCIATION_ASSIGN);
    
    if (string) {
        objc_setAssociatedObject(self, @selector(onlyShowTitle), @(1), OBJC_ASSOCIATION_ASSIGN);
        [self addOverlayViewToWindow];
        
        [self updateSubviewsPositionWithString:string];
        
        [self showHUDViewWithAnimation];
        
    } else {
        [self showWithString:nil];
    }
}



- (void)showImage:(UIImage *)image title:(NSString *)title maskType: (WSProgressHUDMaskType)maskType
{
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    
    objc_setAssociatedObject(self, @selector(showImage), @(1), OBJC_ASSOCIATION_ASSIGN);
    
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeImage), OBJC_ASSOCIATION_ASSIGN);
    
    self.imageView.image = image;
    
    [self addOverlayViewToWindow];
    
    [self updateSubviewsPositionWithString:title];
    
    [self showHUDViewWithAnimation];
}


#pragma mark - Super Method
- (void)drawRect:(CGRect)rect
{
    switch (self.maskType) {
        case WSProgressHUDMaskTypeBlack: {
            CGContextRef context = UIGraphicsGetCurrentContext();
            [UIColor colorWithWhite:0 alpha:0.5];
            CGContextFillRect(context, self.bounds);
        } break;
        case WSProgressHUDMaskTypeGradient: {
            CGContextRef context = UIGraphicsGetCurrentContext();
            size_t locationCount = 2;
            CGFloat locations[2] = {0.0, 1.0};
            CGFloat colors[8] = {0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.0f, 0.65f};
            CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
            CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace, colors, locations, locationCount);
            
            CGColorSpaceRelease(colorSpace);
            
            CGFloat freeHeight = CGRectGetHeight(self.bounds) - self.visibleKeyboardHeight;
            
            CGPoint center = CGPointMake(CGRectGetWidth(self.bounds)/2, freeHeight/2);
            float radius = MIN(CGRectGetWidth(self.bounds) , CGRectGetHeight(self.bounds)) ;
            CGContextDrawRadialGradient (context, gradient, center, 0, center, radius, kCGGradientDrawsAfterEndLocation);
            CGGradientRelease(gradient);
            
        } break;
            
        default:
            break;
    }
}

#pragma mark - Pravite Method
/*!
 @brief  添加覆盖层
 */
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
        // Ensure that overlay will be exactly on top of rootViewController (which may be changed during runtime).
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if (!self.superview) {
        [self.overlayView addSubview:self];
    }
}

- (CGSize)hudSizeWithString: (NSString *)string
{
    
    stringRect = CGRectZero;
    
    hudHeight = 50;
    hudWidth = 50;
    
    UILabel *contentLabel = self.onlyShowTitle ? self.shimmeringLabel : self.labelView;
    
    CGSize constraintSize = CGSizeMake(200.0f, 300.0f);
    
    // > iOS7
    if ([string respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        stringRect.size = [string boundingRectWithSize:constraintSize
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
        stringRect.size = stringSize;
    }
    
    stringWidth =  ceilf(stringRect.size.width);
    stringHeight = ceilf(stringRect.size.height);
    
    
    self.shimmeringView.hidden = YES;
    self.labelView.hidden = YES;
    self.indicatorView.hidden = YES;
    self.imageView.hidden = YES;
    
    
    switch (self.hudType) {
        case WSProgressHUDTypeStatus: {
            if (string) {
                
                
                self.labelView.hidden = NO;
                self.indicatorView.hidden = NO;
                
                self.labelView.text = string;
                hudWidth = stringWidth + 40; // indicationWidth = 40
                hudHeight = stringHeight + edgeOffset;
            }  else {
                self.shimmeringView.hidden = YES;
                self.labelView.hidden = YES;
                self.indicatorView.hidden = NO;
            }
            
            
        } break;
            
        case WSProgressHUDTypeString: {
            hudWidth = stringWidth + edgeOffset; // indicationWidth = 40
            hudHeight = stringHeight + edgeOffset;
            
            self.shimmeringView.hidden = NO;
            self.shimmeringLabel.text = string;
            
        } break;
        case WSProgressHUDTypeImage: {
            
            self.labelView.hidden = NO;
            self.labelView.text = string;
            
            if (self.imageView.image) {
                
                hudHeight = stringHeight + imageOffset + edgeOffset;
                self.imageView.hidden = NO;
                
                hudWidth = stringWidth + edgeOffset;
                
                if (hudWidth < 120) {
                    hudWidth = 120; //设置最小
                }
                
                if (hudHeight < 100) {
                    hudHeight = 100;
                }

                
                
            } else {
                hudHeight = stringHeight + edgeOffset + 20;
                hudWidth = stringWidth + edgeOffset + 20;
            }
            
            
        } break;
            
        default:
            break;
    }

    return CGSizeMake(hudWidth, hudHeight);
}


- (void)updateSubviewsPositionWithString: (NSString *)string
{
    CGSize hudSize = [self hudSizeWithString:string];
    
    CGFloat centerX = kScreenWidth / 2;
    CGFloat centerY = kScreenHeight / 2;
    
    self.hudView.bounds = CGRectMake(0, 0, hudSize.width, hudSize.height);
    self.hudView.center = CGPointMake(centerX, centerY);
    
    CGFloat hudCenterX = CGRectGetWidth(self.hudView.bounds)/2;
    CGFloat hudCenterY = CGRectGetHeight(self.hudView.bounds)/2;

    switch (self.hudType) {
        case WSProgressHUDTypeStatus: {
            self.labelView.frame = stringRect;//设置完hud的frame后需要重新设置
            if (string) {
                self.indicatorView.center = CGPointMake(15, hudCenterY);
                self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY);
                [self.indicatorView startAnimating];
            } else {
                self.indicatorView.center = CGPointMake(hudCenterX, hudCenterY);
                [self.indicatorView startAnimating];

            }

        }break;
       
        case WSProgressHUDTypeString: {
            self.shimmeringView.frame = stringRect;//设置完hud的frame后需要重新设置
            [self setShimmeringLabelSize:stringRect.size];
            
            self.shimmeringView.center = CGPointMake(hudCenterX, hudCenterY);
            [self.indicatorView stopAnimating];


        }break;

        case WSProgressHUDTypeImage: {
            
            self.labelView.frame = stringRect;//设置完hud的frame后需要重新设置
            if (self.imageView.image) {
                
                stringRect.origin.y = imageOffset;
                
                self.imageView.frame = CGRectMake(0, 0, 50, 50);
                
                [self.indicatorView stopAnimating];
                
                self.labelView.center = CGPointMake(hudCenterX , hudCenterY + 30);
                
                self.imageView.center = CGPointMake(hudCenterX, hudCenterY - 10);
                
                
            } else {
//                self.shimmeringView.center = CGPointMake(hudCenterX, hudCenterY);
                self.labelView.center = CGPointMake(hudCenterX, hudCenterY);
            }

        }break;

        default:
            break;
    }
//    if ([self onlyShowTitle]) {
//        self.shimmeringView.frame = stringRect;//设置完hud的frame后需要重新设置
//        [self setShimmeringLabelSize:stringRect.size];
//    } else {
//        if (self.imageView.image) {
//            
//            stringRect.origin.y = imageOffset;
//            
//            self.imageView.frame = CGRectMake(0, 0, 30, 30);
//            
//        } else {
//            self.labelView.frame = stringRect;//设置完hud的frame后需要重新设置
//        }
//    }
//

//    if (string) {
//        if ([self onlyShowTitle]) {
//            self.shimmeringView.center = CGPointMake(hudCenterX, hudCenterY);
//            [self.indicatorView stopAnimating];
//            
//        } else {
//            if (self.imageView.image) {
//                [self.indicatorView stopAnimating];
//                
//                self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY + 20);
//                [self.indicatorView startAnimating];
//                self.imageView.center = CGPointMake(hudCenterX, hudCenterY - 10);
//
//            } else {
//                self.indicatorView.center = CGPointMake(15, hudCenterY);
//                self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY);
//                [self.indicatorView startAnimating];
//
//            }
//        }
//    } else {
//        self.indicatorView.center = CGPointMake(hudCenterX, hudCenterY);
//        [self.indicatorView startAnimating];
//    }
}

/*
 //    if (titleString) {
 //
 //        UILabel *contentLabel = self.onlyShowTitle ? self.shimmeringLabel : self.labelView;
 //
 //        CGSize constraintSize = CGSizeMake(200.0f, 300.0f);
 ////        stringRect.origin = CGPointMake(30, 0);
 //
 //        // > iOS7
 //        if ([titleString respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
 //            stringRect.size = [titleString boundingRectWithSize:constraintSize
 //                                                        options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
 //                                                     attributes:@{NSFontAttributeName: contentLabel.font}
 //                                                        context:NULL].size;
 //
 //        } else {
 //            CGSize stringSize;
 //            if ([titleString respondsToSelector:@selector(sizeWithAttributes:)]){
 //                stringSize = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:contentLabel.font.fontName size:contentLabel.font.pointSize]}];
 //            } else {
 //#pragma clang diagnostic push
 //#pragma clang diagnostic ignored "-Wdeprecated"
 //                stringSize = [titleString sizeWithFont:contentLabel.font constrainedToSize:constraintSize];
 //#pragma clang diagnostic pop
 //            }
 //            stringRect.size = stringSize;
 //        }
 //
 //        stringWidth =  ceilf(stringRect.size.width);
 //        stringHeight = ceilf(stringRect.size.height);
 //
 //        switch (self.hudType) {
 //            case WSProgressHUDTypeStatus: {
 //                self.shimmeringView.hidden = YES;
 //                self.labelView.hidden = NO;
 //                self.indicatorView.hidden = NO;
 //
 //                self.labelView.text = string;
 //                hudWidth = stringWidth + 40; // indicationWidth = 40
 //            } break;
 //
 //            case WSProgressHUDTypeString: {
 //                hudWidth = stringWidth + edgeOffset; // indicationWidth = 40
 //                hudHeight = stringHeight + edgeOffset;
 //
 //                self.shimmeringView.hidden = NO;
 //                self.labelView.hidden = YES;
 //                self.indicatorView.hidden = YES;
 //                self.shimmeringLabel.text = string;
 //                self.imageView.hidden = YES;
 //
 //            } break;
 //            case WSProgressHUDTypeImage: {
 //                self.shimmeringView.hidden = YES;
 //                self.labelView.hidden = NO;
 //                self.indicatorView.hidden = NO;
 //                self.labelView.text = string;
 //                hudWidth = stringWidth + 40; // indicationWidth = 40
 //
 //                if (self.imageView.image) {
 //                    hudHeight = stringHeight + imageOffset + edgeOffset;
 //                    self.imageView.hidden = NO;
 //
 //                    if (hudWidth < 50) {
 //                        hudWidth = hudWidth + 30; //设置最小
 //                    }
 //                } else {
 //                    hudHeight = stringHeight + edgeOffset;
 //                    self.imageView.hidden = YES;
 //                }
 //
 //            } break;
 //
 //            default:
 //                break;
 //        }
 //    } else {
 //        self.shimmeringView.hidden = YES;
 //        self.labelView.hidden = YES;
 //        self.indicatorView.hidden = NO;
 //    }

 */
- (void)setShimmeringLabelSize: (CGSize)size
{
    CGRect bounds = self.shimmeringLabel.bounds;
    bounds.size = size;
    self.shimmeringLabel.bounds = bounds;
}

- (void)showHUDViewWithAnimation
{

    if (_maskType != WSProgressHUDMaskTypeDefault) {
        self.overlayView.userInteractionEnabled = YES;
    } else {
        self.overlayView.userInteractionEnabled = NO;
    }
    self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.3, 1.3);
    
    [UIView animateWithDuration:0.15
                          delay:0
                        options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.3, 1/1.3);
                         
                         //                         if(self.isClear) // handle iOS 7 and 8 UIToolbar which not answers well to hierarchy opacity change
                         self.hudView.alpha = 1;
                         //                         else
                         //                             self.alpha = 1;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
    [self setNeedsDisplay];
    
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


#pragma mark - INIT View

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.hudView];
        [self.hudView addSubview:self.indicatorView];
        [self.hudView addSubview:self.shimmeringView];
        [self.hudView addSubview:self.labelView];
        [self.hudView addSubview:self.imageView];
        
        self.shimmeringView.contentView = self.shimmeringLabel;
        
        self.backgroundColor = [UIColor clearColor];
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
        _labelView.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
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
        _shimmeringView.shimmering = YES;
        _shimmeringView.shimmeringBeginFadeDuration = 0.3;
        _shimmeringView.shimmeringSpeed = 100;
        _shimmeringView.shimmeringOpacity = 1;
        _shimmeringView.shimmeringAnimationOpacity = 0.3;
    }
    return _shimmeringView;
}

- (UILabel *)shimmeringLabel {
    if (!_shimmeringLabel) {
        _shimmeringLabel = [[UILabel alloc] initWithFrame:self.shimmeringView.bounds];
        _shimmeringLabel.textColor = [UIColor whiteColor];
        _shimmeringLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline];
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


//- (WSIndefiniteAnimationView *)indefiniteAnimatedView {
//    if (_indefiniteAnimatedView == nil) {
//        _indefiniteAnimatedView = [[WSIndefiniteAnimationView alloc] initWithFrame:CGRectZero];
//        _indefiniteAnimatedView.strokeThickness = ws;
//        _indefiniteAnimatedView.strokeColor = SVProgressHUDForegroundColor;
//        _indefiniteAnimatedView.radius = self.labelView.text ? SVProgressHUDRingRadius : SVProgressHUDRingNoTextRadius;
//        [_indefiniteAnimatedView sizeToFit];
//    }
//    return _indefiniteAnimatedView;
//}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.hidden = YES;
    }
    return _imageView;
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



@end
