//
//  JHReminderEventSource.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <EventKit/EventKit.h>
#import "JHReminderEventSource.h"
#import "JHReminderEvent.h"
#import "JHDateHelper.h"

static NSString *reminderAppPath = @"/Applications/Reminders.app";

@implementation JHReminderEventSource

@synthesize query, scopeQuery;

- (NSImage *)icon {
    return [[NSWorkspace sharedWorkspace] iconForFile:reminderAppPath];
}

- (void)activate {
    if (self.lastQuery == nil)
        self.lastQuery = [JHDateHelper oneDayAgo];
    
    [self updateReminders];
    [self registerSelector];
}

- (void)deactivate {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createOrUpdateIncompleteReminder:(EKReminder *)reminder {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[JHReminderEvent className]];
    NSPredicate *reminderIDPredicate = [NSPredicate predicateWithFormat:@"reminderID == %@", [reminder calendarItemIdentifier]];
    NSPredicate *reminderDuePredicate = [NSPredicate predicateWithFormat:@"eventVerb == %@", @"Due"];
    NSPredicate *reminderpred = [NSCompoundPredicate andPredicateWithSubpredicates:@[reminderIDPredicate, reminderDuePredicate]];
    [fetchRequest setPredicate:reminderpred];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error fetching existing incomplete reminder events! %@",error);
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    if ([fetchedObjects count] > 0) {
        //update events
        for (JHReminderEvent *remEvent in fetchedObjects) {
            [remEvent setBody:[reminder title]];
            [remEvent setTimestamp:[calendar dateFromComponents:[reminder dueDateComponents]]];
        }
        [[self managedObjectContext] save:&error];
        return;
    }
    
    JHReminderEvent *remEvent = [[JHReminderEvent alloc] initWithEntity:[NSEntityDescription entityForName:[JHReminderEvent className] inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
    [remEvent setBody:[reminder title]];
    [remEvent setReminderID:[reminder calendarItemIdentifier]];
    [remEvent setTimestamp:[calendar dateFromComponents:[reminder dueDateComponents]]];
    [remEvent setEventSource:self];
    [remEvent setEventVerb:@"Due"];
}

- (void)createOrUpdateCompleteReminder:(EKReminder *)reminder {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[JHReminderEvent className]];
    NSPredicate *reminderIDPredicate = [NSPredicate predicateWithFormat:@"reminderID == %@", [reminder calendarItemIdentifier]];
    NSPredicate *reminderDuePredicate = [NSPredicate predicateWithFormat:@"eventVerb == %@", @"Completed"];
    NSPredicate *reminderpred = [NSCompoundPredicate andPredicateWithSubpredicates:@[reminderIDPredicate, reminderDuePredicate]];
    [fetchRequest setPredicate:reminderpred];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Error fetching existing complete reminder events! %@",error);
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    if ([fetchedObjects count] > 0) {
        //update events
        for (JHReminderEvent *remEvent in fetchedObjects) {
            [remEvent setBody:[reminder title]];
            [remEvent setTimestamp:[reminder completionDate]];
        }
        [[self managedObjectContext] save:&error];
        return;
    }
    
    JHReminderEvent *remEvent = [[JHReminderEvent alloc] initWithEntity:[NSEntityDescription entityForName:[JHReminderEvent className] inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
    [remEvent setBody:[reminder title]];
    [remEvent setReminderID:[reminder calendarItemIdentifier]];
    [remEvent setTimestamp:[calendar dateFromComponents:[reminder dueDateComponents]]];
    [remEvent setEventSource:self];
    [remEvent setEventVerb:@"Completed"];
}

- (void)processEKStorechangedNote:(NSNotification *)note {
    [self updateReminders];
}

- (void)registerSelector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processEKStorechangedNote:) name:EKEventStoreChangedNotification object:nil];
}

- (void)updateReminders {
    EKEventStore *store = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskReminder];
    
    NSPredicate *complete = [store predicateForCompletedRemindersWithCompletionDateStarting:[self lastQuery] ending:[JHDateHelper oneDayFromNow] calendars:[store calendarsForEntityType:EKEntityTypeReminder]];
    NSPredicate *incomplete = [store predicateForIncompleteRemindersWithDueDateStarting:[self lastQuery] ending:[JHDateHelper oneDayFromNow] calendars:[store calendarsForEntityType:EKEntityTypeReminder]];
    
    [store fetchRemindersMatchingPredicate:complete completion:^(NSArray *reminders) {
        for (EKReminder *reminder in reminders) {
            [self createOrUpdateCompleteReminder:reminder];
        }
    }];
    
    [store fetchRemindersMatchingPredicate:incomplete completion:^(NSArray *reminders) {
        for (EKReminder *reminder in reminders) {
            [self createOrUpdateIncompleteReminder:reminder];
        }
    }];
}

@end
