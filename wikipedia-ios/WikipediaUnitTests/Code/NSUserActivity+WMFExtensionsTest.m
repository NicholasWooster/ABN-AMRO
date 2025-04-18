#import <XCTest/XCTest.h>
#import "NSUserActivity+WMFExtensions.h"


@interface NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test : XCTestCase
@end

@implementation NSUserActivity_WMFExtensions_wmf_activityForWikipediaScheme_Test

- (void)testURLWithoutWikipediaSchemeReturnsNil {
    NSURL *url = [NSURL URLWithString:@"http://www.foo.com"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testInvalidArticleURLReturnsNil {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertNil(activity);
}

- (void)testArticleURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/wiki/Foo"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString, @"https://en.wikipedia.org/wiki/Foo");
}

- (void)testExploreURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://explore"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeExplore);
}

- (void)testHistoryURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://history"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeHistory);
}

- (void)testSavedURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://saved"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeSavedPages);
}

- (void)testSearchURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://en.wikipedia.org/w/index.php?search=dog"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypeLink);
    XCTAssertEqualObjects(activity.webpageURL.absoluteString,
                          @"https://en.wikipedia.org/w/index.php?search=dog&title=Special:Search&fulltext=1");
}

-(void)testPlacesURL {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places"];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssertNil(activity.userInfo[@"latitude"]);
    XCTAssertNil(activity.userInfo[@"longitude"]);
}

-(void)testPlacesURLWithLatitudeThenLongitude {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?lat=52.3547498&lon=4.8339215"]; // Amsterdam coords from JSON
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssert([activity.userInfo[@"latitude"] isEqualToNumber:@52.3547498]);
    XCTAssert([activity.userInfo[@"longitude"] isEqualToNumber:@4.8339215]);
}

-(void)testPlacesURLWithLongitudeThenLatitude {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?lon=4.8339215&lat=52.3547498"]; // Amsterdam coords from JSON
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssert([activity.userInfo[@"latitude"] isEqualToNumber:@52.3547498]);
    XCTAssert([activity.userInfo[@"longitude"] isEqualToNumber:@4.8339215]);
}

-(void)testPlacesURLWithOnlyLatitude {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?lat=52.3547498"]; // Amsterdam coords from JSON
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssertNil(activity.userInfo[@"latitude"]);
    XCTAssertNil(activity.userInfo[@"longitude"]);
}

-(void)testPlacesURLWithOnlyLongitude {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?lon=4.8339215"]; // Amsterdam coords from JSON
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssertNil(activity.userInfo[@"latitude"]);
    XCTAssertNil(activity.userInfo[@"longitude"]);
}

-(void)testPlacesURLWithEmptyLatitude {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?lat=&lon=4.8339215"]; // Amsterdam coords from JSON
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssertNil(activity.userInfo[@"latitude"]);
    XCTAssertNil(activity.userInfo[@"longitude"]);
}

-(void)testPlacesURLWithEmptyLongitude {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?lat=52.3547498&lon="]; // Amsterdam coords from JSON
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssertNil(activity.userInfo[@"latitude"]);
    XCTAssertNil(activity.userInfo[@"longitude"]);
}

-(void)testPlacesURLWithEmptyLatitudeAndEmptyLongitude {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?lat=&lon="];
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssertNil(activity.userInfo[@"latitude"]);
    XCTAssertNil(activity.userInfo[@"longitude"]);
}

-(void)testPlacesURLWithNegativeLatitudeAndNegativeLongitude {
    NSURL *url = [NSURL URLWithString:@"wikipedia://places?lat=-13.162968954389248&lon=-72.54470420525286"]; // Macu Pichu
    NSUserActivity *activity = [NSUserActivity wmf_activityForWikipediaScheme:url];
    
    XCTAssertEqual(activity.wmf_type, WMFUserActivityTypePlaces);
    XCTAssertNil(activity.webpageURL);
    XCTAssert([activity.userInfo[@"latitude"] isEqualToNumber:@-13.162968954389248]);
    XCTAssert([activity.userInfo[@"longitude"] isEqualToNumber:@-72.54470420525286]);
}

@end

