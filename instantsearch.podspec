Pod::Spec.new do |s|
  s.name             = "InstantSearch"
  s.version          = "1.0.0"
  s.summary          = "A short description of InstantSearch."
  s.homepage         = "https://github.com/algolia/InstantSearch"
  s.license          = { type: 'MIT', file: 'LICENSE' }
  s.author           = { "Algolia" => "contact@algolia.com" }
  s.source           = { git: "https://github.com/algolia/InstantSearch.git", tag: s.version.to_s }
  s.social_media_url = 'https://twitter.com/algolia'
  s.ios.deployment_target = '8.0'
  s.requires_arc = true
  s.default_subspec = "InstantSearch"

  s.subspec "InstantSearch" do |ss|
    ss.source_files = 'Sources/Library/**/*.{swift}'
    ss.dependency 'InstantSearch-Core-Swift', '~> 1.0'
  end

  s.subspec "CustomWidgets" do |ss|
    ss.source_files = [
      'Sources/Library/**/*.{swift}',
      'Sources/CustomWidgets/**/*.{swift}'
    ]
    ss.dependency 'InstantSearch-Core-Swift', '~> 1.0'
  end
end
