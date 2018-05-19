Pod::Spec.new do |s|
  s.name             = 'DaVinci'
  s.module_name      = 'DaVinci'
  s.version          = "2.0.1"
  s.summary          = "More modern CoreGraphics wrapper for iOS/macOS"
  s.description      = "DaVinci is a more modern CoreGraphics wrapper for iOS/macOS"

  s.homepage         = "https://github.com/Meniny/DaVinci"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = 'Elias Abel'
  s.source           = { :git => "https://github.com/Meniny/DaVinci.git", :tag => s.version.to_s }
  s.social_media_url = 'https://meniny.cn/'

  s.requires_arc     = true

  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.10"

  s.swift_version    = '4.1'

  s.default_subspecs = 'Core'

  s.subspec 'Core' do |ss|
    ss.source_files  = "DaVinci/Core/**/*.{h,swift}"
  end
end
