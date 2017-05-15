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

CGRect defaultRect;

- (void)setUp {
    [super setUp];
    defaultRect = CGRectMake(0, 0, 10, 10);
}

- (void)tearDown {
    [super tearDown];
}

- (void)testInitInstantSearchWithConfigure {
    InstantSearch* instantSearch __unused = [[InstantSearch alloc] initWithAppID:@"appID" apiKey:@"apiKey" index:@"index"];
}

- (void)testInitInstantSearchWithSearcher {
    InstantSearch* instantSearch __unused = [[InstantSearch alloc] initWithSearcher: [self getSearcher]];
}

- (void) testWidgets {
    HitsTableWidget* hitsTableWidget = [[HitsTableWidget alloc] initWithFrame: defaultRect];
    hitsTableWidget.hitsPerPage = 10;
    hitsTableWidget.infiniteScrolling = true;
    hitsTableWidget.remainingItemsBeforeLoading = 5;
    
    HitsCollectionWidget* hitsCollectionWidget = [[HitsCollectionWidget alloc] initWithFrame: defaultRect collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    hitsCollectionWidget.hitsPerPage = 10;
    hitsCollectionWidget.infiniteScrolling = true;
    hitsCollectionWidget.remainingItemsBeforeLoading = 5;
    
    RefinementTableWidget* refinementTableWidget = [[RefinementTableWidget alloc] initWithFrame: defaultRect];
    refinementTableWidget.attribute = @"attributeName";
    refinementTableWidget.refinedFirst = true;
    refinementTableWidget.operator = @"and";
    refinementTableWidget.sortBy = @"count:desc";
    refinementTableWidget.limit = 5;
    
    RefinementCollectionWidget* refinementCollectionWidget = [[RefinementCollectionWidget alloc] initWithFrame: defaultRect collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    refinementCollectionWidget.attribute = @"attributeName";
    refinementCollectionWidget.refinedFirst = true;
    refinementCollectionWidget.operator = @"and";
    refinementCollectionWidget.sortBy = @"count:desc";
    refinementCollectionWidget.limit = 5;
    
    SliderWidget* sliderWidget = [[SliderWidget alloc] initWithFrame: defaultRect];
    sliderWidget.attributeName = @"attributeName";
    sliderWidget.operation = @">";
    sliderWidget.inclusive = true;
    
    StepperWidget* stepperWidget = [[StepperWidget alloc] initWithFrame: defaultRect];
    stepperWidget.attributeName = @"attributeName";
    stepperWidget.operation = @">";
    stepperWidget.inclusive = true;
    
    DatePickerWidget* datePickerWidget = [[DatePickerWidget alloc] initWithFrame: defaultRect];
    datePickerWidget.attributeName = @"attributeName";
    datePickerWidget.operation = @">";
    datePickerWidget.inclusive = true;
    
    OneValueSwitchWidget* oneValueSwitchWidget = [[OneValueSwitchWidget alloc] initWithFrame: defaultRect];
    oneValueSwitchWidget.attributeName = @"attributeName";
    oneValueSwitchWidget.valueOn = @"true";
    oneValueSwitchWidget.inclusive = true;
    
    TwoValuesSwitchWidget* twoValueSwitchWidget = [[TwoValuesSwitchWidget alloc] initWithFrame: defaultRect];
    twoValueSwitchWidget.attributeName = @"attributeName";
    twoValueSwitchWidget.valueOn = @"true";
    twoValueSwitchWidget.valueOff = @"false";
    twoValueSwitchWidget.inclusive = true;
    
    SegmentedControlWidget* segmentedControlWidget = [[SegmentedControlWidget alloc] initWithFrame: defaultRect];
    segmentedControlWidget.attributeName = @"attributeName";
    segmentedControlWidget.inclusive = true;
    
    StatsButtonWidget* statsButtonWidget = [[StatsButtonWidget alloc] initWithFrame: defaultRect];
    statsButtonWidget.resultTemplate = @"{nbHits} test";
    statsButtonWidget.clearText = @"";
    statsButtonWidget.errorText = @"Error!";
    
    StatsLabelWidget* statsLabelWidget = [[StatsLabelWidget alloc] initWithFrame: defaultRect];
    statsLabelWidget.resultTemplate = @"{nbHits} test";
    statsLabelWidget.clearText = @"";
    statsLabelWidget.errorText = @"Error!";
    
    StatsLabelController* statsLabelController = [[StatsLabelController alloc] initWithLabel:[[UILabel alloc] initWithFrame: defaultRect]];
    statsLabelController.resultTemplate = @"{nbHits} test";
    statsLabelController.clearText = @"";
    statsLabelController.errorText = @"Error!";
    
    ActivityIndicatorWidget* activityIndicatorWidget = [[ActivityIndicatorWidget alloc] initWithFrame: defaultRect];
    SearchBarWidget* searchBarWidget = [[SearchBarWidget alloc] initWithFrame: defaultRect];
    activityIndicatorWidget.hidden = false;
    searchBarWidget.placeholder = @"Search here...";    
}

- (void)testAddWidgets {
    InstantSearch* instantSearch = [[InstantSearch alloc] initWithAppID:@"appID" apiKey:@"apiKey" index:@"index"];
    
    UIView* view = [[UIView alloc] initWithFrame: CGRectMake(0, 0, 100, 100)];
    HitsTableWidget* hitsTableWidget = [[HitsTableWidget alloc] initWithFrame: defaultRect];
    [view addSubview:hitsTableWidget];
    
    [instantSearch addAllWidgetsIn: view doSearch: false];
    
    StatsLabelWidget* statsLabelWidget = [[StatsLabelWidget alloc] initWithFrame: defaultRect];
    [instantSearch addWithWidget:statsLabelWidget];
    
    StatsButtonWidget* statsButtonWidget = [[StatsButtonWidget alloc] initWithFrame: defaultRect];
    [instantSearch addWithWidget: statsButtonWidget doSearch:true];
    
    [instantSearch addWithSearchBar: [[UISearchBar alloc] initWithFrame: defaultRect]];
    [instantSearch addWithSearchController: [[UISearchController alloc] init]];
}

- (Searcher*)getSearcher {
    Client* client = [[Client alloc] initWithAppID:@"APPID" apiKey:@"APIKEY"];
    Index* index = [client indexWithName:@"INDEX_NAME"];
    Searcher* searcher = [[Searcher alloc] initWithIndex:index];
    return searcher;
}

- (void)testViewControllers {
    HitsViewController* hitsViewController __unused = [[HitsViewController alloc] initWithTable: [[HitsTableWidget alloc] initWithFrame: defaultRect]];
    RefinementViewController* refinementViewController __unused = [[RefinementViewController alloc] initWithTable: [[RefinementTableWidget alloc] initWithFrame: defaultRect]];
    
    HitsCollectionViewController* hitsCollectionViewController __unused = [[HitsCollectionViewController alloc] init];
    HitsTableViewController* hitsTableViewController __unused = [[HitsTableViewController alloc] init];
    RefinementCollectionViewController* refinementCollectionViewController __unused = [[RefinementCollectionViewController alloc] init];
    RefinementTableViewController* refinementTableViewController __unused = [[RefinementTableViewController alloc] init];
}

@end
