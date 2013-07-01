//
//  JHEventSource.h
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class JHEvent;

@interface JHEventSource : NSManagedObject

@property (nonatomic, retain) NSDate * lastQuery;
@property (nonatomic, retain) NSSet *events;

- (void)activate;
- (void)deactivate;

- (void)openEvent:(JHEvent *)ev;

@end

@interface JHEventSource (CoreDataGeneratedAccessors)

- (void)addEventsObject:(JHEvent *)value;
- (void)removeEventsObject:(JHEvent *)value;
- (void)addEvents:(NSSet *)values;
- (void)removeEvents:(NSSet *)values;

@end
