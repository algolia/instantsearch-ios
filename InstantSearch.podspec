Pod::Spec.new do |s|
  s.name = 'InstantSearch'
  s.version = '7.27.0'
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
      ss.dependency 'Logging'
      ss.ios.deployment_target = '14.0'
      ss.osx.deployment_target = '11.0'
      ss.watchos.deployment_target = '7.0'
      ss.tvos.deployment_target = '14.0'
  end

  s.subspec "Core" do |ss|
      ss.source_files = 'Sources/InstantSearchCore/**/*.{swift}'
      ss.dependency 'AlgoliaSearchClient', '~> 8.18'
      ss.dependency 'Logging'
      ss.dependency 'InstantSearch/Insights'
      ss.dependency 'SwiftProtobuf', '1.22.0'
      ss.dependency 'InstantSearchTelemetry', '~> 0.1.3'
      ss.ios.deployment_target = '14.0'
      ss.osx.deployment_target = '11.0'
      ss.watchos.deployment_target = '7.0'
      ss.tvos.deployment_target = '14.0'
      ss.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DInstantSearchCocoaPods' }
  end

  s.subspec "UI" do |ss|
      ss.source_files = 'Sources/InstantSearch/**/*.{swift}'
      ss.dependency 'InstantSearch/Core'
      ss.dependency 'Logging'
      ss.ios.deployment_target = '14.0'
      ss.osx.deployment_target = '11.0'
      ss.watchos.deployment_target = '7.0'
      ss.tvos.deployment_target = '14.0'
      ss.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DInstantSearchCocoaPods' }
  end

  s.subspec "SwiftUI" do |ss|
      ss.source_files = 'Sources/InstantSearchSwiftUI/**/*.{swift}'
      ss.dependency 'InstantSearch/Core'
      ss.dependency 'Logging'
      ss.dependency 'InstantSearchTelemetry', '~> 0.1.3'
      ss.ios.deployment_target = '14.0'
      ss.osx.deployment_target = '11.0'
      ss.watchos.deployment_target = '7.0'
      ss.tvos.deployment_target = '14.0'
      ss.pod_target_xcconfig = { 'OTHER_SWIFT_FLAGS' => '-DInstantSearchCocoaPods' }
      ss.weak_frameworks = 'SwiftUI', 'Combine'
  end

end
