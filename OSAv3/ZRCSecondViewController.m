//
//  ZRCSecondViewController.m
//  OSAv3
//
//  Created by Zachary Christiansen on 6/25/14.
//  Copyright (c) 2014 Zachary Christiansen Design. All rights reserved.
//

#import "ZRCSecondViewController.h"

@interface ZRCSecondViewController ()

- (IBAction)saveServer:(UIButton *)sender;
- (IBAction)updateHome:(UIButton *)sender;



@property (strong, nonatomic) CLLocationManager *locationManger;
@property (strong, nonatomic) IBOutlet UITextField *url;

@property (strong, nonatomic) IBOutlet UILabel *latitude;
@property (strong, nonatomic) IBOutlet UILabel *longitude;
@property (strong, nonatomic) IBOutlet UILabel *curent_latitude;
@property (strong, nonatomic) IBOutlet UILabel *curent_longitude;

@end

@implementation ZRCSecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //display the current home defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.url = [defaults objectForKey:@"OSA_URL"];
    self.latitude.text = [defaults objectForKey:@"OSA_Home_Latitude"];
    self.longitude.text = [defaults objectForKey:@"OSA_Home_Longitude"];
   
    //display the users current location
    
    _locationManger = [[CLLocationManager alloc] init];
    _locationManger.desiredAccuracy = kCLLocationAccuracyBest;
    _locationManger.delegate = self;
    [_locationManger startUpdatingLocation];
    
  
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)saveServer:(UIButton *)sender {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"OSA_URL" forKey:self.url.text];
   
    [defaults synchronize];
    
}

- (IBAction)updateHome:(UIButton *)sender {
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"OSA_Home_Latitude" forKey:self.curent_latitude.text];
    [defaults setValue:@"OSA_Home_Longitude" forKey:self.curent_longitude.text];
    [defaults synchronize];
    
    
    
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
    _latitude.text = currentLatitude;
    
    NSString *currentLongitude = [[NSString alloc]
                                  initWithFormat:@"%+.6f",
                                  newLocation.coordinate.longitude];
    _longitude.text = currentLongitude;
  
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
}

@end
