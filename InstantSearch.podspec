Pod::Spec.new do |s|
    s.name             = "InstantSearch"
    s.module_name      = 'InstantSearch'
    s.version          = "5.2.2"
    s.summary          = "A library of widgets and helpers to build instant-search applications on iOS."
    s.homepage         = "https://github.com/algolia/instantsearch-ios"
    s.license          = { type: 'Apache 2.0', file: 'LICENSE.md' }
    s.author           = { "Algolia" => "contact@algolia.com" }
    s.source           = { git: "https://github.com/algolia/instantsearch-ios.git", tag: s.version.to_s }
    s.social_media_url = 'https://twitter.com/algolia'
    s.ios.deployment_target = '8.0'
    s.requires_arc = true
    s.default_subspec = "UI"
    s.swift_version = '5.0'
    s.swift_versions = ['4.0', '4.2', '5.0']

    s.subspec "UI" do |ss|
        ss.source_files = 'Sources/**/*.{swift}'
        ss.dependency 'InstantSearchCore', '~> 6.5'
    end

    s.subspec "Core" do |ss|
        ss.dependency 'InstantSearchCore', '~> 6.5'
    end

    s.subspec "Client" do |ss|
        ss.dependency 'InstantSearchClient', '~> 7.0'
    end

    # Dependencies
    # ------------
    s.dependency 'InstantSearchCore', '~> 6.5'
    s.dependency 'Logging'
end
