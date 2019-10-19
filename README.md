# WSProgressHUD
This is a beauful hud view for iPhone &amp; iPad

[![CI Status](http://img.shields.io/travis/devSC/WSProgressHUD.svg?style=flat)](https://travis-ci.org/devSC/WSProgressHUD)
[![Version](https://img.shields.io/cocoapods/v/WSProgressHUD.svg?style=flat)](http://cocoapods.org/pods/WSProgressHUD)
[![License](https://img.shields.io/cocoapods/l/WSProgressHUD.svg?style=flat)](http://cocoapods.org/pods/WSProgressHUD)
[![Platform](https://img.shields.io/cocoapods/p/WSProgressHUD.svg?style=flat)](http://cocoapods.org/pods/WSProgressHUD)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/devSC/WSProgressHUD)



![Example](Example/Demo.gif)

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

### From CocoaPods

WSProgressHUD is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'WSProgressHUD'

```

### Carthage 

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks. To integrate `WSProgressHUD` into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "devSC/WSProgressHUD"
```

Run `carthage update` to build the framework and drag the built `WSProgressHUD.framework` (in Carthage/Build/iOS folder) into your Xcode project (Linked Frameworks and Libraries in `Targets`).

### Manually

Drag the `WSProgressHUD/Demo/WSProgressHUD` folder into your project.
Then take care that `WSProgressHUD.bundle` is added to Targets->Build Phases->Copy Bundle Resources.
Add the QuartzCore framework to your project.

## Swift

Even though `WSProgressHUD` is written in Objective-C, it can be used in Swift with no hassle. If you use [CocoaPods](http://cocoapods.org) add the following line to your [Podfile](http://guides.cocoapods.org/using/using-cocoapods.html):

```ruby
use_frameworks!
```

If you added `WSProgressHUD` manually, just add a [bridging header](https://developer.apple.com/library/content/documentation/Swift/Conceptual/BuildingCocoaApps/MixandMatch.html) file to your project with the `WSProgressHUD` header included. 

## Thanks

@Shimmering
@SVProgressHUD
@MMMaterialDesignSpinner

## Author
Wilson-Yuan, xiaochong2154@163.com

## License
WSProgressHUD is available under the MIT license. See the [LICENSE](https://github.com/devSC/WSProgressHUD/blob/master/LICENSE)
 file for more info.





