Pod::Spec.new do |s|
  s.name = 'InstantSearch'
  s.version = '7.0.0-beta.2'
  s.platforms = { :ios => "8.0", :osx => "10.10", :watchos => "3.0", :tvos => "9.0" }

  s.license = { type: 'Apache 2.0', file: 'LICENSE.md' }
  s.summary = 'A library of widgets and helpers to build instant-search applications on iOS.'
  s.homepage = 'https://github.com/algolia/instantsearch-ios'
  s.author = { "Algolia" => "contact@algolia.com" }
  s.source = { :git => 'https://github.com/algolia/instantsearch-ios.git', :tag => s.version }

  s.swift_version = "5.1"
  
  s.default_subspec = 'Core'
  
  s.subspec "Core" do |ss|
      ss.source_files = 'Sources/InstantSearchCore/**/*.{swift}'
      ss.dependency 'AlgoliaSearchClientSwift', '~> 8.0.0-beta.8'
      ss.dependency 'InstantSearchInsights', '~> 2.3'
  end
  
  s.subspec "UI" do |ss|
      ss.source_files = 'Sources/InstantSearch/**/*.{swift}'
      ss.dependency 'InstantSearch/Core'
      ss.ios.deployment_target = '8.0'
      ss.osx.deployment_target = '10.15'
      ss.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DInstantSearchCocoaPods' }
  end
    
  #s.dependency 'AlgoliaSearchClientSwift', '~> 8.0.0-beta.7'
  #s.dependency 'InstantSearchInsights', '~> 2.3'
  
end
