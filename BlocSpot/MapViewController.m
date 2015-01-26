//
//  MapViewController.m
//  BlocSpot
//
//  Created by Jonathan Jungemann on 12/2/14.
//  Copyright (c) 2014 Jon Jungemann. All rights reserved.
//

#import "MapViewController.h"
#import "InterestPoints.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface MapViewController ()

@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKUserLocation *userLocation;
@property (strong, nonatomic) NSMutableArray *annotations;

@end

@implementation MapViewController

- (void)loadView {
    self.view = [UIView new];
    
    CGRect screenBounds = [[UIScreen mainScreen] bounds];
    NSInteger viewWidth = screenBounds.size.width;
    NSInteger viewHeight = screenBounds.size.height;
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(0, 0, viewWidth, viewHeight)];
    
    self.locationManager = [[CLLocationManager alloc] init];
    
    [self.locationManager requestWhenInUseAuthorization];
    
    self.userLocation = [[MKUserLocation alloc] init];
    
    self.mapView.userTrackingMode = YES;
    
    [self.view addSubview:self.mapView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) searchMapWith:(NSString *) searchInfo {
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchInfo;
    request.region = _mapView.region;
    
    self.annotations = [[NSMutableArray alloc] init];
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    
    [search startWithCompletionHandler:^(MKLocalSearchResponse
                                         *response, NSError *error) {
        if (response.mapItems.count == 0)
            NSLog(@"No Matches");
        else
            for (MKMapItem *item in response.mapItems) {
                [self.annotations addObject:item];
                InterestPoints *interestPoint = [[InterestPoints alloc]init];
                interestPoint.coordinates = item.placemark.coordinate;
                interestPoint.name = item.name;
                interestPoint.phoneNumber = item.phoneNumber;
                [self.mapView addAnnotation:interestPoint];
            }
    }];
}

-(void)cancelSearch {
    NSArray *existingAnnotations = self.mapView.annotations;
    [self.mapView removeAnnotations:existingAnnotations];
    self.annotations = [NSMutableArray new];
}

@end