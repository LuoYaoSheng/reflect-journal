//
//  JHCalendarEventSource.h
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JHEventSource.h"
#import "JHCalendarEvent.h"
#import <EventKit/EventKit.h>

@interface JHCalendarEventSource : JHEventSource <NSMetadataQueryDelegate>

@property (strong) NSMetadataQuery *query;
@property (strong) NSMetadataQuery *scopeQuery;
@property (strong) EKEventStore *eventStore;

- (void)activate;
- (void)deactivate;

@end
