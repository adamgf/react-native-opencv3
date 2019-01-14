
Pod::Spec.new do |s|
  s.name         = "OpenCVmin-face"
  s.version      = "3.4.5"
  s.summary      = "OpenCV iOS framework minified + face landmarks module"
  s.description  = <<-DESC
                  OpenCV iOS/OSX with modules: calib3d core dnn face features2d flann highgui imgcodecs imgproc ml objdetect photo shape stitching video videoio videostab world.  Please enjoy!
                   DESC
  s.homepage     = "https://github.com/adamgf/OpenCVmin-face"
  s.license      = { :type => "BSD-3", :file => "LICENSE" }
  s.author       = { "Adam G. Freeman" => "adamgf@gmail.com" }
  s.platform     = :ios, "9.0"
  s.source       = { :git => 'https://github.com/adamgf/OpenCVmin-face.git', :tag => 'master' }
  s.vendored_frameworks =  "opencv2.framework"
end
