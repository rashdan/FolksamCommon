#
# Be sure to run `pod lib lint FolksamCommon.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FolksamCommon'
  s.version          = '0.1.0'
  s.summary          = 'FolksamCommon is a swift package manager.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/rashdan/FolksamCommon'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'johan' => 'johan.torell@folksam.se' }
  s.source           = { :git => 'https://github.com/rashdan/FolksamCommon.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '13.0'
  s.swift_versions = '5.5'
  
  #s.source_files = 'FolksamCommon/Module/**/*.{swift}'
  #s.resources = 'FolksamCommon/Module/**/*.{xcassets,json,storyboard,xib,xcdatamodeld}'
  
  
  s.source_files  = "Sources/FolksamCommon/FolksamCommon/Module/**/*.swift"

end

