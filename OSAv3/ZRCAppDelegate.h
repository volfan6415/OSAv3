//
//  ZRCAppDelegate.h
//  OSAv3
//
//  Created by Zachary Christiansen on 6/25/14.
//  Copyright (c) 2014 Zachary Christiansen Design. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegionsViewController.h"

@interface ZRCAppDelegate : UIResponder <UIApplicationDelegate>

//@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet RegionsViewController *viewController;

@end
