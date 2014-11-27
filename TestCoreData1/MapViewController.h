//
//  MapViewController.h
//  AlphaProject
//
//  Created by CHRISTOPHER METCALF on 10/21/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataModel.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>


@interface MapViewController :UIViewController   <MKMapViewDelegate, CLLocationManagerDelegate>
@property (nonatomic, retain) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (strong, nonatomic) NSMutableArray* nearMeList;
@property (strong, nonatomic) NSMutableArray* DataModelList;
@property (strong, nonatomic) NSMutableArray* nearLocations;
#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
@end
