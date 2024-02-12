# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint study.podspec` to validate before publishing.
Pod::Spec.new do |s|
  s.name             = 'study'
  s.version          = '1.0.0'
  s.summary          = 'Study flutter plugin.'
  s.description      = <<-DESC
  Study flutter plugin.
                       DESC
  s.homepage         = 'https://ademar.study'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Ademar' => 'study@ade.mar' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.on_demand_resources = { 'Study' => 'bindings-swift/Sources/Study/Study.swift' }
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'
  s.static_framework = true

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = {'STRIP_STYLE' => 'non-global', 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
  s.vendored_frameworks = "bindings-swift/studyFFI.xcframework"
end
