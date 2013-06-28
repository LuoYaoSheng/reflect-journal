//
//  JHReminderEvent.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHReminderEvent.h"

static NSString *reminderAppPath = @"/Applications/Reminders.app";

@implementation JHReminderEvent

@dynamic reminderID;

- (NSImage *)icon {
    return [[NSWorkspace sharedWorkspace] iconForFile:reminderAppPath];
}

@end
