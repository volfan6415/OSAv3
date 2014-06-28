//
//  ZRCObjectViewController.h
//  OSAv3
//
//  Created by Zachary Christiansen on 6/25/14.
//  Copyright (c) 2014 Zachary Christiansen Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Place.h"

@interface ZRCObjectViewController : UITableViewController


@property (weak, nonatomic) IBOutlet UILabel *objectDescriptionLabel;
@property (nonatomic, strong) Place *place;

@end
