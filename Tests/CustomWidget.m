//
//  CustomWidget.m
//  InstantSearch
//
//  Created by Guy Daher on 12/05/2017.
//
//

@import Foundation;
@import UIKit;
@import InstantSearch;

@interface CustomWidget: UILabel <AlgoliaWidget, ResultingDelegate, RefinableDelegate, ResettableDelegate, SearchableViewModel>

@end

@implementation CustomWidget

- (void)onResults:(SearchResults * _Nullable)results error:(NSError * _Nullable)error userInfo:(NSDictionary<NSString *, id> * _Nonnull)userInfo {
    
}

- (void) onReset {
    
}

- (void) configureWith:(Searcher *)searcher {
    
}

@synthesize attribute;

@end
