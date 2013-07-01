//
//  JHEventSource.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHEventSource.h"

@implementation JHEventSource

@dynamic lastQuery;
@dynamic events;

- (void)activate {
    //overriden by subclasses
}

- (void)deactivate {
    //overriden by subclasses    
}

- (void)openEvent:(JHEvent *)ev {
    
}

@end
