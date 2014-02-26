//
//  NSDate+VRDurations.m
//  VRFoundationToolkit
//
//  Created by Ivan Rublev on 11/29/12.
//  Copyright (c) 2012 Ivan Rublev http://ivanrublev.me. All rights reserved.
//

#import "NSDate+VRDurations.h"

@implementation NSDate (VRDurations)

- (NSInteger)daysUntilDate:(NSDate *)nextDate
{
    return [[self componentsWithUnits:NSDayCalendarUnit untilDate:nextDate] day];
}

- (NSInteger)hoursUntilDate:(NSDate *)nextDate
{
    return [[self componentsWithUnits:NSHourCalendarUnit untilDate:nextDate] hour];
}

- (NSInteger)minutesUntilDate:(NSDate *)nextDate
{
    return [[self componentsWithUnits:NSMinuteCalendarUnit untilDate:nextDate] minute];
}

- (NSDateComponents *)componentsWithUnits:(NSCalendarUnit)units untilDate:(NSDate *)nextDate
{
    NSDate * date1 = self;
    NSDate * date2 = nextDate;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:units
                       fromDate:date1
                         toDate:date2 options:0];
}

@end
