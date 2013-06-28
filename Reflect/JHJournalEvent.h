//
//  JHJournalEvent.h
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JHEvent.h"
#import "JHJournalEventSource.h"

@interface JHJournalEvent : JHEvent

@property (readonly) NSImage *icon;
@property (readonly) NSArray *relatedEvents;



@end
