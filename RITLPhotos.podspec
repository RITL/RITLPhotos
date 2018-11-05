
Pod::Spec.new do |s|

  s.name          = "RITLPhotos"
  s.version       = "2.2.4"
  s.summary       = "PhotosPicker"
  s.description   = "一个基于Photos.framework的图片多选，模仿微信，还有很多不足，正在改进和优化."
  s.homepage      = "https://github.com/RITL/RITLImagePickerDemo"
  s.license       = { :type => "MIT", :file => "LICENSE" }
  s.authors       = { "YueXiaoWen" => "yuexiaowen108@gmail.com" }
  s.platform      = :ios, "8.0"
  s.source        = { :git => "https://github.com/RITL/RITLImagePickerDemo.git", :tag => "#{s.version}" }
  s.source_files  = "RITLPhotos/RITLPhotos.h"
  s.frameworks    = "Foundation","UIKit","Photos","PhotosUI"
  s.requires_arc  = true
  s.resource     = 'RITLPhotos/Resource/RITLPhotos.bundle'
  s.dependency 'RITLKit'
  s.dependency 'Masonry'


  s.subspec 'RITLConfig' do |ss|
    ss.source_files = 'RITLPhotos/RITLConfig/*.{h,m}'
  end

  s.subspec 'Protocol' do |ss|
    ss.source_files = 'RITLPhotos/Protocol/*.{h,m}'
  end

  s.subspec 'RITLPhotosCategory' do |ss|
    ss.source_files = 'RITLPhotos/RITLPhotosCategory/*.{h,m}'
  end

  s.subspec 'RITLViews' do |ss|
    ss.source_files = 'RITLPhotos/RITLViews/*.{h,m}'
    ss.dependency 'RITLPhotos/RITLPhotosCategory'
  end

  s.subspec 'RITLData' do |ss|
    ss.source_files = 'RITLPhotos/RITLData/*.{h,m}'
    ss.dependency 'RITLPhotos/RITLPhotosCategory'
    ss.dependency 'RITLPhotos/Protocol'
  end

  s.subspec 'RITLPhotoStore' do |ss|
    ss.source_files = 'RITLPhotos/RITLPhotoStore/*.{h,m}'
    ss.dependency 'RITLPhotos/RITLPhotosCategory'
  end

  s.subspec 'RITLGroupModule' do |ss|
    ss.source_files = 'RITLPhotos/RITLGroupModule/*.{h,m}'
    ss.dependency 'RITLPhotos/RITLPhotosCategory'
    ss.dependency 'RITLPhotos/RITLCollectionModule'
    ss.dependency 'RITLPhotos/RITLPhotoStore'
  end

  s.subspec 'RITLCollectionModule' do |ss|
    ss.source_files = 'RITLPhotos/RITLCollectionModule/*.{h,m}'
    ss.dependency 'RITLPhotos/RITLPhotosCategory'
    ss.dependency 'RITLPhotos/RITLHoriScrollModule'
    ss.dependency 'RITLPhotos/RITLConfig'
    ss.dependency 'RITLPhotos/RITLData'
    ss.dependency 'RITLPhotos/RITLViews'
    ss.dependency 'RITLPhotos/RITLPhotoStore'
  end

  s.subspec 'RITLPhotosController' do |ss|
    ss.source_files = 'RITLPhotos/RITLPhotosController/*.{h,m}'
    ss.dependency 'RITLPhotos/RITLConfig'
    ss.dependency 'RITLPhotos/Protocol'
    ss.dependency 'RITLPhotos/RITLData'
    ss.dependency 'RITLPhotos/RITLData'
    ss.dependency 'RITLPhotos/RITLGroupModule'
    ss.dependency 'RITLPhotos/RITLCollectionModule'
  end

  s.subspec 'RITLHoriScrollModule' do |ss|
    ss.source_files = 'RITLPhotos/RITLHoriScrollModule/*.{h,m}'
    ss.dependency 'RITLPhotos/RITLPhotosCategory'
    ss.dependency 'RITLPhotos/RITLConfig'
    ss.dependency 'RITLPhotos/RITLData'
    ss.dependency 'RITLPhotos/RITLViews'
  end

end
