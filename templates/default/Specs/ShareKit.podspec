Pod::Spec.new do |s|
  s.name          = 'ShareKit'
  s.version       = '2.0'
  s.platform      = :ios
  s.summary       = 'Drop in sharing features for all iPhone and iPad apps.'
  s.homepage      = 'http://getsharekit.com/'
  s.author        = 'ShareKit Community'
  s.source        = { :git  => 'https://github.com/exister/ShareKit.git', :commit => 'ac50d712cd207b9ab2fe72533646eae2cb592948' }
  s.license       = { :type => 'MIT',
                      :text => %Q|Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:\n| +
                               %Q|The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.\n| +
                               %Q|THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE| }
  s.resources      = 'Classes/ShareKit/ShareKit.bundle', 'Classes/ShareKit/Core/SHKSharers.plist'
  s.source_files  = 'Classes/ShareKit/{Configuration,Core,Customize UI,UI}/**/*.{h,m,c}', 'Classes/ShareKit/Sharers/Actions/**/*.{h,m,c}'
  s.frameworks    = 'SystemConfiguration', 'Security', 'MessageUI'
  #s.preserve_paths = 'SSToolkit.xcodeproj', 'Classes/ShareKit/ShareKit.bundle'

  s.dependency 'SSKeychain'
  s.dependency 'Reachability'

  s.subspec 'Facebook' do |facebook|
    facebook.source_files   = 'Classes/ShareKit/Sharers/Services/Facebook/**/*.{h,m}'
    facebook.compiler_flags = '-Wno-incomplete-implementation -Wno-protocol -Wno-missing-prototypes'
    facebook.dependency 'Facebook-iOS-SDK'
  end

  s.subspec 'Twitter' do |twitter|
    twitter.source_files = 'Classes/ShareKit/Sharers/Services/Twitter/**/*.{h,m}'
    twitter.framework = 'Twitter'
    twitter.dependency 'JSONKit'
  end

  s.subspec 'Vkontakte' do |vkontakte|
    vkontakte.source_files = 'Classes/ShareKit/Sharers/Services/Vkontakte/**/*.{h,m}'
    vkontakte.dependency 'JSONKit'
  end
end