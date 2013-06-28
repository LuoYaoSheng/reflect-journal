//
//  JHDateHelper.h
//  Reflect
//
//  Created by Jeremiah Hall on 6/28/13.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHDateHelper : NSObject

+ (NSDate *)oneHourAgo;

+ (NSDate *)oneDayAgo;

+ (NSDate *)oneHourFromNow;

+ (NSDate *)oneDayFromNow;

+ (NSDate *)oneHourAheadOf:(NSDate *)d;

+ (NSDate *)oneHourBefore:(NSDate *)d;

+ (NSDate *)oneDayAheadOf:(NSDate *)d;

+ (NSDate *)oneDayBefore:(NSDate *)d;

@end
