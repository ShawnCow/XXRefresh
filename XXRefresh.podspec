 Pod::Spec.new do |s| 
    s.name = "XXRefresh" 
    s.version = "1.0" 
    s.summary = "简单的下拉刷新框架" 
    s.homepage = "https://github.com/ShawnCow/XXRefresh" 
    s.license = "MIT" 
    s.author = { "Shawn" => "rockhxy@gmail.com" } 
    s.platform = :ios, "5.0" 
    s.source = { :git => "https://github.com/ShawnCow/XXRefresh.git", :tag => "1.0" } 
    s.source_files = "XXRefresh/XXRefresh/**/*.{h,m}" 
    s.resources = "XXRefresh/XXRefresh/Resource/*.{png}" 
    s.requires_arc = true  
end