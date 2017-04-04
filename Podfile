# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

use_frameworks!

def instantsearch_core
    pod "InstantSearch-Core-Swift", :path => '/Users/guydaher/Developer/Algolia/iOS/instantsearch-core-swift'
end

target 'InstantSearch' do
  instantsearch_core
  
  target 'InstantSearchTests' do
      inherit! :search_paths
  end
  
  target 'Example' do
      workspace 'InstantSearch.xcworkspace'
      project 'Example/Example.xcodeproj'
      instantsearch_core
  end
end
