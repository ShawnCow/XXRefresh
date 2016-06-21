Pod::Spec.new do |s|
s.name             = "XXRefresh"
s.version          = "1.0.0"
s.summary          = "简单的下拉刷新框架"
s.description      = <<-DESC
It is a marquee view used on iOS, which implement by Objective-C.
DESC
s.homepage         = "https://github.com/ShawnCow/XXRefresh"
# s.screenshots      = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
s.license          = 'MIT'
s.author             = { "Shawn" => "rockhxy@gmail.com"}
s.source       = {:git => "https://github.com/ShawnCow/XXRefresh.git", :tag => "1.0.0"}
# s.social_media_url = 'https://twitter.com/NAME'

s.platform     = :ios, '4.3'
# s.ios.deployment_target = '5.0'
# s.osx.deployment_target = '10.7'
s.requires_arc = true

s.source_files = 'XXRefresh/XXRefreshDaHuang/*'
#s.resource     = 'XXRefresh/XXRefreshDaHuang/Resource/*'
# s.resources = 'Assets'

# s.ios.exclude_files = 'Classes/osx'
# s.osx.exclude_files = 'Classes/ios'
# s.public_header_files = 'Classes/**/*.h'
s.frameworks = 'Foundation','UIKit'

end