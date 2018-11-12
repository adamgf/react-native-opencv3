
Pod::Spec.new do |s|
  s.name         = "RNOpencv3"
  s.version      = "1.0.0"
  s.summary      = "OpenCV 3.4.* ported to React-Native for both iOS and Android"
  s.description  = <<-DESC
                  react-native-opencv3 wraps functionality from OpenCV Java SDK 3.4.3 and iOS OpenCV pod 3.4.2 for use in React-Native apps.  Please enjoy!
                   DESC
  s.homepage     = "https://github.com/adamgf/react-native-opencv3"
  s.license      = { :type => "BSD", :file => "LICENSE" }
  s.author             = { "Adam G. Freeman" => "adamgf@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/adamgf/react-native-opencv3.git", :tag => "master" }
  s.source_files  = "RNOpencv3/**/*.{h,mm}"
  s.requires_arc = true

  s.subspec "CvCamera" do |ss|
    ss.source_files = "CvCamera/**/*.{h,m,mm}"
  end

  s.dependency "React"
  s.dependency "OpenCV"
  #s.dependency "others"

end
