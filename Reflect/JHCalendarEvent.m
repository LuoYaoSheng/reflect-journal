//
//  JHCalendarEvent.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "JHCalendarEvent.h"

static NSString *calendarAppPath = @"/Applications/Calendar.app";

@implementation JHCalendarEvent

@dynamic calendarEventID;

- (NSImage *)icon {
    return [[NSWorkspace sharedWorkspace] iconForFile:calendarAppPath];
}

- (void)open {
    EKEventStore *eventStore = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskEvent];
    EKCalendarItem *currentEvent = [eventStore calendarItemWithIdentifier:[self calendarEventID]];
    [[NSWorkspace sharedWorkspace] openURL:[currentEvent URL]];
}

@end
