Pod::Spec.new do |spec|
	spec.name = 'ShareKit'
	spec.version = '2.0'
	spec.source = { :git => 'https://github.com/ShareKit/ShareKit.git', :submodules => true }
	spec.platform = :ios
	spec.resource = 'Classes/ShareKit/ShareKit.bundle', 'Classes/ShareKit/Core/SHKSharers.plist'
	spec.source_files  = 'Classes/ShareKit/{Configuration,Core,Customize UI,Reachability,UI}/**/*.{h,m,c}', 'Classes/ShareKit/*.{h,m,c}','Classes/ShareKit/Sharers/Actions/**/*.{h,m,c}', 'Classes/ShareKit/Sharers/Services/{Facebook,Twitter,Vkontakte}/**/*.{h,m,c}', 'Submodules/JSONKit/**/*.{h,m,c}'
	spec.frameworks = 'SystemConfiguration', 'Security', 'MessageUI', 'CFNetwork', 'CoreLocation', 'Twitter'
	spec.weak_frameworks = 'Accounts', 'AdSupport', 'Social'
	spec.xcconfig = { 'USER_HEADER_SEARCH_PATHS' => 'Submodules/**', 'OTHER_LDFLAGS' => '-all_load -ObjC' }
	spec.dependency 'SSKeychain'
	spec.dependency 'Facebook-iOS-SDK'
end