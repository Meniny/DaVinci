Pod::Spec.new do |s|
  s.name             = 'DaVinci'
  s.version          = "1.0.2"
  s.summary          = "More modern CoreGraphics wrapper for iOS/OS X"
  s.homepage         = "https://github.com/Meniny/DaVinci"
  s.license          = { :type => "MIT", :file => "LICENSE.md" }
  s.author           = 'Elias Abel'
  s.source           = { :git => "https://github.com/Meniny/DaVinci.git", :tag => s.version.to_s }
  s.social_media_url = 'https://meniny.cn/'
  s.ios.source_files = "DaVinci/DaVinciTouch/**/*.swift", "DaVinci/Shared/**/*.swift"
  s.osx.source_files = "DaVinci/DaVinciMac/**/*.swift", "DaVinci/Shared/**/*.swift"
#  s.resources        = ['DaVinci/Assets.xcassets', 'Hohenheim/**/*.xib']
  s.requires_arc     = true
  s.ios.deployment_target = "10.0"
  s.osx.deployment_target = "10.10"
  s.description      = "DaVinci is a more modern CoreGraphics wrapper for iOS/macOS"
  s.module_name      = 'DaVinci'
  s.swift_version    = '4.1'
end
