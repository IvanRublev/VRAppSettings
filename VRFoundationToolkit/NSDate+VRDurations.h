//
//  NSDate+VRDurations.h
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 11/29/12.
//  Copyright (c) 2012 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (VRDurations)

-(NSInteger)daysUntilDate:(NSDate *)nextDate;
-(NSInteger)hoursUntilDate:(NSDate *)nextDate;
-(NSInteger)minutesUntilDate:(NSDate *)nextDate;
-(NSDateComponents *)componentsWithUnits:(NSCalendarUnit)units untilDate:(NSDate *)nextDate;

@end
