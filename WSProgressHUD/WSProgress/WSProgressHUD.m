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

@end

static CGFloat hudWidth = 50;
static CGFloat hudHeight = 50;

static CGFloat stringWidth = 0.0f;
static CGFloat stringHeight = 0.0f;

static CGFloat const edgeOffset = 10;
static CGFloat const imageOffset = 40;

static CGFloat maskTopEdge = 0;
static CGFloat maskBottomEdge = 0;

static CGRect stringRect;
static UIColor *WSProgressHUDForeGroundColor;
static UIImage *WSProgressHUDSuccessImage;
static UIImage *WSProgressHUDErrorImage;

static CGFloat WSProgressHUDRingThickness = 2;



@implementation WSProgressHUD

#define kScreenScale(v) (kScreenWidth / 320 * v)
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
    [[self shareInstance] showWithString:string maskType:maskType maskWithout:withoutType];
}


#pragma mark - Show image

+ (void)showSuccessWithString: (NSString *)string
{
    [self showImage:WSProgressHUDSuccessImage title:string];
}

+ (void)showErrorWithString: (NSString *)string
{
    [self showImage:WSProgressHUDErrorImage title:string];
}


+ (void)showImage:(UIImage *)image title:(NSString *)title
{
    [self showImage:image title:title maskType:WSProgressHUDMaskTypeDefault];
}

+ (void)showImage:(UIImage *)image title:(NSString *)title maskType: (WSProgressHUDMaskType)maskType
{
//    [[self shareInstance] showImage:image title:title maskType:maskType];
    [self showImage:image title:title maskType:maskType maskWithout:WSProgressHUDMaskWithoutDefault];
}


+ (void)showImage:(UIImage *)image title:(NSString *)title maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [[self shareInstance] showImage:image title:title maskType:maskType maskWithout:withoutType];
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
    [[self shareInstance] showOnlyString:string maskType:maskType maskWithout:withoutType];
}


+ (void)dismiss {
    [[self shareInstance] dismiss];
}


#pragma mark - Show & dismiss method

- (void)showWithMaskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    [self showWithString:nil maskType:maskType maskWithout:withoutType];
}


- (void)showWithString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeStatus), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(withoutType), @(withoutType), OBJC_ASSOCIATION_ASSIGN);
    
    [self addOverlayViewToWindow];
    
    self.labelView.text = string;
    
    [self updateSubviewsPositionWithString:string];
    
    [self showHUDViewWithAnimation];
}


- (void)showOnlyString: (NSString *)string maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeString), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(withoutType), @(withoutType), OBJC_ASSOCIATION_ASSIGN);
    
    if (string) {
        objc_setAssociatedObject(self, @selector(onlyShowTitle), @(1), OBJC_ASSOCIATION_ASSIGN);
        [self addOverlayViewToWindow];
        
        [self updateSubviewsPositionWithString:string];
        
        [self showHUDViewWithAnimation];
        
    } else {
        [self showWithString:nil maskType:maskType maskWithout:withoutType];
    }
}


- (void)showImage:(UIImage *)image title:(NSString *)title maskType: (WSProgressHUDMaskType)maskType maskWithout: (WSProgressHUDMaskWithoutType)withoutType
{
    objc_setAssociatedObject(self, @selector(maskType), @(maskType), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(showImage), @(1), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(hudType), @(WSProgressHUDTypeImage), OBJC_ASSOCIATION_ASSIGN);
    objc_setAssociatedObject(self, @selector(withoutType), @(withoutType), OBJC_ASSOCIATION_ASSIGN);
    
    self.imageView.image = image;
    
    [self addOverlayViewToWindow];
    
    [self updateSubviewsPositionWithString:title];
    
    [self showHUDViewWithAnimation];
    
    self.timer = [NSTimer timerWithTimeInterval:2.0 target:self selector:@selector(dismiss) userInfo:nil repeats:NO];
    
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];

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


#pragma mark - Pravite Method

- (void)showHUDViewWithAnimation
{
    
    if (self.maskType != WSProgressHUDMaskTypeDefault) {
        self.overlayView.userInteractionEnabled = YES;
    } else {
        self.overlayView.userInteractionEnabled = NO;
    }
    if (self.hudView.alpha == 0) {
        self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1.2, 1.2);
        

        [UIView animateWithDuration:0.2
                              delay:0
                            options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.hudView.transform = CGAffineTransformScale(self.hudView.transform, 1/1.2, 1/1.2);
                             
                             //                         if(self.isClear) // handle iOS 7 and 8 UIToolbar which not answers well to hierarchy opacity change
                             self.hudView.alpha = 1;
                             //                         else
                             //                             self.alpha = 1;
                         }
                         completion:^(BOOL finished){
                             objc_setAssociatedObject(self, @selector(hudAlreadyDismiss), @(0), OBJC_ASSOCIATION_ASSIGN);
                         }];
    }
   
    [self setNeedsDisplay];
    
}

- (void)dismiss
{
    if (self.hudAlreadyDismiss) {
        return;
    }
    
    self.hudView.transform = CGAffineTransformIdentity;
    [UIView animateWithDuration:0.2
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
                         objc_setAssociatedObject(self, @selector(hudAlreadyDismiss), @(1), OBJC_ASSOCIATION_ASSIGN);
                         
                         [self.timer invalidate];
                         self.timer = nil;
                     }];
}






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
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
    if (!self.superview) {
        [self.overlayView addSubview:self];
    }
    
    [self setMaskEdgeWithType:self.maskType];
}

- (CGSize)hudSizeWithString: (NSString *)string
{
    
    stringRect = CGRectZero;
    
    hudHeight = 50;
    hudWidth = 50;
    
    UILabel *contentLabel = self.onlyShowTitle ? self.shimmeringLabel : self.labelView;
    
    CGSize constraintSize = CGSizeMake(kScreenScale(220), kScreenScale(300));
    
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
//    self.indicatorView.hidden = YES;
    [self startIndicatorAnimation:NO];
    self.imageView.hidden = YES;
    
    
    switch (self.hudType) {
        case WSProgressHUDTypeStatus: {
            [self startIndicatorAnimation:YES];
//                self.indicatorView.hidden = NO;

            if (string) {
                self.labelView.hidden = NO;
                self.labelView.text = string;
                hudWidth = stringWidth + 40; // indicationWidth = 40
                hudHeight = stringHeight + edgeOffset;
            }  else {
                self.shimmeringView.hidden = YES;
                self.labelView.hidden = YES;
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
                
                hudWidth = hudWidth < 100 ? 120 : hudWidth + 10;
                
                hudHeight = hudHeight < 80 ? 100 : hudHeight + 10;
   
            } else {
                hudHeight = stringHeight + edgeOffset + 10;
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
    
    CGFloat centerX = self.frame.size.width / 2;
    CGFloat centerY = self.frame.size.height / 2 - 20;
    
    self.hudView.bounds = CGRectMake(0, 0, hudSize.width, hudSize.height);
    self.hudView.center = CGPointMake(centerX, centerY);
    
    CGFloat hudCenterX = CGRectGetWidth(self.hudView.bounds)/2;
    CGFloat hudCenterY = CGRectGetHeight(self.hudView.bounds)/2;

    switch (self.hudType) {
        case WSProgressHUDTypeStatus: {
            self.labelView.frame = stringRect;//设置完hud的frame后需要重新设置
            
            [self startIndicatorAnimation:YES];
            if (string) {
                self.indefiniteAnimationView.center = self.indicatorView.center = CGPointMake(15, hudCenterY);
                self.labelView.center = CGPointMake(hudCenterX + 10, hudCenterY);
//                [self.indicatorView startAnimating];
                
            } else {
                self.indefiniteAnimationView.center = self.indicatorView.center = CGPointMake(hudCenterX, hudCenterY);
//                self.indicatorView.hidden = YES;
//                [self startIndicatorAnimation:NO];
            }

        }break;
       
        case WSProgressHUDTypeString: {
            self.shimmeringView.frame = stringRect;//设置完hud的frame后需要重新设置
            [self setShimmeringLabelSize:stringRect.size];
            
            self.shimmeringView.center = CGPointMake(hudCenterX, hudCenterY);
//            [self.indicatorView stopAnimating];
            [self startIndicatorAnimation:NO];


        }break;

        case WSProgressHUDTypeImage: {
            
            self.labelView.frame = stringRect;//设置完hud的frame后需要重新设置
            if (self.imageView.image) {
                
                stringRect.origin.y = imageOffset;
                
//                [self.indicatorView stopAnimating];
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

- (void)setIndicatorViewCenter: (CGPoint)center
{

}
- (void)startIndicatorAnimation: (BOOL)start
{
    switch (self.indicatorStyle) {
        case WSProgressHUDIndicatorSmallLight: {
            self.indefiniteAnimationView.hidden = YES;
            if (start) {
                [self.indicatorView startAnimating];
            } else {
                [self.indicatorView stopAnimating];
            }
        }break;
        case WSProgressHUDIndicatorCustom: {
            [self.indicatorView stopAnimating];
            self.indicatorView.hidden = YES;
            if (start) {
                self.indefiniteAnimationView.hidden = NO;
            } else {
                self.indefiniteAnimationView.hidden = YES;
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
    self.overlayView.frame = CGRectMake(0, maskTopEdge, kScreenWidth, kScreenHeight - maskTopEdge - maskBottomEdge);
    CGRect rect = self.frame;
    rect.size = self.overlayView.frame.size;
    self.frame = rect;
//    NSLog(@"%@", self.overlayView);
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



- (void)setTimer:(NSTimer *)timer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
        
    }
    _timer = timer;
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


#pragma mark - Init View

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
        _shimmeringView.shimmering = YES;
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

- (BOOL)hudAlreadyDismiss
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (WSProgressHUDIndicatorStyle )indicatorStyle {
    return [objc_getAssociatedObject(self, _cmd) integerValue];
}



@end
