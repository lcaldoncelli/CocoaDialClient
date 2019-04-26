#
# Be sure to run `pod lib lint CocoaDialClient.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CocoaDialClient'
  s.version          = '0.1.2'
  s.summary          = 'CocoaDialClient is a basic implementation of DIAL protocol for servers discovery.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'CocoaDialClient is a basic implementation of DIAL (DIscover And Launch http://www.dial-multiscreen.org/) protocol for servers discovery.'

  s.homepage         = 'https://github.com/lcaldoncelli/CocoaDialClient'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Lucas Caldoncelli Rodrigues' => 'lcaldoncelli@gmail.com' }
  s.source           = { :git => 'https://github.com/lcaldoncelli/CocoaDialClient.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/lcaldoncelli'

  s.ios.deployment_target = '8.0'

  s.source_files = 'CocoaDialClient/Classes/**/*'
  
  # s.resource_bundles = {
  #   'CocoaDialClient' => ['CocoaDialClient/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'CocoaAsyncSocket', '~> 7.6.3'
  s.dependency 'XMLDictionary', '~> 1.4'
end
