//
//  JHReminderEventSource.h
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JHEventSource.h"
#import "JHReminderEvent.h"

@interface JHReminderEventSource : JHEventSource  <NSMetadataQueryDelegate>

@property (strong) NSMetadataQuery *query;
@property (strong) NSMetadataQuery *scopeQuery;
@property (readonly) NSImage *icon;

- (void)activate;
- (void)deactivate;

@end
