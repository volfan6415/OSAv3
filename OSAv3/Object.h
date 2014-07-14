//
//  Object.h
//  OSAv3
//
//  Created by Zachary Christiansen on 6/25/14.
//  Copyright (c) 2014 Zachary Christiansen Design. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZRCState.h"

@interface Object : NSObject
@property (nonatomic, strong) NSString *Container;
@property (nonatomic, strong) NSString *Name;
@property (nonatomic, strong) ZRCState *State;
@property (nonatomic, strong) ZRCState *BaseType;
@property (nonatomic, strong) NSArray *Methods;



@end
