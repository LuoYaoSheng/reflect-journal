//
//  JHMailEvent.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHMailEvent.h"
#import "JHMailEventSource.h"

@implementation JHMailEvent

@dynamic mailMessagePath;

- (NSImage *)icon {
    return [[NSWorkspace sharedWorkspace] iconForFile:[self mailMessagePath]];
}

- (void)open {
    [self.eventSource openEvent:self];
}
@end
