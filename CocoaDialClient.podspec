Pod::Spec.new do |s|
  s.name     = 'CocoaDialClient'
  s.version  = '0.0.1'
  s.license  = { :type => 'public domain', :text => <<-LICENSE
Public Domain License
The CocoaDialClient project is in the public domain.
                 LICENSE
               }
  s.summary  = 'Dial Client for Mac and iOS.'
  s.homepage = 'https://github.com/lcaldoncelli/CocoaDialClient'
  s.authors  = 'Lucas Caldoncelli Rodrigues', { 'Lucas Caldoncelli Rodrigues' => 'lcaldoncelli@gmail.com' }

  s.source   = { :git => 'https://github.com/lcaldoncelli/CocoaDialClient.git',
                 :tag => "#{s.version}" }

  s.description = 'CocoaDialClient uses UDP to discover DIAL servers inside application network. ' \
                  'For DIAL specification, visit http://dial-multiscreen.org.'

  s.source_files = 'Source/CDC/*.{h,m}'

  s.requires_arc = true

  s.ios.deployment_target = '5.0'
  s.tvos.deployment_target = '9.0'
  s.osx.deployment_target = '10.8'

  s.ios.frameworks = 'CFNetwork', 'Security'
  s.tvos.frameworks = 'CFNetwork', 'Security'
  s.osx.frameworks = 'CoreServices', 'Security'
  
  s.dependency 'CocoaAsyncSocket', '~> 7.6.3'
end

