Pod::Spec.new do |s|
  s.name = 'SunbeamLatestAFService'
  s.version = '0.1.19'
  s.summary = 'SunbeamLatestAFService is an networking service base on latest AFNetworking.'
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"陈训"=>"sunbeamhome@163.com"}
  s.homepage = 'https://github.com/sunbeamChen/SunbeamLatestAFService'
  s.description = 'An networking service base on latest AFNetworking 3.0, use block callback after request complete.'
  s.source = { :path => '.' }

  s.ios.deployment_target    = '7.0'
  s.ios.preserve_paths       = 'ios/SunbeamLatestAFService.framework'
  s.ios.public_header_files  = 'ios/SunbeamLatestAFService.framework/Versions/A/Headers/*.h'
  s.ios.resource             = 'ios/SunbeamLatestAFService.framework/Versions/A/Resources/**/*'
  s.ios.vendored_frameworks  = 'ios/SunbeamLatestAFService.framework'
end
