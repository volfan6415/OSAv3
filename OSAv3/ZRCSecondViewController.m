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




//@property (strong, nonatomic)
@property (strong, nonatomic) IBOutlet UITextField *url;
@property (strong, nonatomic) IBOutlet UITextField *osaUserName;

@end

@implementation ZRCSecondViewController{

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
