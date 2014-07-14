//
//  ZRCSecondViewController.m
//  OSAv3
//
//  Created by Zachary Christiansen on 6/25/14.
//  Copyright (c) 2014 Zachary Christiansen Design. All rights reserved.
//

#import "ZRCSecondViewController.h"
#import <RestKit/RestKit.h>

@interface ZRCSecondViewController ()

- (IBAction)saveServer:(UIButton *)sender;
- (IBAction)updateHome:(UIButton *)sender;



//@property (strong, nonatomic)
@property (strong, nonatomic) IBOutlet UITextField *url;
@property (strong, nonatomic) IBOutlet UITextField *osaUserName;
@property (strong, nonatomic) IBOutlet UILabel *latitude;
@property (strong, nonatomic) IBOutlet UILabel *longitude;
@property (strong, nonatomic) IBOutlet UILabel *curent_latitude;
@property (strong, nonatomic) IBOutlet UILabel *curent_longitude;
@property (strong, nonatomic) NSNumber *radius;
@property (strong, nonatomic) IBOutlet UILabel *whereAreYou;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation ZRCSecondViewController{

CLLocationManager *locationManger;
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self intializeLocationManager];
    geocoder = [[CLGeocoder alloc] init];

    //display the current home defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.url.text = [defaults objectForKey:@"OSA_URL"];
    self.osaUserName.text = [defaults objectForKey:@"OSA_UserName"];
    self.latitude.text = [defaults objectForKey:@"OSA_Home_Latitude"];
    self.longitude.text = [defaults objectForKey:@"OSA_Home_Longitude"];
    
    
    if(self.latitude.text == nil){
        self.latitude.text = @"0.000000";
    }
    if (self.longitude.text == nil){
        self.longitude.text = @"0.000000";
    }
    
    
    
    
    NSArray *objects = [NSArray arrayWithObjects:@"region", self.latitude.text, self.longitude.text, nil];
    
    NSArray *keys = [NSArray arrayWithObjects:@"identifier", @"latitude", @"longitude", nil];
    
    NSDictionary *geofence = [NSDictionary dictionaryWithObjects: objects  forKeys: keys];
    
    [locationManger startMonitoringForRegion: [self dictToRegion:geofence]];
    
    CLLocation *homeLocation = [[CLLocation alloc] initWithLatitude:[self.latitude.text doubleValue] longitude:[self.longitude.text doubleValue]];
    
    [geocoder reverseGeocodeLocation:homeLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                  placemark.subThoroughfare, placemark.thoroughfare,
                                  placemark.postalCode, placemark.locality,
                                  placemark.administrativeArea,
                                  placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    
       }
-(void)awakeFromNib{
    [super awakeFromNib];
    
    
}

- (void) viewWillAppear:(BOOL) animated{
  
 
}

-(void)intializeLocationManager{
    //check to see if location services are enabled
    if(![CLLocationManager locationServicesEnabled]){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Location Services Disabled" message:@"You need locations services to fully use this app." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
                
    }
    if(![CLLocationManager isMonitoringAvailableForClass:[CLRegion class]])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No Region View" message:@"Region view is not available for this class." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    //display the users current location
    
    locationManger = [[CLLocationManager alloc] init];
    locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    locationManger.delegate = self;
  
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveServer:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    //NSLog(self.url.text);
    [defaults setObject:self.url.text forKey:@"OSA_URL"];
    [_url resignFirstResponder];
    [defaults setObject:self.osaUserName.text forKey:@"OSA_UserName"];
    [_osaUserName resignFirstResponder];
    [defaults synchronize];
    
}

- (IBAction)updateHome:(UIButton *)sender {
     [locationManger startUpdatingLocation];
    
  
    
    
    
    
}


#pragma mark -
#pragma mark CLLocationManagerDelegate

-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation
{
    NSString *currentLatitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.coordinate.latitude];
    _curent_latitude.text = currentLatitude;
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  newLocation.coordinate.longitude];
    _curent_longitude.text = currentLongitude;
  
    /*
    NSString *currentHorizontalAccuracy =
    [[NSString alloc]
     initWithFormat:@"%+.6f",
     newLocation.horizontalAccuracy];
    _horizontalAccuracy.text = currentHorizontalAccuracy;
    
    NSString *currentAltitude = [[NSString alloc]
                                 initWithFormat:@"%+.6f",
                                 newLocation.altitude];
    _altitude.text = currentAltitude;
    
    NSString *currentVerticalAccuracy =
    [[NSString alloc]
     initWithFormat:@"%+.6f",
     newLocation.verticalAccuracy];
    _verticalAccuracy.text = currentVerticalAccuracy;
    
    if (_startLocation == nil)
        _startLocation = newLocation;
    
    CLLocationDistance distanceBetween = [newLocation
                                          distanceFromLocation:_startLocation];
    
    NSString *tripString = [[NSString alloc]
                            initWithFormat:@"%f",
                            distanceBetween];
    _distance.text = tripString;
     
     */
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.curent_latitude.text forKey:@"OSA_Home_Latitude"];
    [defaults setObject:self.curent_longitude.text forKey:@"OSA_Home_Longitude"];
    [defaults synchronize];
    _latitude.text = self.curent_latitude.text;
    _longitude.text = self.curent_longitude.text;
    
    NSArray *objects = [NSArray arrayWithObjects:@"region", self.curent_latitude.text, self.curent_longitude.text, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"identifier", @"latitude", @"longitude", nil];
    
    NSDictionary *geofence = [NSDictionary dictionaryWithObjects: objects  forKeys: keys];
    
    [locationManger startMonitoringForRegion: [self dictToRegion:geofence]];
    [locationManger stopUpdatingLocation];

    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            _addressLabel.text = [NSString stringWithFormat:@"%@ %@\n%@ %@\n%@\n%@",
                                  placemark.subThoroughfare, placemark.thoroughfare,
                                  placemark.postalCode, placemark.locality,
                                  placemark.administrativeArea,
                                  placemark.country];
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
    

}


- (CLRegion*)dictToRegion:(NSDictionary*)dictionary
{
    NSString *identifier = [dictionary valueForKey:@"identifier"];
    CLLocationDegrees latitude = [[dictionary valueForKey:@"latitude"] doubleValue];
    CLLocationDegrees longitude =[[dictionary valueForKey:@"longitude"] doubleValue];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(latitude, longitude);
    CLLocationDistance regionRadius = 300;
    
    if(regionRadius > locationManger.maximumRegionMonitoringDistance)
    {
        regionRadius = locationManger.maximumRegionMonitoringDistance;
    }

    
    NSString *version = [[UIDevice currentDevice] systemVersion];
    CLRegion * region =nil;
    
    if([version floatValue] >= 7.0f) //for iOS7
    {
        region =  [[CLCircularRegion alloc] initWithCenter:centerCoordinate
                                                    radius:regionRadius
                                                identifier:identifier];
    }
    else // iOS 7 below
    {
        region = [[CLRegion alloc] initCircularRegionWithCenter:centerCoordinate
                                                         radius:regionRadius
                                                     identifier:identifier];
    }
    return  region;
}



- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region" message:@"Entered Region." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
     self.whereAreYou.text = @"In Region";
    [self setUserRegion:@"ON"];
    return;
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region" message:@"Left Region." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
    [alert show];
     self.whereAreYou.text = @"Outside Region";
    [self setUserRegion:@"OFF"];
    
    return;
}
- (void)locationManager:(CLLocationManager *)manager didStartMonitoringForRegion:(CLRegion *)region
{

}

- (void)locationManager:(CLLocationManager *)manager
      didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{

    return;
}

-(void)setUserRegion: (NSString *) location{
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *str = @"/api/object/";
    //NSLog(@"Value of string is %@", [self.detailItem valueForKey:@"container"]);
    NSString *str2 = [[defaults objectForKey:@"OSA_UserName"] stringByAppendingString: @"/"];
    str2 = [str2 stringByAppendingString: location];
    NSString *charactersToEscape = @"!*'();:@$,?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    str2 = [str2 stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    NSString *pathPattern = [str stringByAppendingString: str2];
    // NSLog(@"Value of string is %@", pathPattern);
    
    
    [[RKObjectManager sharedManager] postObject:nil path:pathPattern parameters:nil success:nil failure:nil];

}

@end
