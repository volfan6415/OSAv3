//
//  ZRCObjectViewController.m
//  OSAv3
//
//  Created by Zachary Christiansen on 6/25/14.
//  Copyright (c) 2014 Zachary Christiansen Design. All rights reserved.
//

#import "ZRCObjectViewController.h"
//#import "ZRCPlacesTableViewController.h"
#import "Place.h"
#import "Object.h"
#import <RestKit/RestKit.h>
#import "ZRCMethodViewController.h"
#import "ZRCState.h"

@interface ZRCObjectViewController ()



@end

@implementation ZRCObjectViewController
NSArray *objects;
NSString *pathPattern;
NSArray *objects2;


@synthesize place;

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
    self.title = place.Container;
    [self addObjectRestKit];
    [self loadObjects];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)addObjectRestKit
{
   
    NSString *str = @"/api/objects/container/";
    //NSLog(@"Value of string is %@", [self.detailItem valueForKey:@"container"]);
    NSString *str2 = place.Container;
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
    
    //setup state mapping
    RKObjectMapping *stateMapping = [RKObjectMapping mappingForClass:[ZRCState class]];
    [stateMapping addAttributeMappingsFromArray:@[@"Value"]];
    
    // setup object mappings
    RKObjectMapping *ObjectMapping = [RKObjectMapping mappingForClass:[Object class]];
    [ObjectMapping addAttributeMappingsFromArray:@[@"Name", @"BaseType"]];
    [ObjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"State" toKeyPath:@"State" withMapping:stateMapping]];
    
    // register mappings with the provider using a response descriptor
    RKResponseDescriptor *responseDescriptor2 =
  [RKResponseDescriptor responseDescriptorWithMapping:ObjectMapping
                                                 method:RKRequestMethodGET
                                            pathPattern:pathPattern
                                                keyPath:nil
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor2];
     
  
}

- (void)loadObjects
{
    
    
    NSDictionary *queryParams = @{};
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathPattern
                                           parameters:queryParams
                                              success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
                                                  objects2 = mappingResult.array;
                                                  
                                                  [self removeContainer];
                                                  
                                                  
                                                  
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
   
    
    return objects.count;
}



- (void) removeContainer {

    NSMutableArray *myarray = [NSMutableArray array];
    
    for (int i = 0; i < objects2.count; i++) {
        Object *compare = [objects2 objectAtIndex:i];
        if ([compare.Name isEqualToString:place.Container]){
            
        }
        else{
            [myarray addObject: compare];
         //   NSLog(compare.Name);
        }
    }
    
    objects = myarray;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Object *object = objects[indexPath.row];
    
    //if ([object.Name isEqualToString:place.Container]){
        //cell.textLabel.text = nil;
      //  return nil;
   // }
    //else{
    UISwitch *accessorySwitch = [[UISwitch alloc]initWithFrame:CGRectZero];
    
    
    if ([self getState:object]){
    [accessorySwitch setOn:YES animated:YES];
   }
    else{
    [accessorySwitch setOn:NO animated:YES];
    }
    
    
    
    [accessorySwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    accessorySwitch.tag = indexPath.row;
    cell.accessoryView = accessorySwitch;
      cell.textLabel.text = object.Name;
    
        return cell;
    //}
}

- (void)switchToggled:(UISwitch *)sender{
    
    //printf(sender.tag);
    
    UISwitch *trigger = sender;
    
    Object *switchedobject = [objects objectAtIndex:trigger.tag];
    
    if (trigger.on){
    
        NSLog(@"switch was turned on");
    
        [self pushObjectSwitch:switchedobject switchPosition:@"ON"];
        
    }
    
    else{
    NSLog(@"switch was turned off");
        [self pushObjectSwitch:switchedobject switchPosition:@"OFF"];
    }
    
    

    
    //NSLog(trigger.On);
    return;
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


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
   if ([segue.identifier isEqualToString:@"segue2"]){
       NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ZRCMethodViewController *destViewController = segue.destinationViewController;
        destViewController.object = [objects objectAtIndex:indexPath.row];
}
}

- (void) pushObjectSwitch: (Object *) switchedObject switchPosition: (NSString *) switchPoition{


    NSString *methodName = switchPoition;
    
    NSString *str = @"/api/object/";
    //NSLog(@"Value of string is %@", [self.detailItem valueForKey:@"container"]);
    NSString *str2 = [switchedObject.Name stringByAppendingString: @"/"];
    str2 = [str2 stringByAppendingString: methodName];
    NSString *charactersToEscape = @"!*'();:@$,?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    str2 = [str2 stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    pathPattern = [str stringByAppendingString: str2];
   // NSLog(@"Value of string is %@", pathPattern);
    
    
    [[RKObjectManager sharedManager] postObject:nil path:pathPattern parameters:nil success:nil failure:nil];

}

-(BOOL) getState: (Object*) switchedObject {
    ZRCState *state = switchedObject.State;

    //NSLog(state.Value);
    

    return ([state.Value isEqualToString:@"ON"]);
}


@end
