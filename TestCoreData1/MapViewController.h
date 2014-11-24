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


@interface MapViewController : UIViewController <MKMapViewDelegate, CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
