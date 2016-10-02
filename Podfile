source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'

target 'bill-tracker' do
  use_frameworks!

  pod 'FontAwesome.swift', :git => 'https://github.com/thii/FontAwesome.swift'

  def test_pods
    pod 'Quick'
    pod 'Nimble'
  end

  target 'bill-trackerTests' do
    inherit! :search_paths
    test_pods
  end

  target 'bill-trackerUITests' do
    inherit! :search_paths
    test_pods
  end

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['SWIFT_VERSION'] = '3.0'
      end
    end
  end
end
