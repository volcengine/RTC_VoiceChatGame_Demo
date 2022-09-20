
Pod::Spec.new do |spec|
  spec.name         = 'GameRoomDemo'
  spec.version      = '1.0.0'
  spec.summary      = 'GameRoomDemo APP'
  spec.description  = 'GameRoomDemo App Demo..'
  spec.homepage     = 'https://github.com/volcengine'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'author' => 'volcengine rtc' }
  spec.source       = { :path => './'}
  spec.ios.deployment_target = '9.0'
  
  spec.source_files = '**/*.{h,m,c,mm}'
  spec.resource = ['Resource/*.{jpg,mp3}']
  spec.resource_bundles = {
    'GameRoomDemo' => ['Resource/*.{xcassets}']
  }
  spec.prefix_header_contents = '#import "Masonry.h"',
                                '#import "Core.h"',
                                '#import "GameRoomDemoConstants.h"'
  spec.vendored_frameworks = 'SudMGP.xcframework'
  spec.dependency 'Core'
  spec.dependency 'YYModel'
  spec.dependency 'Masonry'
  spec.dependency 'VolcEngineRTC'
end
