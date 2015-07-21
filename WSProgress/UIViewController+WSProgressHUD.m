//
//  UIViewController+WSProgressHUD.m
//  WSProgressHUD
//
//  Created by YSC on 15/7/21.
//  Copyright (c) 2015年 wilson-yuan. All rights reserved.
//

#import "UIViewController+WSProgressHUD.h"
#import "WSProgressHUD.h"
#import "Aspects.h"

@implementation UIViewController (WSProgressHUD)

+ (void)load
{
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        [WSProgressHUD dismiss];
    } error:NULL];
}


@end
