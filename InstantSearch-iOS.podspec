Pod::Spec.new do |s|
  s.name             = "InstantSearch-iOS"
  s.module_name      = 'InstantSearch'
  s.version          = "1.0.0"
  s.summary          = "A library of widgets and helpers to build instant-search applications on iOS."
  s.homepage         = "https://github.com/algolia/instantsearch-ios"
  s.license          = { type: 'MIT', file: 'LICENSE.md' }
  s.author           = { "Algolia" => "contact@algolia.com" }
  s.source           = { git: "https://github.com/algolia/instantsearch-ios.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/algolia'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.default_subspec = "InstantSearch-iOS"

  s.subspec "InstantSearch-iOS" do |ss|
    ss.source_files = 'Sources/Library/**/*.{swift}'
    ss.dependency 'InstantSearch-Core-Swift', '~> 3.0.0'
  end

  s.subspec "CustomWidgets" do |ss|
    ss.source_files = [
      'Sources/Library/**/*.{swift}',
      'Sources/CustomWidgets/**/*.{swift}'
    ]
    ss.dependency 'InstantSearch-Core-Swift', '~> 3.0.0'
  end
end
