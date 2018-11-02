#
# Be sure to run `pod lib lint mtpPickerField.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'mtpPickerField'
  s.version          = '1.0.3'
  s.summary          = 'UITextField + ActionSheet + (UIPickerView, UIDatePicker, UITableView, UICollectionView)'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
mtpPickerField is a good component to choose from among several options.
This custom control is made up of a UITextField combination  one of the UIPickerView, UIDatePicker, UItableView, UICollectionView controls that are built into a ActionSheet.
                       DESC

  s.homepage         = 'https://github.com/MostafaTaghipour/mtpPickerField'
  # s.screenshots     = 'https://github.com/MostafaTaghipour/mtpPickerField/blob/master/screenshots/1.gif'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Mostafa Taghipour' => 'mostafa.taghipour@ymail.com' }
  s.source           = { :git => 'https://github.com/MostafaTaghipour/mtpPickerField.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'mtpPickerField/Classes/**/*'
  
  # s.resource_bundles = {
  #   'mtpPickerField' => ['mtpPickerField/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
