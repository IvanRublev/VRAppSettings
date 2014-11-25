#
# Be sure to run `pod lib lint VRAppSettings.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "VRAppSettings"
  s.version          = "0.1.1"
  s.summary          = "Object representation for app's settings via class properties, keept in user's defaults."
  s.description      = <<-DESC
                       This superclass makes it easier to handle the user's preferences (app's settings). It's intended to be used in iOS primarily.
                       A successor to this class keeps the app settings in properties and stores itself in the defaults system. Although the settings values will not be accessible through the NSUserDefaults class directly, but only via the setters and getters of the VRAppSettings successor.
                       That gives common place for app's setting definition. The possibility to make range and consistency checks of the setting values in setters and getters. The refactoring tool can be used to change the setting's name across the project.
                       DESC
  s.homepage         = "https://github.com/IvanRublev/VRAppSettings"
  s.license          = 'MIT'
  s.author           = { "Ivan Rublev" => "ivan@ivanrublev.me" }
  s.source           = { :git => "https://github.com/IvanRublev/VRAppSettings.git", :tag => s.version.to_s }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'VRAppSettings'

  s.frameworks = 'Foundation'
  s.dependency 'VRFoundationToolkit', '~> 0.1'
end
