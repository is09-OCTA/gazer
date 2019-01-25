# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'gazer' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  pod'EAIntroView'
  pod 'Floaty'


  swift4_names = [
    'Floaty'
  ]

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            if swift4_names.include? target.name
                config.build_settings['SWIFT_VERSION'] = "4.2"
            else
                
            end
        end
    end
end

end
