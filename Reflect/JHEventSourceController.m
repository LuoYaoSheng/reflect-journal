//
//  JHEventSourceController.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-10.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHEventSourceController.h"
#import "JHEventSource.h"

@implementation JHEventSourceController

@synthesize context;

//Accessors via Core Data Fetch
- (JHCalendarEventSource *)calendarEventSource {
    return (JHCalendarEventSource *)[self getEventSourceByClassName:[JHCalendarEventSource className]];
}

- (JHJournalEventSource *)journalEventSource {
    return (JHJournalEventSource *)[self getEventSourceByClassName:[JHJournalEventSource className]];
}

- (JHMailEventSource *)mailEventSource {
    return (JHMailEventSource *)[self getEventSourceByClassName:[JHMailEventSource className]];
}

- (JHReminderEventSource *)reminderEventSource {
    return (JHReminderEventSource *)[self getEventSourceByClassName:[JHReminderEventSource className]];
}

- (JHSafariEventSource *)safariEventSource {
    return (JHSafariEventSource *)[self getEventSourceByClassName:[JHSafariEventSource className]];
}

- (JHEventSourceController *)initWithContext:(NSManagedObjectContext *)cont {
    self = [self init];
    self.context = cont;
    [self createEventSources];
    [self activateEventSources];
    return self;
}

- (void)createEventSources {
    NSArray *sources = [self getExistingEventSources];
    if ([sources count] > 0) //if we've already done this
        return;
    
    [[JHCalendarEventSource alloc] initWithEntity:[NSEntityDescription entityForName:[JHCalendarEventSource className] inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    [[JHJournalEventSource alloc] initWithEntity:[NSEntityDescription entityForName:[JHJournalEventSource className] inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    [[JHMailEventSource alloc] initWithEntity:[NSEntityDescription entityForName:[JHMailEventSource className] inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    [[JHSafariEventSource alloc] initWithEntity:[NSEntityDescription entityForName:[JHSafariEventSource className] inManagedObjectContext:context] insertIntoManagedObjectContext:context];
    [[JHReminderEventSource alloc] initWithEntity:[NSEntityDescription entityForName:[JHReminderEventSource className] inManagedObjectContext:context] insertIntoManagedObjectContext:context];
}



- (void)activateEventSources {
    [[self calendarEventSource] activate];
    [[self journalEventSource] activate];
    [[self mailEventSource] activate];
    [[self reminderEventSource] activate];
    [[self safariEventSource] activate];
}


- (JHEventSource *)getEventSourceByClassName:(NSString *)name {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:name];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self context] executeFetchRequest:fetchRequest error:&error];
    if ([fetchedObjects count] == 0 || fetchedObjects == nil) {
        NSLog(@"No event source found with name: %@", name);
        return nil;
    }
    return [fetchedObjects objectAtIndex:0];
}

- (NSArray *)getExistingEventSources {
    // grab all existing event sources, if any
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[JHEventSource className]];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self context] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"No event sources found, if not first boot, this is a problem");
        return [NSArray array];
    }
    
    return fetchedObjects;
}



@end
