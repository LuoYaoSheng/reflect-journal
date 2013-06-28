//
//  JHJournalEvent.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHJournalEvent.h"
#import "JHPredicateHelper.h"

@implementation JHJournalEvent

- (NSImage *)icon {
    NSString* imageName = [[NSBundle mainBundle] pathForResource:@"JournalIcon" ofType:@"png"];
    return [[NSImage alloc] initWithContentsOfFile:imageName];
}

// TODO: Refactor this to reduce code duplication and model complexity

- (NSArray *)relatedEvents {
    NSMutableArray *related = [NSMutableArray array];
    
    NSFetchRequest *relev = [NSFetchRequest fetchRequestWithEntityName:@"JHCalendarEvent"];
    [relev setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
    [relev setPredicate:[JHPredicateHelper getTimestampWithinAnHourOfPredicate:[self timestamp]]];
    NSError *error = nil;
    NSArray *fetchedObjects = [[self managedObjectContext] executeFetchRequest:relev error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Problem! %@",error);
    }
    [related addObjectsFromArray:fetchedObjects];
    
    relev = [NSFetchRequest fetchRequestWithEntityName:@"JHMailEvent"];
    [relev setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
    [relev setPredicate:[JHPredicateHelper getTimestampWithinAnHourOfPredicate:[self timestamp]]];
    error = nil;
    fetchedObjects = [[self managedObjectContext] executeFetchRequest:relev error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Problem! %@",error);
    }
    [related addObjectsFromArray:fetchedObjects];
    
    relev = [NSFetchRequest fetchRequestWithEntityName:@"JHSafariEvent"];
    [relev setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
    [relev setPredicate:[JHPredicateHelper getTimestampWithinAnHourOfPredicate:[self timestamp]]];
    error = nil;
    fetchedObjects = [[self managedObjectContext] executeFetchRequest:relev error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Problem! %@",error);
    }
    [related addObjectsFromArray:fetchedObjects];
    
    relev = [NSFetchRequest fetchRequestWithEntityName:@"JHReminderEvent"];
    [relev setSortDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:NO]]];
    [relev setPredicate:[JHPredicateHelper getTimestampWithinAnHourOfPredicate:[self timestamp]]];
    error = nil;
    fetchedObjects = [[self managedObjectContext] executeFetchRequest:relev error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Problem! %@",error);
    }
    [related addObjectsFromArray:fetchedObjects];
    
    [related addObject:self];
    return related;
}

@end
