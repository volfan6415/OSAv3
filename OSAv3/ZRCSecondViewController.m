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

    //display the current home defaults
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    self.url.text = [defaults objectForKey:@"OSA_URL"];
    self.osaUserName.text = [defaults objectForKey:@"OSA_UserName"];
    
       }
-(void)awakeFromNib{
    [super awakeFromNib];
    
    
}

- (void) viewWillAppear:(BOOL) animated{
  
 
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
