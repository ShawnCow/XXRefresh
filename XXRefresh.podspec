Pod::Spec.new do |s|
s.name         = 'XXRefresh'
s.version      = '0.0.1'
s.license      = { :type => 'MIT', :file => 'LICENSE' }
s.homepage     = 'https://github.com/ShawnCow/XXRefresh'
s.authors      = {'大黄' => 'rockhxy@gmail.com'}
s.summary      = '超级牛逼的refresh  xxrefresh'

s.platform     =  :ios, '7.0'
s.source       =  {:git => 'https://github.com/ShawnCow/XXRefresh.git', :tag => s.version}
s.source_files =  'XXRefresh/*.{h,m}','XXRefresh/**/*'
s.frameworks   =  'Foundation','UIKit'

s.requires_arc = true

end
