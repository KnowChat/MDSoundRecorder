#
# Be sure to run `pod lib lint MDSoundRecorder.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MDSoundRecorder'
  s.version          = '0.1.0'
  s.summary          = 'A short description of MDSoundRecorder.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/KnowChat/MDSounderRecorder'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'yinhaofrancis' => '1833918721@qq.com' }
  s.source           = { :git => 'https://github.com/KnowChat/MDSounderRecorder.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'MDSoundRecorder/Classes/**/*'
 libraries = 'c++', 'stdc++', 'z'
  # s.resource_bundles = {
  #   'MDSoundRecorder' => ['MDSoundRecorder/Assets/*.png']
  # }
  s.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64 armv7 armv7s' }
  s.vendored_libraries = 'MDSoundRecorder/lib/libopencore-amrnb.a','MDSoundRecorder/lib/libopencore-amrwb.a','MDSoundRecorder/lib/libmp3lame.a'
   s.public_header_files = 'MDSoundRecorder/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
