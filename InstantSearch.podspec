Pod::Spec.new do |s|
  s.name = 'InstantSearch'
  s.version = '7.26.1'
  s.platforms = { :ios => "14.0", :osx => "11.0", :watchos => "7.0", :tvos => "14.0" }

  s.license = { type: 'Apache 2.0', file: 'LICENSE.md' }
  s.summary = 'A library of widgets and helpers to build instant-search applications on iOS.'
  s.homepage = 'https://github.com/algolia/instantsearch-ios'
  s.author = { "Algolia" => "contact@algolia.com" }
  s.source = { :git => 'https://github.com/algolia/instantsearch-ios.git', :tag => s.version }

  s.swift_version = "5.8"
  
  s.default_subspec = 'UI'
  
  s.resource_bundles = { 'InstantSearch' => ['Sources/PrivacyInfo.xcprivacy'] }
  
  s.subspec "Insights" do |ss|
      ss.source_files = 'Sources/InstantSearchInsights/**/*.{swift}'
      ss.dependency 'AlgoliaSearchClient', '~> 8.18'
      ss.ios.deployment_target = '9.0'
      ss.osx.deployment_target = '10.10'
      ss.watchos.deployment_target = '2.0'
      ss.tvos.deployment_target = '9.0'
  end
  
  s.subspec "Core" do |ss|
      ss.source_files = 'Sources/InstantSearchCore/**/*.{swift}'
      ss.dependency 'AlgoliaSearchClient', '~> 8.18'
      ss.dependency 'InstantSearch/Insights'
      ss.dependency 'InstantSearchTelemetry', '~> 0.1.3'
      ss.ios.deployment_target = '9.0'
      ss.osx.deployment_target = '10.11'
      ss.watchos.deployment_target = '2.0'
      ss.tvos.deployment_target = '9.0'
      ss.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DInstantSearchCocoaPods' }
  end
  
  s.subspec "UI" do |ss|
      ss.source_files = 'Sources/InstantSearch/**/*.{swift}'
      ss.dependency 'InstantSearch/Core'
      ss.ios.deployment_target = '9.0'
      ss.osx.deployment_target = '10.11'
      ss.watchos.deployment_target = '2.0'
      ss.tvos.deployment_target = '9.0'
      ss.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DInstantSearchCocoaPods' }
  end
  
  s.subspec "SwiftUI" do |ss|
      ss.source_files = 'Sources/InstantSearchSwiftUI/**/*.{swift}'
      ss.dependency 'InstantSearch/Core'
      ss.dependency 'InstantSearchTelemetry', '~> 0.1.3'
      ss.ios.deployment_target = '13.0'
      ss.osx.deployment_target = '10.15'
      ss.watchos.deployment_target = '6.0'
      ss.tvos.deployment_target = '13.0'
      ss.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DInstantSearchCocoaPods' }
      ss.weak_frameworks = 'SwiftUI', 'Combine'
  end

end
