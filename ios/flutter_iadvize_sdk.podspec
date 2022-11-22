#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_iadvize_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_iadvize_sdk'
  s.version          = '2.8.0'
  s.summary          = 'iAdvize Conversation SDK - Flutter Plugin'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'https://github.com/iadvize/flutter-iadvize-sdk#readme'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'iAdvize <sdk-integration@iadvize.com> (https://github.com/iadvize)'
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  # iAdvize dependencies
  s.dependency 'iAdvize', '2.8.0'
  
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
