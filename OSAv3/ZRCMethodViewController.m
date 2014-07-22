//
//  ZRCMethodViewController.m
//  OSAv3
//
//  Created by Zachary Christiansen on 6/27/14.
//  Copyright (c) 2014 Zachary Christiansen Design. All rights reserved.
//

#import "ZRCMethodViewController.h"
#import "ZRCObjectMethod.h"
#import <RestKit/RestKit.h>
#import "Object.h"
#import "ZRCRegionsList.h"

@interface ZRCMethodViewController ()

@end

@implementation ZRCMethodViewController

NSArray *Objectsmethods;
NSString *pathPattern;


@synthesize object;


- (id)initWithStyle:(UITableViewStyle)style
{
    
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    self.title = object.Name;
    [self addMethodRestKit];
    [self loadMethods];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)addMethodRestKit
{
    
    NSString *str = @"/api/object/";
    //NSLog(@"Value of string is %@", [self.detailItem valueForKey:@"container"]);
    NSString *str2 = object.Name;
    NSString *charactersToEscape = @"!*'();:@$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    str2 = [str2 stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    pathPattern = [str stringByAppendingString: str2];
    NSLog(@"Value of string is %@", pathPattern);
    // initialize AFNetworking HTTPClient
    // NSURL *baseURL = [NSURL URLWithString:@"http://zchristiansen.homeserver.com:8732"];
    // AFHTTPClient *client = [[AFHTTPClient alloc] initWithBaseURL:baseURL];
    
    // initialize RestKit
    //  RKObjectManager *objectManager = [[RKObjectManager alloc] initWithHTTPClient:client];
    
    // setup object mappings
    RKObjectMapping *MethodMapping = [RKObjectMapping mappingForClass:[ZRCObjectMethod class]];
    [MethodMapping addAttributeMappingsFromArray:@[@"MethodName"]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor3 =
    [RKResponseDescriptor responseDescriptorWithMapping:MethodMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathPattern
                                                keyPath:@"Methods"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor3];
    
    
}

- (void)loadMethods
{
    
    
    NSDictionary *queryParams = @{};
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathPattern
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  Objectsmethods = mappingResult.array;
                                                  
                                                  
                                                  
                                                  [self.tableView reloadData];
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    
    return Objectsmethods.count;
}






- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    ZRCObjectMethod *place2 = Objectsmethods[indexPath.row];
    cell.textLabel.text = place2.MethodName;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ZRCObjectMethod *place2 = Objectsmethods[indexPath.row];
    NSString *methodName = place2.MethodName;
    
    NSString *str = @"/api/object/";
    //NSLog(@"Value of string is %@", [self.detailItem valueForKey:@"container"]);
    NSString *str2 = [object.Name stringByAppendingString: @"/"];
    str2 = [str2 stringByAppendingString: methodName];
    NSString *charactersToEscape = @"!*'();:@$,?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    str2 = [str2 stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    pathPattern = [str stringByAppendingString: str2];
    NSLog(@"Value of string is %@", pathPattern);
    

    [[RKObjectManager sharedManager] postObject:nil path:pathPattern parameters:nil success:nil failure:nil];

   
    

    
    [self.tableView reloadData];
    
}





/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Navigation

 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
     if ([segue.identifier isEqualToString:@"segue3"]){
         ZRCMethodViewController *destViewController = segue.destinationViewController;
         destViewController.object = object;
     }
 
 }*/




@end
