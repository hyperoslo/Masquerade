Pod::Spec.new do |s|
  s.name             = "Masquerade"
  s.summary          = "A short description of Masquerade."
  s.version          = "0.1.0"
  s.homepage         = "https://github.com/hyperoslo/Masquerade"
  s.license          = 'MIT'
  s.author           = { "Hyper Interaktiv AS" => "ios@hyper.no" }
  s.source           = {
    :git => "https://github.com/hyperoslo/Masquerade.git",
    :tag => s.version.to_s
  }
  s.social_media_url = 'https://twitter.com/hyperoslo'

  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.2'

  s.requires_arc = true
  s.ios.source_files = 'Sources/{iOS,Shared}/**/*'
  s.tvos.source_files = 'Sources/{iOS,Shared}/**/*'
  s.osx.source_files = 'Sources/{Mac,Shared}/**/*'

  # s.ios.frameworks = 'UIKit', 'Foundation'
  # s.osx.frameworks = 'Cocoa', 'Foundation'

  s.dependency 'Spots', '~> 5.0'
  s.dependency 'Brick', '~> 2.0'
  s.dependency 'Cartography', '~> 1.0'
  s.dependency 'Fashion', '~> 2.0'
  s.dependency 'Hue', '~> 2.0'
  s.dependency 'Imaginary', '~> 1.0'
end
