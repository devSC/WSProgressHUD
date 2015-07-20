//
//  WSProgressHUD.m
//  WSProgressHUD
//
//  Created by Wilson-Yuan on 15/7/17.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "WSProgressHUD.h"
#import "FBShimmeringView.h"
#import "WSIndefiniteAnimationView.h"

@interface WSProgressHUD ()

@property (nonatomic, strong) UIControl *overlayView;

@property (strong, nonatomic) UILabel *labelView;

@property (strong, nonatomic) UIView *hudView;

@property (strong, nonatomic) UIActivityIndicatorView *indicatorView;

@property (strong, nonatomic) FBShimmeringView *shimmeringView;

@property (strong, nonatomic) CAShapeLayer *ringLayer;

@property (strong, nonatomic) WSIndefiniteAnimationView *indefiniteAnimatedView;


@end

//static 为静态全局变量
//const 为全局常量
//static const CGFloat WSProgressHUDRingRadius = 10;
//static const CGFloat WSProgressHUDRingNoTextRadius = 17;


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
    [self.overlayView removeFromSuperview];
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
    _maskType = maskType;
    _onlyShowString = NO;
    
    [self addOverlayViewToWindow];
    
    self.labelView.text = string;
    
    [self updateSubviewsPosition];
    
    [self.indicatorView startAnimating];
    
    [self showHUDViewWithAnimation];
}



- (void)showOnlyString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType
{
    if (string) {
        
        _onlyShowString = YES;
        
        [self addOverlayViewToWindow];
        
        self.labelView.text = string;
        
        [self updateSubviewsPosition];
        
        [self.indicatorView startAnimating];
        
        [self showHUDViewWithAnimation];
        
    } else {
        [self showWithString:nil];
    }
    _maskType = maskType;
}



- (void)showImage:(UIImage *)image title:(NSString *)title maskType: (WSProgressHUDMaskType)maskType
{
    _maskType = maskType;

    _onlyShowString = NO;
    
    [self addOverlayViewToWindow];
    
    self.labelView.text = title;
    
    [self updateSubviewsPosition];
}


#pragma mark - Super Method
- (void)drawRect:(CGRect)rect
{
    switch (_maskType) {
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


- (void)updateSubviewsPosition
{
    NSString *titleString = self.labelView.text;
    
    CGFloat hudWidth = 50;
    CGFloat hudHeight = 50;
    
    CGFloat stringWidth = 0.0f;
    CGFloat stringHeight = 0.0f;
    CGRect stringRect = CGRectZero;
    
    if (titleString) {
        CGSize constraintSize = CGSizeMake(200.0f, 300.0f);
        stringRect.origin = CGPointMake(30, 0);
        
        // > iOS7
        if ([titleString respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
            stringRect.size = [titleString boundingRectWithSize:constraintSize
                                                        options:(NSStringDrawingOptions)(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin)
                                                     attributes:@{NSFontAttributeName: self.labelView.font}
                                                        context:NULL].size;
            
        } else {
            CGSize stringSize;
            if ([titleString respondsToSelector:@selector(sizeWithAttributes:)]){
                stringSize = [titleString sizeWithAttributes:@{NSFontAttributeName:[UIFont fontWithName:self.labelView.font.fontName size:self.labelView.font.pointSize]}];
            } else {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
                stringSize = [titleString sizeWithFont:self.labelView.font constrainedToSize:CGSizeMake(200.0f, 300.0f)];
#pragma clang diagnostic pop
            }
            stringRect.size = stringSize;
        }
        self.labelView.hidden = NO;
        
        
        stringWidth =  ceilf(stringRect.size.width);
        stringHeight = ceilf(stringRect.size.height);
        if (_onlyShowString) {
            hudWidth = stringWidth + 10; // indicationWidth = 40
            hudHeight = stringHeight + 10;
        } else {
            hudWidth = stringWidth + 40; // indicationWidth = 40
            hudHeight = stringHeight + 10;
        }
    }
    
    CGFloat centerX = kScreenWidth / 2;
    CGFloat centerY = kScreenHeight / 2;
    
    self.hudView.bounds = CGRectMake(0, 0, hudWidth, hudHeight);
    self.hudView.center = CGPointMake(centerX, centerY);
    
    self.shimmeringView.frame = self.labelView.frame = stringRect;//设置完hud的frame后需要重新设置
    
    CGFloat hudCenterX = CGRectGetWidth(self.hudView.bounds)/2;
    CGFloat hudCenterY = CGRectGetHeight(self.hudView.bounds)/2;
    
    self.indicatorView.hidden = NO;
    if (titleString) {
        self.hudView.layer.cornerRadius = 5;
        self.hudView.layer.masksToBounds = YES;
        if (_onlyShowString) {
            self.indicatorView.hidden = YES;
            self.shimmeringView.center = self.labelView.center = CGPointMake(hudCenterX, hudCenterY);
            self.shimmeringView.contentView = self.labelView;

        } else {
            self.indicatorView.center = CGPointMake(15, hudCenterY);
            self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY);
        }
        
    
    } else {
        self.hudView.layer.cornerRadius = 10;
        self.hudView.layer.masksToBounds = YES;
        self.indicatorView.center = CGPointMake(hudCenterX, hudCenterY);
    }
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
                         dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                             [self dismiss];
                         });
                         
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
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}


- (UIView *)hudView
{
    if (!_hudView) {
        _hudView = [[UIView alloc] init];
        _hudView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
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
        _shimmeringView.shimmeringBeginFadeDuration = 1.2;
        _shimmeringView.shimmeringOpacity = 0.8;
    }
    return _shimmeringView;
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
