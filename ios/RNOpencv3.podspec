
Pod::Spec.new do |s|
  s.name         = "RNOpencv3"
  s.version      = "1.0.8"
  s.summary      = "OpenCV 3.4.1 plus contrib modules  ported to React-Native"
  s.description  = <<-DESC
                  react-native-opencv3 wraps functionality from OpenCV 3.4.4+contrib for Java and OpenCV 3.4.1+contrib for iOS for use in React-Native apps.  Please enjoy!
                   DESC
  s.homepage     = "https://github.com/adamgf/react-native-opencv3"
  s.license      = { :type => "clause-3 BSD", :file => "LICENSE" }
  s.author             = { "Adam G. Freeman" => "adamgf@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => "https://github.com/adamgf/react-native-opencv3.git", :tag => "master" }

  s.subspec "CvCamera" do |ss|
    ss.source_files = "*.{h,m,mm}"
    ss.ios.resource_bundle = { 'ocvdata' => 'ocvdata/*.*ml' }
  end

  s.dependency "libopencv-contrib", "~> 3.4.1"
  s.dependency "React"
  
  # s.dependency "others"

end
