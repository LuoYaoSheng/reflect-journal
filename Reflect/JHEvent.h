//
//  JHEvent.h
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JHCommentEvent, JHEventSource;

@interface JHEvent : NSManagedObject

@property (nonatomic, retain) NSString * body;
@property (nonatomic, retain) NSString * eventVerb;
@property (nonatomic, retain) NSDate * timestamp;
@property (nonatomic, retain) JHEventSource *eventSource;

@property (readonly) NSImage *icon;
@property (readonly) NSString *dateString;

- (NSString *)writtenAtDateString;
- (NSString *)writtenAtTimeString;

- (void)open;

@end
