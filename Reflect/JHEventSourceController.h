//
//  JHEventSourceController.h
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-10.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//event source imports
#import "JHSafariEventSource.h"
#import "JHReminderEventSource.h"
#import "JHCalendarEventSource.h"
#import "JHJournalEventSource.h"
#import "JHMailEventSource.h"

@interface JHEventSourceController : NSArrayController

//controlled event sources
@property (readonly) JHSafariEventSource *safariEventSource;
@property (readonly) JHCalendarEventSource *calendarEventSource;
@property (readonly) JHJournalEventSource *journalEventSource;
@property (readonly) JHMailEventSource *mailEventSource;
@property (readonly) JHReminderEventSource *reminderEventSource;

@property (weak) NSManagedObjectContext *context;

- (JHEventSourceController *)initWithContext:(NSManagedObjectContext *)cont;

@end
