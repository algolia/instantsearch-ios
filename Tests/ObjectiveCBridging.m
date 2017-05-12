//
//  ObjectiveCBridging.m
//  InstantSearch
//
//  Created by Guy Daher on 12/05/2017.
//
//

#import <XCTest/XCTest.h>

@import InstantSearch;
@import AlgoliaSearch;
@import InstantSearchCore;


/// Verifies that all the features are accessible from Objective-C.
///
/// Warning: This tests mostly **compilation**! The behavior is already tested in Swift test cases.
///
/// Note: Only the public API is tested here.
@interface ObjectiveCBridging: XCTestCase

@end


@implementation ObjectiveCBridging

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitInstantSearchWithConfigure {
    InstantSearch* instantSearch = [[InstantSearch alloc] initWithAppID:@"appID" apiKey:@"apiKey" index:@"index"];
    
    XCTAssertNotNil(instantSearch.searcher);
}

- (void)testInitInstantSearchWithSearcher {
    InstantSearch* instantSearch = [[InstantSearch alloc] initWithSearcher: [self getSearcher]];
    
    XCTAssertNotNil(instantSearch.searcher);
}

- (Searcher*)getSearcher {
    Client* client = [[Client alloc] initWithAppID:@"APPID" apiKey:@"APIKEY"];
    Index* index = [client indexWithName:@"INDEX_NAME"];
    Searcher* searcher = [[Searcher alloc] initWithIndex:index];
    return searcher;
}

@end
