//
//  VRPPMyClass.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 2/26/14.
//  Copyright (c) 2014 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "VRPPMySuperClass.h"

@interface VRPPMyClass : VRPPMySuperClass <NSCoding>
@property (nonatomic, assign) NSUInteger value;
@property (nonatomic, readwrite) NSString * title;
@property (nonatomic, readwrite) NSString * constInvisible;
@end
