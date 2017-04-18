# WSProgressHUD
This is a beauful hud view for iPhone &amp; iPad

[![CI Status](http://img.shields.io/travis/devSC/WSProgressHUD.svg?style=flat)](https://travis-ci.org/devSC/WSProgressHUD)
[![Version](https://img.shields.io/cocoapods/v/WSProgressHUD.svg?style=flat)](http://cocoapods.org/pods/WSProgressHUD)
[![License](https://img.shields.io/cocoapods/l/WSProgressHUD.svg?style=flat)](http://cocoapods.org/pods/WSProgressHUD)
[![Platform](https://img.shields.io/cocoapods/p/WSProgressHUD.svg?style=flat)](http://cocoapods.org/pods/WSProgressHUD)


![Demo](https://raw.githubusercontent.com/devSC/WSProgressHUD/master/Demo/Demo.gif)

# Usage
To Download the project. Run the WSProgressHUD.xcodeproj in the demo directory.

``` objc

    [WSProgressHUD show];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        ...

        dispatch_async(dispatch_get_main_queue(), ^{
        ...
        [WSProgressHUD dismiss];
        });
    });

//Show on the self.view

@implementation ViewController
{
    WSProgressHUD *hud;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    //Add HUD to view
    hud = [[WSProgressHUD alloc] initWithView:self.navigationController.view];
    [self.view addSubview:hud];

    //show
    [hud showWithString:@"Wating..." maskType:WSProgressHUDMaskTypeBlack];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud dismiss];
    });

}

//Show on the window
    //show
    [WSProgressHUD show];

    //Show with mask
    [WSProgressHUD showWithMaskType:WSProgressHUDMaskTypeBlack];
    
    //Show with mask without tabbar
    [WSProgressHUD showWithStatus:@"Loading..." maskType:WSProgressHUDMaskTypeBlack maskWithout:WSProgressHUDMaskWithoutTabbar];
    
    //Show with string
    [WSProgressHUD showWithStatus:@"Loading..."];

    //Show with facebook shimmering
    [WSProgressHUD showShimmeringString:@"WSProgressHUD Loading..."];

    //Show with Progress
    [WSProgressHUD showProgress:progress status:@"Updating..."];

    //Show with image
    [WSProgressHUD showSuccessWithStatus:@"Thanks.."];
    
    //Show with string
    [WSProgressHUD showImage:nil status:@"WSProgressHUD"]

    //Dismiss
    [WSProgressHUD dismiss];
    
    //And There have 3 indicator style for your choice
    [WSProgressHUD setProgressHUDIndicatorStyle:WSProgressHUDIndicatorSmall] //small custom spinner

```
## Installation


WSProgressHUD is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WSProgressHUD'

```
## Manually

Drag the WSProgressHUD/Demo/WSProgressHUD folder into your project.
Then take care that WSProgressHUD.bundle is added to Targets->Build Phases->Copy Bundle Resources.
Add the QuartzCore framework to your project.

## Thanks

@Shimmering
@SVProgressHUD
@MMMaterialDesignSpinner

## Author
Wilson-Yuan, xiaochong2154@163.com

## License
WSProgressHUD is available under the MIT license. See the LICENSE file for more info.





