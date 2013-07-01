//
//  JHCalendarEvent.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "JHCalendarEvent.h"
#import "JHCalendarEventSource.h"

static NSString *calendarAppPath = @"/Applications/Calendar.app";

@implementation JHCalendarEvent

@dynamic calendarEventID;

- (NSImage *)icon {
    return [[NSWorkspace sharedWorkspace] iconForFile:calendarAppPath];
}

- (void)open {
    [self.eventSource openEvent:self];
}

@end
