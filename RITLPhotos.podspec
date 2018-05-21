
Pod::Spec.new do |s|

  s.name          = "RITLPhotosController"
  s.version       = "2.1.0"
  s.summary       = "PhotosPicker"
  s.description   = "一个基于Photos.framework的图片多选，模仿微信，还有很多不足，正在改进和优化."

  s.homepage      = "https://github.com/RITL/RITLImagePickerDemo"

  s.license       = { :type => "MIT", :file => "LICENSE" }

  s.author        = { "YueXiaoWen" => "yuexiaowen108@gmail.com" }

  s.platform      = :ios, "8.0"

  s.source        = { :git => "https://github.com/RITL/RITLImagePickerDemo.git", :tag => "#{s.version}" }
  s.source_files  = "RITLPhotoController/*.{h,m}"

  s.frameworks    = "Foundation", "UIKit","Photos"
  s.requires_arc  = true
  s.resource     = 'RITLPhotoController/Resource/RITLPhotos.bundle'

  s.dependency "Masonry"
  s.dependency "RITLKit"



  s.subspec 'RITLConfig' do |ss|
    ss.source_files = 'RITLPhotoController/RITLConfig/*.{h,m}'
  end

  s.subspec 'RITLData' do |ss|
    ss.source_files = 'RITLPhotoController/RITLData/*.{h,m}'
    ss.dependency 'RITLPhotoController/Photos+RITLCategory'
  end

   s.subspec 'RITLPhotoStore' do |ss|
    ss.source_files = 'RITLPhotoController/RITLPhotoStore/*.{h,m}'
    ss.dependency 'RITLPhotoController/Photos+RITLCategory'
  end

  s.subspec 'RITLGroupModule' do |ss|
    ss.source_files = 'RITLPhotoController/RITLGroupModule/**/*.{h,m}'
    ss.dependency 'RITLPhotoController/Photos+RITLCategory'
    ss.dependency 'RITLPhotoController/RITLCollectionModule'
    ss.dependency 'RITLPhotoController/RITLPhotoStore'
  end

  s.subspec 'RITLCollectionModule' do |ss|
    ss.source_files = 'RITLPhotoController/RITLGroupModule/**/*.{h,m}'
    ss.dependency 'RITLPhotoController/Photos+RITLCategory'
    ss.dependency 'RITLPhotoController/RITLHoriScrollModule'
    ss.dependency 'RITLPhotoController/RITLPhotoStore'
  end

  s.subspec 'RITLHoriScrollModule' do |ss|
    ss.source_files = 'RITLPhotoController/RITLGroupModule/**/*.{h,m}'
    ss.dependency 'RITLPhotoController/Photos+RITLCategory'
    ss.dependency 'RITLPhotoController/RITLCollectionModule'
    ss.dependency 'RITLPhotoController/RITLConfig'
    ss.dependency 'RITLPhotoController/RITLData'
    ss.dependency 'RITLPhotoController/RITLViews'
    ss.dependency 'RITLPhotoController/RITLViews'
  end

  s.subspec 'RITLViews' do |ss|
    ss.source_files = 'RITLPhotoController/RITLViews/*.{h,m}'
  end

  s.subspec 'Photos+RITLCategory' do |ss|
    ss.source_files = 'RITLPhotoController/RITLCategory/*.{h,m}'
  end

end
