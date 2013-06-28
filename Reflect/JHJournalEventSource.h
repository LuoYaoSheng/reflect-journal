//
//  JHJournalEventSource.h
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JHEventSource.h"


@interface JHJournalEventSource : JHEventSource

@property (readonly) NSImage *icon;

- (void)createJournalWithBody:(NSString *)body;

@end
