//
//  JHEvent.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHEvent.h"
#import "JHEventSource.h"


@implementation JHEvent

@dynamic body;
@dynamic eventVerb;
@dynamic timestamp;
@dynamic eventSource;

@synthesize icon = _icon;

- (NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:[self timestamp]];
}

- (NSString *)writtenAtDateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    return [dateFormatter stringFromDate:[self timestamp]];
}

- (NSString *)writtenAtTimeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    return [dateFormatter stringFromDate:[self timestamp]];
}

@end
