#
# Be sure to run `pod lib lint FeedViewKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FeedViewKit'
  s.version          = '1.0.2'
  s.summary          = 'A short description of FeedViewKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/MenSoon/FeedViewKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '2283312765@qq.com' => 'Shon' }
  s.source           = { :git => 'https://github.com/MenSoon/FeedViewKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'
  s.swift_versions = ['4.0', '5.0']

  s.source_files = 'FeedViewKit/Classes/**/*'
  
   s.resource_bundles = {
     'FeedViewKit' => ['FeedViewKit/Assets/*.png', 'FeedViewKit/Assets/**/*']
   }

  s.dependency 'RxSwift',    '5.1.1'
  s.dependency 'RxCocoa',    '5.1.1'
  s.dependency 'RxGesture', '3.0.2'
  s.dependency 'MJRefresh', '3.2.0'
  s.dependency 'SnapKit'
end
