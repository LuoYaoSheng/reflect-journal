//
//  JHJournalEventSource.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHJournalEventSource.h"
#import "JHJournalEvent.h"

@implementation JHJournalEventSource

- (NSImage *)icon {
    NSString* imageName = [[NSBundle mainBundle] pathForResource:@"JournalIcon" ofType:@"png"];
    return [[NSImage alloc] initWithContentsOfFile:imageName];
}

- (void)createJournalWithBody:(NSString *)body {
    JHJournalEvent *newEvent = [[JHJournalEvent alloc] initWithEntity:[NSEntityDescription entityForName:[JHJournalEvent className] inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
    [newEvent setEventVerb:@"Added"];
    [newEvent setBody:body];
    [newEvent setEventSource:self];
    [newEvent setTimestamp:[NSDate date]];
}

@end
