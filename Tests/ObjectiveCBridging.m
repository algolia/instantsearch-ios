//
//  ObjectiveCBridging.m
//  InstantSearch
//
//  Created by Guy Daher on 12/05/2017.
//
//

#import <XCTest/XCTest.h>

@import InstantSearch;


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

- (void)testInstantSearch {
    //InstantSearch* instantSearch = [[InstantSearch alloc] init]
}

@end
