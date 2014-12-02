//
//  MapViewController.m
//  AlphaProject
//
//  Created by CHRISTOPHER METCALF on 10/21/14.
//  Copyright (c) 2014 Infinity Software. All rights reserved.
//

#import "MapViewController.h"
#import "Annotation.h"


@interface MapViewController()


@property (nonatomic, retain) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) CLGeocoder *reverseGeocoder;


@property (nonatomic, strong) CLPlacemark *placemark;

@property (nonatomic, strong) MKCircle *circleOverlay;
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, assign) BOOL mapPinsPlaced;
@property (nonatomic, assign) BOOL mapPannedSinceLocationUpdate;
@property (nonatomic, assign) CLLocationAccuracy filterDistance;

@property (nonatomic, strong) NSMutableArray* list;

@end

@implementation MapViewController
@synthesize mapView;
#define THE_SPAN 0.01f;

/*
-(id)initWithCoder:(NSCoder *)aCoder {
    self = [super initWithCoder:aCoder];
    if (self) {
        // Customize the table
        
        // The className to query on
        self.parseClassName = @"FoodEvent";
        [self loadModelData];
    }
    return self;
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    mapView.delegate = self;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    #ifdef __IPHONE_8_0
    if(IS_OS_8_OR_LATER) {
        // Use one or the other, not both. Depending on what you put in info.plist
        //[self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
    }
    #endif
    [_locationManager startUpdatingLocation];
    
    mapView.showsUserLocation = YES;
    [mapView setMapType:MKMapTypeStandard];
    [mapView setZoomEnabled:YES];
    [mapView setScrollEnabled:YES];
    
    self.list = [[NSMutableArray alloc] init];
    /*
    CLLocationManager * locationManager = [[CLLocationManager alloc] init];
    [locationManager requestAlwaysAuthorization];
    //[locationManager requestWhenInUseAuthorization];
    
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [locationManager startUpdatingLocation];
    float myLatitude = locationManager.location.coordinate.latitude;
    float myLongitude = locationManager.location.coordinate.longitude;
    
    
    MKCoordinateRegion myRegion;
    CLLocationCoordinate2D center;
    center.latitude = myLatitude;
    center.longitude = myLongitude;
    MKCoordinateSpan mySpan;
    mySpan.latitudeDelta = THE_SPAN;
    mySpan.longitudeDelta = THE_SPAN;
    myRegion.center = center;
    myRegion.span = mySpan;
    
    //self.mapView.delegate = self;
    //[self.mapView setShowsUserLocation:YES];
    
    // Start location updates
    //[self.locationManager startUpdatingLocation];
    
    // Cache any current location info
    //CLLocation *currentLocation = _locationManager.location;
    //if (currentLocation) {
    //    self.currentLocation = currentLocation;
    //}
    
    //self.mapPannedSinceLocationUpdate = NO;
    // Do any additional setup after loading the view.
    
    //Annotation
    //Create coordinate for use with annotation
    CLLocationCoordinate2D myLocation;
    myLocation.latitude = myLatitude;
    myLocation.longitude = myLongitude;
    Annotation *myAnnotation = [Annotation alloc];
    myAnnotation.coordinate = myLocation;
    //myAnnotation.title = @"Me";
    [self.mapView addAnnotation:myAnnotation];
    
    */
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:YES];
    
    self.locationManager.distanceFilter = 50;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager startUpdatingLocation];
    NSLog(@"%@", [self deviceLocation]);
    
    //View Area
    MKCoordinateRegion region = { { 0.0, 0.0 }, { 0.0, 0.0 } };
    region.center.latitude = self.locationManager.location.coordinate.latitude;
    region.center.longitude = self.locationManager.location.coordinate.longitude;
    region.span.longitudeDelta = 0.003f;
    region.span.longitudeDelta = 0.003f;
    [mapView setRegion:region animated:YES];
    NSString* test = [self deviceLat];
    NSLog(@"Latitude test is %@", test);
    [self loadModelData];
    
}

- (void)loadModelData
{
    self.nearLocations = [NSMutableArray new];
    self.DataModelList = [NSMutableArray new];
    self.nearMeList = [NSMutableArray new];
    
    PFQuery *query = [PFQuery queryWithClassName:@"FoodEvent"];
    [query addAscendingOrder:@"pickedDate"];
    [query addAscendingOrder:@"pickedTime"];
    //[query orderByAscending:@"pickedTime"];
    NSArray *parse_list = [query findObjects];
    
    for (PFObject *obj in parse_list) {
        DataModel *dm = [[DataModel alloc] init];
        dm.event = obj[@"event"];
        //NSLog(@"obj name: %@", obj[@"name"]);
        //  int count = 0;
        //    for (NSString *address in pickerDataWhere)
        //    {
        //        if ([[self.where text] isEqualToString:address])
        //        {
        //            _d1.where = [pickerAddress objectAtIndex:count];
        //        }
        //        count = count + 1;
        
        dm.where = obj[@"where"];
        dm.buildingName = obj[@"buildingName"];
        dm.pickedTime = obj[@"pickedTime"];
        dm.pickedDate = obj[@"pickedDate"];
        dm.food = obj[@"food"];
        //dm.date =obj[@"date"];
        [self.DataModelList addObject:dm];
        
    }
    
    
    NSDate *current = [NSDate date];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    
    //[[NSDate alloc] init];
    
    
    NSString *theDate = [dateFormat stringFromDate:current];
    
    NSDateFormatter *hourFormat = [[NSDateFormatter alloc] init];
    [hourFormat setDateFormat:@"HH"];
    NSDateFormatter *minuteFormat = [[NSDateFormatter alloc] init];
    [minuteFormat setDateFormat:@"mm"];
    NSString *theHour = [hourFormat stringFromDate:current];
    NSString *theMinute = [minuteFormat stringFromDate:current];
    NSLog(@"the hour is %@\n", theHour);
    int valueHour = [theHour intValue];
    int valueMinute = [theMinute intValue];
    int numEvents = [self.DataModelList count];
    
    
    for (int i = 0; i < numEvents; i++) {
        DataModel *dm = [[DataModel alloc] init];
        dm = _DataModelList[i];
        NSString *str = dm.pickedTime;
        NSString *eventDate = dm.pickedDate;
        str = [str substringToIndex: 2];
        //NSLog(@"the event is %@\n", dm.event);
        int testedHour = [str intValue];
        //if ([str isEqualToString: theHour])
        if ([eventDate isEqualToString:theDate] && (testedHour == valueHour || testedHour == (valueHour + 1)))
        {
            NSLog(@"///////////////////////");
            [_nearLocations addObject:dm];
            //NSLog(@"today events are %@", dm.event);
            NSLog(@"today events are %@", [[self.nearLocations objectAtIndex:0]event]);
        }
        //NSLog(@"today events outside if are %@", [[self.todayEvents objectAtIndex:0]event]);
        //NSLog(@"today count is %d", [self.nearLocations count]);
    }
    //NSLog(@"today count is %d", [self.nearLocations count]);
    NSLog(@"********************************");
    //CLLocationCoordinate2D test = [self geocodeAddressString:[[self.nearLocations objectAtIndex:0]where]];
    //NSLog(@"TEST latitude is %f and longitude is %f", test.latitude, test.longitude);
    //[self geocodeAddressString: @"950 West 5th St, Austin, TX 78703"];
    NSLog(@"++++++++++++++++++++++++++++++++++");
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"in didupdateUser");
    //Get coordinates
    CLLocationCoordinate2D myLocation = [userLocation coordinate];
    CLLocation* user = [[CLLocation alloc] initWithLatitude:myLocation.latitude longitude:myLocation.longitude];
    
    //Define Zoom regionu
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(myLocation, 500, 500);
    //Show our location
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    if ([self.list count] > 1)
    {
        NSLog(@"here in list");
        //MKPointAnnotation *removedPoint = [self.list objectAtIndex:0];
        [self.mapView removeAnnotations:self.list];
        //[self.list removeObjectAtIndex:0];
    }
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    point.coordinate = userLocation.coordinate;
    point.title = @"Where am I?";
    point.subtitle = @"I'm here!!!";
    [self.mapView addAnnotation:point];
    NSLog(@"count is %d",[self.list count]);
    [self.list addObject:point];
    
    
    //[self reverseGeocode:user];
    
    CLLocationAccuracy accuracy = 1500;
    [self queryForAllEventsNearLocation:user withNearbyDistance:accuracy];
    
    [self reverseGeocode:user];
    
    //MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 800, 800);
    //[self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
}

- (void)reverseGeocode:(CLLocation *)location {
    CLGeocoder *reverseGeocoder = [[CLGeocoder alloc] init];
    [reverseGeocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Finding address");
        if (error) {
            NSLog(@"Error %@", error.description);
        } else {
            self.placemark = [placemarks lastObject];
            self.addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                      _placemark.subThoroughfare, _placemark.thoroughfare,
                                      _placemark.postalCode, _placemark.locality,
                                      _placemark.administrativeArea,
                                      _placemark.country];
            //[self geocodeAddressString: self.addressLabel.text];
            //NSLog(@"//////////////////////////////");
            //[self geocodeAddressString: @"1 Infinite Loop, Cupertino, CA 95014"];
        }
    }];
    
}

-(NSString*)grabStreetAddress:(NSString*) address
{
    NSArray *subStrings = [address componentsSeparatedByString:@","];
    for (int i = 0; i < [subStrings count]; i++)
    {
        NSLog(@"string on array position %d is : %@", i, [subStrings objectAtIndex:i]);
    }
    return [subStrings objectAtIndex:0];
}

-(CLLocationCoordinate2D)geocodeAddressString:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance withAddress: (NSString*)myStringLocation{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    __block CLLocationCoordinate2D center;
    NSLog(@"Address is %@", myStringLocation);
    
    [geocoder geocodeAddressString:myStringLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        if (error) {
            NSLog(@"%@", error);
        }
        else
        {
            NSLog(@"Address111 is %@", myStringLocation);
            CLPlacemark *placemark = [placemarks lastObject];
            MKCoordinateRegion region;
            region.center.latitude = placemark.location.coordinate.latitude;
            region.center.longitude = placemark.location.coordinate.longitude;
            //center.latitude = placemark.location.coordinate.latitude;
            //center.longitude = placemark.location.coordinate.longitude;
            NSLog(@"Latitude is %@", [NSString stringWithFormat:@"%f", region.center.latitude]);
            NSLog(@"Longitude is %@", [NSString stringWithFormat:@"%f", region.center.longitude]);
            
            CLLocation *eventLatLog = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
            CLLocationDistance distanceLocMeters = [currentLocation distanceFromLocation:eventLatLog];
            NSLog(@"event is distance is %f", distanceLocMeters);
            if (distanceLocMeters <= nearbyDistance)
            {
                int numEventsNearMe = [self.nearLocations count];
                for (DataModel* event in self.nearLocations)
                {
                    //DataModel *event = [[DataModel alloc] init];
                    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                    if (event.where == myStringLocation)
                    {
                        point.coordinate = eventLatLog.coordinate;
                        point.title = event.event;
                        //point.subtitle = [self grabStreetAddress: event.where];
                        point.subtitle = [self grabStreetAddress:event.buildingName];
                        [self.mapView addAnnotation:point];
                    }
        
                }
            }
        }
    }];
    
    
    return center;
}
/*

-(CLLocationCoordinate2D)locateAddress:(NSString*) address {
    
    NSString *location = address;
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:location
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         MKPlacemark *placemark = [[MKPlacemark alloc] initWithPlacemark:topResult];
                         
                         CLLocationCoordinate2D coordinate;
                         coordinate.latitude = topResult.location.coordinate.latitude;
                         coordinate.longitude = topResult.location.coordinate.longitude;
                         
                         MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
                         point.coordinate = placemark.coordinate;
                         point.title = @"MK Software Solutions LLC";
                         point.subtitle =@"test";
                         
                         NSLog(@"Lat: %f, Long: %f", coordinate.latitude, coordinate.longitude);
                         MKCoordinateRegion region;
                         region.center = [(CLCircularRegion *)placemark.region center];
                         MKCoordinateSpan span;
                         span.latitudeDelta=.005;
                         span.longitudeDelta=.005;
                         region.span = span;
                         [self.mapView setRegion:region animated:YES];
                         
                         
                         [self.mapView addAnnotation:point];
                     }
                 }
     ];
}

*/
/*
- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation {
    NSLog(@"in didupdatetoLocation");
    
    //self.reverseGeocoder =[[MKReverseGeocoder alloc] initWithCoordinate:newLocation.coordinate];
    //_reverseGeocoder.delegate=self;
    //[self.reverseGeocoder start];
    
    
    self.currentLocation = newLocation;
    [self reverseGeocode:self.currentLocation];
 
    [self.geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
     
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil) {
            NSLog(@"here");
            self.placemark = [placemarks lastObject];
            self.addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                 _placemark.subThoroughfare, _placemark.thoroughfare,
                                 _placemark.postalCode, _placemark.locality,
                                 _placemark.administrativeArea,
                                 _placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
}
*/

- (NSString *)deviceLocation {
    return [NSString stringWithFormat:@"latitude: %f longitude: %f", self.locationManager.location.coordinate.latitude, self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceLat {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.latitude];
}
- (NSString *)deviceLon {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.coordinate.longitude];
}
- (NSString *)deviceAlt {
    return [NSString stringWithFormat:@"%f", self.locationManager.location.altitude];
}


/*
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
*/
-(void) viewDidUnload
{
    [self setMapView:nil];
    [super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    [self.locationManager startUpdatingLocation];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [self.locationManager stopUpdatingLocation];
}

- (CLLocationManager *)locationManager {
    if (_locationManager == nil)
    {
        _locationManager = [[CLLocationManager alloc] init];
        
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        // Set a movement threshold for new events.
        _locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
    }
    return _locationManager;
}
/*
- (IBAction)addToMap:(id)sender{
    
    __block NSArray *annotations;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        annotations = [self queryForAllEventsNearLocation:u withNearbyDistance:<#(CLLocationAccuracy)#>];
        
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            
            [self.mapView addAnnotations:annotations];
            
        });
    });
    
}

- (NSMutableArray *)parseJSONCities{
    
    NSMutableArray *retval = [[NSMutableArray alloc]init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"capitals"
                                                         ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:jsonPath];
    NSError *error = nil;
    NSArray *json = [NSJSONSerialization JSONObjectWithData:data
                                                    options:kNilOptions
                                                      error:&error];
    
    
}
*/
- (void)queryForAllEventsNearLocation:(CLLocation *)currentLocation withNearbyDistance:(CLLocationAccuracy)nearbyDistance {
    
    if (currentLocation == nil) {
        NSLog(@"%s got a nil location!", __PRETTY_FUNCTION__);
    }
    int numEvents = [self.nearLocations count];
    NSLog(@"YYYYYYYYYYYYYYYYYYYYYYYYY");
    //[self geocodeAddressString:[[self.nearLocations objectAtIndex:0]where]];
    //NSLog(@"Address is %@", [[self.nearLocations objectAtIndex:0]where]);
    NSLog(@"YYYYYYYYYYYYYYYYYYYYYYYYY");
    
    for (int i = 0; i < numEvents; i++) {
        //DataModel *event = [[DataModel alloc] init];
        NSString* location = [[self.nearLocations objectAtIndex:i]where];
        //[self queryForAllEventsNearLocation:user withNearbyDistance:accuracy];
        [self geocodeAddressString:currentLocation withNearbyDistance:nearbyDistance withAddress:location];
        //CLLocationCoordinate2D eventLocation = [self geocodeAddressString:[[self.nearLocations objectAtIndex:i]where]];
        /*l
        //NSLog(@"Latitude is %@", [NSString stringWithFormat:@"%f", region.center.latitude]);
        NSLog(@"latitude is %f and longitude is %f", eventLocation.latitude, eventLocation.longitude);
        CLLocation *eventLatLog = [[CLLocation alloc] initWithLatitude:eventLocation.latitude longitude:eventLocation.longitude];
        CLLocationDistance distanceLocMeters = [currentLocation distanceFromLocation:eventLatLog];
        NSLog(@"event is distance is %f", distanceLocMeters);
        if (distanceLocMeters <= nearbyDistance)
        {
            [_nearMeList addObject:event];
            NSLog(@"in query and list is %@", event.event);
        }
         */
    }
    /*
    int numEventsNearMe = [self.nearMeList count];
    for (int j = 0; j < numEventsNearMe; j++)
    {
        DataModel *event = [[DataModel alloc] init];
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        CLLocationCoordinate2D eventLocation = [self geocodeAddressString:[[self.nearLocations objectAtIndex:j]where]];
        NSLog(@"MMMmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmmm");
        CLLocation *eventLatLog = [[CLLocation alloc] initWithLatitude:eventLocation.latitude longitude:eventLocation.longitude];
        //NSLog(@"lat is %d and long is %d", self.eventLatLog->latitude, self.eventLatLog->longitude);
        point.coordinate = eventLatLog.coordinate;
        point.title = event.event;
        point.subtitle = event.where;
        [self.mapView addAnnotation:point];
    }
     */
}
/*
        JFMapAnnotation *temp = [[JFMapAnnotation alloc]init];
        [temp setTitle:[record valueForKey:@"Capital"]];
        [temp setSubtitle:[record valueForKey:@"Country"]];
        [temp setCoordinate:CLLocationCoordinate2DMake([[record valueForKey:@"Latitude"]floatValue], [[record valueForKey:@"Longitude"]floatValue])];
        [retval addObject:temp];
  */

/*
    return retval;
    // Query for posts sort of kind of near our current location.
    PFGeoPoint *point = [PFGeoPoint geoPointWithLatitude:currentLocation.coordinate.latitude longitude:currentLocation.coordinate.longitude];
    [query whereKey:PAWParsePostLocationKey nearGeoPoint:point withinKilometers:PAWWallPostMaximumSearchDistance];
    [query includeKey:PAWParsePostUserKey];
    query.limit = PAWWallPostsSearchDefaultLimit;
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"error in geo query!"); // todo why is this ever happening?
        } else {
            // We need to make new post objects from objects,
            // and update allPosts and the map to reflect this new array.
            // But we don't want to remove all annotations from the mapview blindly,
            // so let's do some work to figure out what's new and what needs removing.
            
            // 1. Find genuinely new posts:
            NSMutableArray *newPosts = [[NSMutableArray alloc] initWithCapacity:PAWWallPostsSearchDefaultLimit];
            // (Cache the objects we make for the search in step 2:)
            NSMutableArray *allNewPosts = [[NSMutableArray alloc] initWithCapacity:[objects count]];
            for (PFObject *object in objects) {
                PAWPost *newPost = [[PAWPost alloc] initWithPFObject:object];
                [allNewPosts addObject:newPost];
                if (![_allPosts containsObject:newPost]) {
                    [newPosts addObject:newPost];
                }
            }
            // newPosts now contains our new objects.
            
            // 2. Find posts in allPosts that didn't make the cut.
            NSMutableArray *postsToRemove = [[NSMutableArray alloc] initWithCapacity:PAWWallPostsSearchDefaultLimit];
            for (PAWPost *currentPost in _allPosts) {
                if (![allNewPosts containsObject:currentPost]) {
                    [postsToRemove addObject:currentPost];
                }
            }
            // postsToRemove has objects that didn't come in with our new results.
            
            // 3. Configure our new posts; these are about to go onto the map.
            for (PAWPost *newPost in newPosts) {
                CLLocation *objectLocation = [[CLLocation alloc] initWithLatitude:newPost.coordinate.latitude
                                                                        longitude:newPost.coordinate.longitude];
                // if this post is outside the filter distance, don't show the regular callout.
                CLLocationDistance distanceFromCurrent = [currentLocation distanceFromLocation:objectLocation];
                [newPost setTitleAndSubtitleOutsideDistance:( distanceFromCurrent > nearbyDistance ? YES : NO )];
                // Animate all pins after the initial load:
                newPost.animatesDrop = self.mapPinsPlaced;
            }
            
            // At this point, newAllPosts contains a new list of post objects.
            // We should add everything in newPosts to the map, remove everything in postsToRemove,
            // and add newPosts to allPosts.
            [self.mapView removeAnnotations:postsToRemove];
            [self.mapView addAnnotations:newPosts];
            
            [_allPosts addObjectsFromArray:newPosts];
            [_allPosts removeObjectsInArray:postsToRemove];
            
            self.mapPinsPlaced = YES;
        }
    }];
}

/*

- (void)startStandardUpdates {
    [self.locationManager startUpdatingLocation];
    
    CLLocation *currentLocation = self.locationManager.location;
    if (currentLocation) {
        self.currentLocation = currentLocation;
    }
}

- (void)setCurrentLocation:(CLLocation *)currentLocation {
    if (self.currentLocation == currentLocation) {
        return;
    }
    
    _currentLocation = currentLocation;
    
    //dispatch_async(dispatch_get_main_queue(), ^{
    //    [[NSNotificationCenter defaultCenter] postNotificationName:PAWCurrentLocationDidChangeNotification
     //                                                       object:nil
     //                                                     userInfo:@{ kPAWLocationKey : currentLocation } ];
    //});
    
    CLLocationAccuracy filterDistance = 1000.0;
    
    // If they panned the map since our last location update, don't recenter it.
    if (!self.mapPannedSinceLocationUpdate) {
        // Set the map's region centered on their new location at 2x filterDistance
        MKCoordinateRegion newRegion = MKCoordinateRegionMakeWithDistance(self.currentLocation.coordinate, filterDistance * 2.0f, filterDistance * 2.0f);
        
        BOOL oldMapPannedValue = self.mapPannedSinceLocationUpdate;
        [self.mapView setRegion:newRegion animated:YES];
        self.mapPannedSinceLocationUpdate = oldMapPannedValue;
    } // else do nothing.
    
    if (self.circleOverlay != nil) {
        [self.mapView removeOverlay:self.circleOverlay];
        self.circleOverlay = nil;
    }
    self.circleOverlay = [MKCircle circleWithCenterCoordinate:self.currentLocation.coordinate radius:filterDistance];
    [self.mapView addOverlay:self.circleOverlay];
 
    // Update the map with new pins:
    [self queryForAllPostsNearLocation:self.currentLocation withNearbyDistance:filterDistance];
    // And update the existing pins to reflect any changes in filter distance:
    [self updatePostsForLocation:self.currentLocation withNearbyDistance:filterDistance];
 
//}


#pragma mark -
#pragma mark CLLocationManagerDelegate methods and helpers


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    NSLog(@"Error: %@", [error description]);
    
    if (error.code == kCLErrorDenied) {
        [self.locationManager stopUpdatingLocation];
    } else if (error.code == kCLErrorLocationUnknown) {
        // todo: retry?
        // set a timer for five seconds to cycle location, and if it fails again, bail and tell the user.
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error retrieving location"
                                                        message:[error localizedDescription]
                                                       delegate:nil
                                              cancelButtonTitle:nil
                                              otherButtonTitles:@"OK", nil];
        [alert show];
    }
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
