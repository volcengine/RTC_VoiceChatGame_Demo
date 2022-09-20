
Pod::Spec.new do |spec|
  spec.name         = 'GameRoomParams'
  spec.version      = '1.0.0'
  spec.summary      = 'GameRoomParams APP'
  spec.description  = 'GameRoomParams App ..'
  spec.homepage     = 'https://github.com/volcengine'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'author' => 'volcengine rtc' }
  spec.source       = { :path => './'}
  spec.ios.deployment_target = '9.0'
  
  spec.source_files = '**/*.{h,m,c,mm}'
  spec.prefix_header_contents = '#import "Core.h"'
  spec.dependency 'Core'
  spec.dependency 'YYModel'
end
