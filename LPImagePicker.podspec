Pod::Spec.new do |s|
  s.name             = "LPImagePicker"
  s.version          = "0.0.4"
  s.summary          = "image/photo browser for picking custom image source"
  s.description      = <<-DESC
			a simple image/photo browser for picking image/photo(supports custom image source)                       
		       DESC
  s.homepage         = "https://github.com/litt1e-p/LPImagePicker"
  s.license          = { :type => 'MIT' }
  s.author           = { "litt1e-p" => "litt1e.p4ul@gmail.com" }
  s.source           = { :git => "https://github.com/litt1e-p/LPImagePicker.git", :tag => "#{s.version}" }
  s.platform = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'LPImagePicker/**/*.{h,m}'
  s.resource_bundles = {
    'LPImagePickerBundle' => ['LPImagePicker/**/*.lproj']
  }
  s.dependency 'LPPhotoViewer'
  s.dependency 'LPImageGridView'
  s.frameworks = 'Foundation', 'UIKit'
end

