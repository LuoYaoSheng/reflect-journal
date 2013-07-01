//
//  JHSafariEvent.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-13.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHSafariEvent.h"
#import "JHSafariEventSource.h"

@implementation JHSafariEvent

@dynamic path;

- (NSImage *)icon {
    return [[NSWorkspace sharedWorkspace] iconForFile:[self path]];
}

- (void)open {
    [JHSafariEventSource openEvent:self];
}

@end
