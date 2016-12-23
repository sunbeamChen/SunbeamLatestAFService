Pod::Spec.new do |s|
  s.name             = 'SunbeamLatestAFService'
  s.version          = '0.1.7'
  s.summary          = 'SunbeamLatestAFService is an networking service base on latest AFNetworking.'
  s.description      = <<-DESC
An networking service base on latest AFNetworking.
                       DESC
  s.homepage         = 'https://github.com/sunbeamChen/SunbeamLatestAFService'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '陈训' => 'sunbeamhome@163.com' }
  s.source           = { :git => 'https://github.com/sunbeamChen/SunbeamLatestAFService.git', :tag => s.version.to_s }
  s.ios.deployment_target = '7.0'
  s.source_files = 'SunbeamLatestAFService/Classes/**/*'
  # s.resource_bundles = {
  #   'SunbeamLatestAFService' => ['SunbeamLatestAFService/Assets/*.png']
  # }
  s.public_header_files = 'SunbeamLatestAFService/Classes/**/*.h'
  s.dependency 'AFNetworking', '~> 3.0'
end
