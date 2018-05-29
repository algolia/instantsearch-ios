//
//  ObjectiveCBridging.m
//  InstantSearch
//
//  Created by Guy Daher on 12/05/2017.
//
//

#import <XCTest/XCTest.h>

@import InstantSearch;
@import InstantSearchClient;
@import InstantSearchCore;

/// Verifies that all the features are accessible from Objective-C.
///
/// Warning: This tests mostly **compilation**! The behavior is already tested in Swift test cases.
///
/// Note: Only the public API is tested here.
@interface ObjectiveCBridgingTests: XCTestCase

@end


@implementation ObjectiveCBridgingTests

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
    HitsTableWidget* hitsTableWidget = [[HitsTableWidget alloc] initWithFrame:defaultRect style:UITableViewStylePlain];
    hitsTableWidget.hitsPerPage = 10;
    hitsTableWidget.infiniteScrolling = true;
    hitsTableWidget.remainingItemsBeforeLoading = 5;
    hitsTableWidget.showItemsOnEmptyQuery = true;
    
    HitsCollectionWidget* hitsCollectionWidget = [[HitsCollectionWidget alloc] initWithFrame: defaultRect collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    hitsCollectionWidget.hitsPerPage = 10;
    hitsCollectionWidget.infiniteScrolling = true;
    hitsCollectionWidget.remainingItemsBeforeLoading = 5;
    hitsCollectionWidget.showItemsOnEmptyQuery = true;
    
    RefinementTableWidget* refinementTableWidget = [[RefinementTableWidget alloc] initWithFrame: defaultRect];
    refinementTableWidget.attribute = @"attribute";
    refinementTableWidget.refinedFirst = true;
    refinementTableWidget.operator = @"and";
    refinementTableWidget.sortBy = @"count:desc";
    refinementTableWidget.limit = 5;
    
    RefinementCollectionWidget* refinementCollectionWidget = [[RefinementCollectionWidget alloc] initWithFrame: defaultRect collectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    refinementCollectionWidget.attribute = @"attribute";
    refinementCollectionWidget.refinedFirst = true;
    refinementCollectionWidget.operator = @"and";
    refinementCollectionWidget.sortBy = @"count:desc";
    refinementCollectionWidget.limit = 5;
    
    SliderWidget* sliderWidget = [[SliderWidget alloc] initWithFrame: defaultRect];
    sliderWidget.attribute = @"attribute";
    sliderWidget.operator = @">";
    sliderWidget.inclusive = true;
    
    StepperWidget* stepperWidget = [[StepperWidget alloc] initWithFrame: defaultRect];
    stepperWidget.attribute = @"attribute";
    stepperWidget.operator = @">";
    stepperWidget.inclusive = true;
    
    DatePickerWidget* datePickerWidget = [[DatePickerWidget alloc] initWithFrame: defaultRect];
    datePickerWidget.attribute = @"attribute";
    datePickerWidget.operator = @">";
    datePickerWidget.inclusive = true;
    
    OneValueSwitchWidget* oneValueSwitchWidget = [[OneValueSwitchWidget alloc] initWithFrame: defaultRect];
    oneValueSwitchWidget.attribute = @"attribute";
    oneValueSwitchWidget.valueOn = @"true";
    oneValueSwitchWidget.inclusive = true;
    
    TwoValuesSwitchWidget* twoValueSwitchWidget = [[TwoValuesSwitchWidget alloc] initWithFrame: defaultRect];
    twoValueSwitchWidget.attribute = @"attribute";
    twoValueSwitchWidget.valueOn = @"true";
    twoValueSwitchWidget.valueOff = @"false";
    twoValueSwitchWidget.inclusive = true;
    
    SegmentedControlWidget* segmentedControlWidget = [[SegmentedControlWidget alloc] initWithFrame: defaultRect];
    segmentedControlWidget.attribute = @"attribute";
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
    
    [instantSearch registerAllWidgetsIn: view doSearch: false];
    
    StatsLabelWidget* statsLabelWidget = [[StatsLabelWidget alloc] initWithFrame: defaultRect];
    [instantSearch registerWithWidget:statsLabelWidget];
    
    StatsButtonWidget* statsButtonWidget = [[StatsButtonWidget alloc] initWithFrame: defaultRect];
    [instantSearch registerWithWidget: statsButtonWidget doSearch:true];
    
    [instantSearch registerWithSearchBar: [[UISearchBar alloc] initWithFrame: defaultRect]];
    [instantSearch registerWithSearchController: [[UISearchController alloc] init]];
}

- (Searcher*)getSearcher {
    Client* client = [[Client alloc] initWithAppID:@"APPID" apiKey:@"APIKEY"];
    Index* index = [client indexWithName:@"INDEX_NAME"];
    Searcher* searcher = [[Searcher alloc] initWithIndex:index];
    return searcher;
}

- (void)testViewControllers {
    HitsController* hitsController __unused = [[HitsController alloc] initWithTable: [[HitsTableWidget alloc] initWithFrame: defaultRect]];
    RefinementController* refinementController __unused = [[RefinementController alloc] initWithTable: [[RefinementTableWidget alloc] initWithFrame: defaultRect]];
    
    HitsCollectionViewController* hitsCollectionViewController __unused = [[HitsCollectionViewController alloc] init];
    HitsTableViewController* hitsTableViewController __unused = [[HitsTableViewController alloc] init];
    RefinementCollectionViewController* refinementCollectionViewController __unused = [[RefinementCollectionViewController alloc] init];
    RefinementTableViewController* refinementTableViewController __unused = [[RefinementTableViewController alloc] init];
}

@end
