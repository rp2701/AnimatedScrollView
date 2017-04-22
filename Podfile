source 'https://github.com/CocoaPods/Specs.git'
# platform :ios, ’10.0’
use_frameworks!





pod 'Alamofire', '~> 4.0'

pod 'IoniconsSwift', :git => 'http://github.com/tidwall/IoniconsSwift.git', :branch => 'master'
pod 'ionicons'
pod 'PermissionScope'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end