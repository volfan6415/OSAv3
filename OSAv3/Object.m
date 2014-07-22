//
//  Object.m
//  OSAv3
//
//  Created by Zachary Christiansen on 6/25/14.
//  Copyright (c) 2014 Zachary Christiansen Design. All rights reserved.
//

#import "Object.h"
#import <RestKit/RestKit.h>
#import "ZRCRegionProperties.h"

@implementation Object
NSString *pathPattern;

@synthesize Container, Name, State, BaseType, Methods, Properties;


-(void) setpathPattern;{
    //setup the pathPattern
    NSString *str = @"/api/object/";
    //NSLog(@"Value of string is %@", [self.detailItem valueForKey:@"container"]);
    NSString *charactersToEscape = @"!*'();:@$,/?%#[]\" ";
    NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
    NSString *str2 = [Name stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
    
    pathPattern = [str stringByAppendingString: str2];
    
}

- (void) setOSAObjectProperties: (void (^)(RKObjectRequestOperation *operation, RKMappingResult *mappingResult))success{
    
    [self setpathPattern];
    
    NSDictionary *RegionPropertyMappings = [NSDictionary dictionaryWithObjectsAndKeys:
                                            @"Name", @"Name",
                                            @"Value", @"Value",
                                            nil];
    
    RKObjectMapping *propertyMappings = [RKObjectMapping mappingForClass: [ZRCRegionProperties class]];
    
    [propertyMappings addAttributeMappingsFromDictionary:RegionPropertyMappings];
    
    RKResponseDescriptor *responseDescriptor2 =
    [RKResponseDescriptor responseDescriptorWithMapping:propertyMappings
                                                 method:RKRequestMethodGET
                                            pathPattern:pathPattern
                                                keyPath: @"Properties"
                                            statusCodes:[NSIndexSet indexSetWithIndex:200]];
    
    
    [[RKObjectManager sharedManager] addResponseDescriptor:responseDescriptor2];
    
    NSDictionary *queryParams = @{};
    
    
    [[RKObjectManager sharedManager] getObjectsAtPath:pathPattern
                                           parameters:queryParams
                                              success: success
     
                                              failure:^(RKObjectRequestOperation *operation, NSError *error) {
                                                  
                                                  NSLog(@"Unable to set properties?': %@", error);
                                              }];
    
    
}






@end
