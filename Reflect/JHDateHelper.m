//
//  JHDateHelper.m
//  Reflect
//
//  Created by Jeremiah Hall on 6/28/13.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHDateHelper.h"

@implementation JHDateHelper

+ (NSDate *)oneHourAgo {
    return [JHDateHelper oneHourBefore:[NSDate date]];
}

+ (NSDate *)oneDayAgo {
    return [JHDateHelper oneDayBefore:[NSDate date]];
}

+ (NSDate *)oneHourFromNow {
    return [JHDateHelper oneHourAheadOf:[NSDate date]];
}

+ (NSDate *)oneDayFromNow {
    return [JHDateHelper oneDayAheadOf:[NSDate date]];
}

+ (NSDate *)oneHourAheadOf:(NSDate *)d {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oneHourAfterComp = [[NSDateComponents alloc] init];
    oneHourAfterComp.hour = 1;
    return [calendar dateByAddingComponents:oneHourAfterComp
                                                     toDate:d
                                                    options:0];
}

+ (NSDate *)oneHourBefore:(NSDate *)d {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oneHourBeforeComp = [[NSDateComponents alloc] init];
    oneHourBeforeComp.hour = -1;
    return [calendar dateByAddingComponents:oneHourBeforeComp
                                                      toDate:d
                                                     options:0];
}

+ (NSDate *)oneDayAheadOf:(NSDate *)d {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oneHourAfterComp = [[NSDateComponents alloc] init];
    oneHourAfterComp.day = 1;
    return [calendar dateByAddingComponents:oneHourAfterComp
                                     toDate:d
                                    options:0];
}

+ (NSDate *)oneDayBefore:(NSDate *)d {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *oneHourBeforeComp = [[NSDateComponents alloc] init];
    oneHourBeforeComp.day = -1;
    return [calendar dateByAddingComponents:oneHourBeforeComp
                                     toDate:d
                                    options:0];
}

@end
