//
//  JHSafariEventSource.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-13.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHSafariEventSource.h"
#import "JHSafariEvent.h"
#import "JHPredicateHelper.h"
#import "JHDateHelper.h"

@implementation JHSafariEventSource

@synthesize query = _query;

- (void)activate {
    
    _query = [[NSMetadataQuery alloc] init];
    
    if ([self lastQuery] == nil)
        [self setLastQuery:[JHDateHelper oneHourAgo]];
    
    NSPredicate *createdAfter = [JHPredicateHelper getUpdatedSincePredicate:[self lastQuery]];
    
    NSPredicate *safariHistory = [JHPredicateHelper getContentTypePredicate:@"com.apple.safari.history"];
    NSPredicate *safariBookmark = [JHPredicateHelper getContentTypePredicate:@"com.apple.safari.bookmark"];
    
    NSPredicate *safari = [NSCompoundPredicate orPredicateWithSubpredicates:@[safariHistory, safariBookmark]];
    
    NSPredicate *pred = [NSCompoundPredicate andPredicateWithSubpredicates:@[createdAfter, safari]];
    
    [_query setPredicate:pred];
    [_query setSearchScopes:@[NSMetadataQueryUserHomeScope]];
    [_query setNotificationBatchingInterval:5];
    [_query startQuery];
    
    NSNotificationCenter *nf = [NSNotificationCenter defaultCenter];
    [nf addObserver:self selector:@selector(safariCallback:) name:nil object:self.query];
}

- (void)processQueryResults:(NSNotification *)note {
    for (NSMetadataItem *item in [[self query] results]) {
        JHSafariEvent *safariEvent = [[JHSafariEvent alloc] initWithEntity:[NSEntityDescription entityForName:[JHSafariEvent className] inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
        [safariEvent setPath:[item valueForAttribute:NSMetadataItemPathKey]];
        [safariEvent setBody:[item valueForAttribute:NSMetadataItemDisplayNameKey]];
        [safariEvent setTimestamp:[item valueForAttribute:NSMetadataItemFSContentChangeDateKey]];
        
        if ([[item valueForAttribute:@"kMDItemContentType"] isEqualToString:@"com.apple.safari.history"])
            [safariEvent setEventVerb:@"Visited"];
        
        if ([[item valueForAttribute:@"kMDItemContentType"] isEqualToString:@"com.apple.safari.bookmark"])
            [safariEvent setEventVerb:@"Bookmarked"];
    }
}

- (void)processQueryUpdate:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    if ([userInfo objectForKey:@"kMDQueryUpdateAddedItems"] != nil) {
        NSArray *items = [userInfo objectForKey:@"kMDQueryUpdateAddedItems"];
        for (NSMetadataItem *item in items) {
            JHSafariEvent *safariEvent = [[JHSafariEvent alloc] initWithEntity:[NSEntityDescription entityForName:[JHSafariEvent className] inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
            [safariEvent setPath:[item valueForAttribute:NSMetadataItemPathKey]];
            [safariEvent setBody:[item valueForAttribute:NSMetadataItemDisplayNameKey]];
            [safariEvent setTimestamp:[item valueForAttribute:NSMetadataItemFSContentChangeDateKey]];
            
            if ([[item valueForAttribute:@"kMDItemContentType"] isEqualToString:@"com.apple.safari.history"])
                [safariEvent setEventVerb:@"Visited"];
            
            if ([[item valueForAttribute:@"kMDItemContentType"] isEqualToString:@"com.apple.safari.bookmark"])
                [safariEvent setEventVerb:@"Bookmarked"];
        }
    }
}

- (void)safariCallback:(NSNotification *)note {
    if ([[note name] isEqualToString:NSMetadataQueryDidFinishGatheringNotification]) {
        [self setLastQuery:[NSDate date]];
        [self processQueryResults:note];
        
    }
    
    if ([[note name] isEqualToString:NSMetadataQueryDidUpdateNotification]) {
        [self setLastQuery:[NSDate date]];
        [self processQueryUpdate:note];
    }
}

@end
