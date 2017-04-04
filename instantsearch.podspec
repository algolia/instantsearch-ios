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
  s.source_files = ['Sources/*.swift']
  # s.resource_bundles = {
  #   'InstantSearch' => ['InstantSearch/Sources/**/*.xib']
  # }
  # s.ios.frameworks = 'UIKit', 'Foundation'
  s.dependency 'InstantSearch-Core-Swift', '~> 1.0'
end
