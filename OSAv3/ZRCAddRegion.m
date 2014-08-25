//
//  ZRCAddRegion.m
//  OSAv3
//
//  Created by Zachary Christiansen on 7/28/14.
//  Copyright (c) 2014 Zachary Christiansen Design. All rights reserved.
//

#import "ZRCAddRegion.h"
#import "RegionsViewController.h"
#import "ZRCAppDelegate.h"

@interface ZRCAddRegion ()
- (IBAction)submitRegion:(id)sender;
- (IBAction)useCurrentLocation:(id)sender;

@end

@implementation ZRCAddRegion

@synthesize regionName, regionLatitude, regionLongitude, regionRaidus;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)submitRegion:(id)sender {



}

- (IBAction)useCurrentLocation:(id)sender {
    ZRCAppDelegate *myAppdelegate = (ZRCAppDelegate *) [[UIApplication sharedApplication] delegate];
    RegionsViewController *regionView = myAppdelegate.viewController;
    
    CLLocation *currentLocation = regionView.currentLocation;
    self.regionLongitude.text =  [[NSNumber numberWithDouble:currentLocation.coordinate.longitude] stringValue];
    self.regionLatitude.text = [[NSNumber numberWithDouble:currentLocation.coordinate.latitude] stringValue];
}
@end
