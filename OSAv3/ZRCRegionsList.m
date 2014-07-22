//
//  ZRCRegionsList.m
//  OSAv3
//
//  Created by Zachary Christiansen on 7/18/14.
//  Copyright (c) 2014 Zachary Christiansen Design. All rights reserved.
//

#import "ZRCRegionsList.h"
#import "Object.h"
#import <RestKit/RestKit.h>
#import "ZRCState.h"
#import "ZRCObjectMethod.h"
#import "ZRCRegionProperties.h"
#import "ZRCMethodViewController.h"

@interface ZRCRegionsList ()

@end

@implementation ZRCRegionsList
NSArray *objects;
NSString *pathPattern;
NSArray *objects2;

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
      
    [self addObjectRestKit];
    [self loadObjects];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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

    // Return the number of rows in the section.
    return objects.count
    ;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    Object *object = objects[indexPath.row];
    
    cell.textLabel.text = object.Name;
    return cell;

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
}
*/

- (void)addObjectRestKit
{
    //need to add method to check to see if iphone object type exists and if not add it
    
    
    pathPattern = @"/api/objects/type/iphone";
    
    
    //setup state mapping
    //RKObjectMapping *regionpropertyMapping = [RKObjectMapping mappingForClass:[ZRCRegionProperties class]];
    

    
    //[regionpropertyMapping addAttributeMappingsFromDictionary:RegionPropertyMappings];
    
    
    
    // setup object mappings
    RKObjectMapping *ObjectMapping = [RKObjectMapping mappingForClass:[Object class]];
    //[ObjectMapping addAttributeMappingsFromArray:@[@"Name", @"BaseType"]];
    
    
    NSDictionary *objectPorpertyMappings = [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"Name", @"Name",
                                            @"BaseType", @"BaseType",
                                            @"Methods", @"Methods.@distinctUnionOfObjects.MethodName",
                                            nil];
    
    [ObjectMapping addAttributeMappingsFromDictionary:objectPorpertyMappings];
    
    //[ObjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Properties" toKeyPath:@"Properties" withMapping:regionpropertyMapping]];
    
    //   [ObjectMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"Methods" toKeyPath:@"Methods" withMapping:MethodMapping]];
    
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
                                                  
                                                  [self addOSAProperties];
                                                  [self.tableView reloadData ];
                        
                                              }
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  NSLog(@"What do you mean by 'there is no coffee?': %@", error);
                                              }];
    }



-(void) addOSAProperties{

    NSMutableArray *tempRegions = [NSMutableArray array];
    //NSLog(@"?",objects2.count);
    for (int i = 0; i<objects2.count; i++) {
   __weak Object *currentRegion = [objects2 objectAtIndex:i];
        
    //NSLog(@"The object getting properties is");
 //       NSLog(currentRegion.Name);
        [currentRegion setOSAObjectProperties: ^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
            currentRegion.Properties = mappingResult.array;
        }];
        [tempRegions addObject: currentRegion];
    }
    objects = tempRegions;
}

    
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"segue4"]){
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ZRCMethodViewController *destViewController = segue.destinationViewController;
        destViewController.object = [objects objectAtIndex:indexPath.row];
    }
}
    



@end
