source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'bill-tracker' do
  use_frameworks!

  pod 'FontAwesome.swift', :git => 'https://github.com/thii/FontAwesome.swift'

  target 'bill-trackerTests' do
    inherit! :search_paths
  end

  target 'bill-trackerUITests' do
    inherit! :search_paths
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
