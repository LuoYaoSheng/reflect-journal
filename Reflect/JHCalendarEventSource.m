//
//  JHCalendarEventSource.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHCalendarEventSource.h"
#import "JHCalendarEvent.h"
#import "JHPredicateHelper.h"
#import <EventKit/EventKit.h>

@implementation JHCalendarEventSource

@synthesize query, scopeQuery, eventStore;

- (void)activate {
    self.eventStore = [[EKEventStore alloc] initWithAccessToEntityTypes:EKEntityMaskEvent];
    [self createOrUpdateEventsForCalendarEventsStartingFromNow];
    
    [self registerSelector];
}

- (void)processEKStorechangedNote:(NSNotification *)note {
    [self createOrUpdateEventsForCalendarEventsStartingFromNow];
}

- (void)registerSelector {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(processEKStorechangedNote:) name:EKEventStoreChangedNotification object:[self eventStore]];
}

- (void)deactivate {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createOrUpdateEventsForCalendarEventsStartingFromNow {
    NSArray *calEvents = [self getAllCalendarEventsUpToAMonthFromNow];
    for (EKEvent *calEvent in calEvents) {
        [self createOrUpdateEventsWithEvent:calEvent];
    }
}

- (void)createOrUpdateEventsWithEvent:(EKEvent *)event {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:[JHCalendarEvent className]];
    NSPredicate *eventIDPredicate = [NSPredicate predicateWithFormat:@"calendarEventID == %@", [event eventIdentifier]];
    [fetchRequest setPredicate:eventIDPredicate];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Problem! %@",error);
    }
        
    if ([fetchedObjects count] > 0) {
        for (JHCalendarEvent *reflectCalEvent in fetchedObjects) {
            if ([[reflectCalEvent eventVerb] isEqualToString:@"Starts"]) {
                [reflectCalEvent setTimestamp:[event startDate]];
                continue;
            }
            
            if ([[reflectCalEvent eventVerb] isEqualToString:@"Ends"]) {
                [reflectCalEvent setTimestamp:[event endDate]];
                continue;
            }
        }
        [[self managedObjectContext] save:&error];
        return;
    }
        
        
    //create events
    //create starts
    JHCalendarEvent *startEvent = [[JHCalendarEvent alloc] initWithEntity:[NSEntityDescription entityForName:[JHCalendarEvent className] inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
    [startEvent setCalendarEventID:[event eventIdentifier]];
    [startEvent setEventVerb:@"Starts"];
    [startEvent setBody:[event title]];
    [startEvent setEventSource:self];
    [startEvent setTimestamp:[event startDate]];
        
    //create ends
        
    JHCalendarEvent *endEvent = [[JHCalendarEvent alloc] initWithEntity:[NSEntityDescription entityForName:[JHCalendarEvent className] inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
    [endEvent setCalendarEventID:[event eventIdentifier]];
    [endEvent setEventVerb:@"Ends"];
    [endEvent setBody:[event title]];
    [endEvent setEventSource:self];
    [endEvent setTimestamp:[event endDate]];
        
    [[self managedObjectContext] save:&error];
    return;
}

- (NSArray *)getAllCalendarEventsUpToAMonthFromNow {
    
    
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *oneMonthAgoComponents = [[NSDateComponents alloc] init];
    oneMonthAgoComponents.month = -1;
    NSDate *oneMonthAgo = [calendar dateByAddingComponents:oneMonthAgoComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    NSDateComponents *oneMonthFromNowComponents = [[NSDateComponents alloc] init];
    oneMonthFromNowComponents.month = 1;
    NSDate *oneMonthFromNow = [calendar dateByAddingComponents:oneMonthFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    NSPredicate *predicate = [[self eventStore] predicateForEventsWithStartDate:oneMonthAgo
                                                            endDate:oneMonthFromNow
                                                          calendars:nil];
    
    return [[self eventStore] eventsMatchingPredicate:predicate];
    
}

@end
