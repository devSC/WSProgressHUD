#
#  Be sure to run `pod spec lint WSProgressHUD.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "WSProgressHUD"
  s.version      = "1.1.3"
  s.summary      = "WSProgressHUD is a beauful hud view for iPhone & iPad."

  s.description  = <<-DESC
                   WSProgressHUD is a beauful hud view for iPhone & iPad. you can simple to use it.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it
                   DESC

  s.homepage     = "https://github.com/devSC/WSProgressHUD"
  s.screenshots  = "https://raw.githubusercontent.com/devSC/WSProgressHUD/master/Demo/Demo.gif"
  s.license      = "MIT"

  s.author             = { "袁仕崇" => "xiaochong2154@163.com" }
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/devSC/WSProgressHUD.git", :tag => "1.1.3" }
  s.source_files  = "WSProgressHUD/*"
  s.exclude_files = "Demo/Exclude"

  s.resources  = "WSProgressHUD/*.bundle"
  s.frameworks = "UIKit", "QuartzCore","CoreGraphics","Foundation"

  s.requires_arc = true
  s.dependency 'Shimmer'

end
