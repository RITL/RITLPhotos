
Pod::Spec.new do |s|

  s.name         = "RITLPhotos"
  s.version      = "2.0.1"
  s.summary      = "PhotosPicker"
  s.description  = <<-DESC
                    一个基于Photos.framework的图片多选，模仿微信，还有很多不足，正在改进和优化
                   DESC

  s.homepage     = "https://github.com/RITL/RITLImagePickerDemo"
  s.screenshots  = "http://7xruse.com1.z0.glb.clouddn.com/RITLPhotos.gif"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "YueXiaoWen" => "yuexiaowen108@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/RITL/RITLImagePickerDemo.git", :tag => "#{s.version}" }
  s.source_files  = "RITLPhotos/**/*.{h}"
  s.frameworks = "Foundation", "UIKit","Photos"
  s.requires_arc = true
  s.dependency "Masonry"

end
