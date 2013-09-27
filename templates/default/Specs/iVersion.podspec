Pod::Spec.new do |s|
  s.name         = "iVersion"
  s.version      = "1.10.3"
  s.license      = { :type => 'zlib', :file => 'LICENCE.md' }
  s.summary      = "Library for checking for updates to Mac/iPhone App Store apps from within the application and notifying users about the new release. "
  s.homepage     = "https://github.com/nicklockwood/iVersion"
  s.authors      = { "Nick Lockwood" => "support@charcoaldesign.co.uk" }  
  s.source       = { :git => "https://github.com/exister/iVersion.git", :commit => '0ba46d29e5ecebd1c19451fd2c66c408b5274b8e' }
  s.source_files = 'iVersion/*.{h,m}'
  s.preserve_paths = 'iVersion/iVersion.bundle'
  s.resources     = 'iVersion/iVersion.bundle'
  s.requires_arc = true
  s.ios.deployment_target = '4.3'
  s.osx.deployment_target = '10.6'
  s.ios.frameworks = 'StoreKit'
end
