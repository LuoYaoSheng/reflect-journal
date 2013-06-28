//
//  JHMailEventSource.m
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHMailEventSource.h"
#import "JHMailEvent.h"
#import "JHPredicateHelper.h"
#import "JHDateHelper.h"

static NSString *mailMessageContentType = @"com.apple.mail.emlx";
static NSString *mailAppPath = @"/Applications/Mail.app";

@implementation JHMailEventSource

@synthesize query, scopeQuery;

- (NSImage *)icon {
    return [[NSWorkspace sharedWorkspace] iconForFile:mailAppPath];
}

- (void)activate {
    if (self.lastQuery == nil)
        self.lastQuery = [JHDateHelper oneHourAgo];
    
    self.query = [self getMDQuery];
    [self.query setDelegate:self];
    [self setSearchScopes];
}

- (void)setSearchScopes {
	NSPredicate *inboxPredicate = [JHPredicateHelper getDisplayNamePredicate:@"INBOX.mbox"];
    NSPredicate *kindPredicate = [JHPredicateHelper getKindPredicate:@"Mail Mailbox"];
    NSPredicate *scopePredicate = [NSCompoundPredicate andPredicateWithSubpredicates:@[inboxPredicate, kindPredicate]];
    
    self.scopeQuery = [[NSMetadataQuery alloc] init];
    [self.scopeQuery setPredicate:scopePredicate];
    
    // query for mailboxes, return array of inbox paths and start mail query in scope callback
    [self.scopeQuery startQuery];
    [self registerScopeCallbackWithQuery:self.scopeQuery];
    
    
}

- (void)scopeCallback:(NSNotification *)note {
    if ([[note name] isEqualToString:NSMetadataQueryDidFinishGatheringNotification]) {
        
        NSMutableArray *scopes = [NSMutableArray array];
        for (NSMetadataItem *item in [[self scopeQuery] results]) {
            [scopes addObject:[item valueForAttribute:NSMetadataItemPathKey]];
        }
        
        [self.scopeQuery stopQuery];
        [self.query setSearchScopes:scopes];
        [self.query startQuery];
        [self registerSelector];
    }
}

- (void)registerScopeCallbackWithQuery:(NSMetadataQuery *)q {
    NSNotificationCenter *nf = [NSNotificationCenter defaultCenter];
    [nf addObserver:self selector:@selector(scopeCallback:) name:nil object:q];
}

- (void)deactivate {
    [[NSNotificationCenter defaultCenter] removeObserver:self];   
}

- (void)processQueryResults:(NSNotification *)note {
    for (NSMetadataItem *item in [[self query] results]) {
        JHMailEvent *newEvent = [[JHMailEvent alloc] initWithEntity:[NSEntityDescription entityForName:[JHMailEvent className] inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
        [newEvent setMailMessagePath:[item valueForAttribute:NSMetadataItemPathKey]];
        [newEvent setEventVerb:@"Received"];
        [newEvent setBody:[item valueForAttribute:NSMetadataItemDisplayNameKey]];
        [newEvent setEventSource:self];
        [newEvent setTimestamp:[item valueForAttribute:NSMetadataItemFSCreationDateKey]];
    }
    NSError *error;
    [[self managedObjectContext] save:&error];
}

- (void)processQueryUpdateNotification:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    if ([userInfo objectForKey:@"kMDQueryUpdateAddedItems"] != nil) {
        NSArray *items = [userInfo objectForKey:@"kMDQueryUpdateAddedItems"];
        for (NSMetadataItem *item in items) {
            JHMailEvent *newEvent = [[JHMailEvent alloc] initWithEntity:[NSEntityDescription entityForName:[JHMailEvent className] inManagedObjectContext:[self managedObjectContext]] insertIntoManagedObjectContext:[self managedObjectContext]];
            [newEvent setMailMessagePath:[item valueForAttribute:NSMetadataItemPathKey]];
            [newEvent setEventVerb:@"Received"];
            [newEvent setBody:[item valueForAttribute:NSMetadataItemDisplayNameKey]];
            [newEvent setEventSource:self];
            [newEvent setTimestamp:[item valueForAttribute:NSMetadataItemFSCreationDateKey]];
        }
    }
}

- (void)queryNote:(NSNotification *)note {
    if ([[note name] isEqualToString:NSMetadataQueryDidFinishGatheringNotification]) {
        NSLog(@"Mail Finished gathering");
        [self processQueryResults:note];
        [self setLastQuery:[NSDate date]];
    }
    
    if ([[note name] isEqualToString:NSMetadataQueryDidUpdateNotification]) {
        [self setLastQuery:[NSDate date]];
        [self processQueryUpdateNotification:note];
    }
}

- (void)registerSelector {
    NSNotificationCenter *nf = [NSNotificationCenter defaultCenter];
    [nf addObserver:self selector:@selector(queryNote:) name:nil object:self.query];
}


- (NSMetadataQuery *)getMDQuery {
    NSMetadataQuery *q = [[NSMetadataQuery alloc] init];
    [q setPredicate:[self getQueryPredicate]];
    [q setNotificationBatchingInterval:5];
    return q;
}

- (NSPredicate *)getQueryPredicate {
	NSPredicate *contentTypePredicate = [JHPredicateHelper getContentTypePredicate:mailMessageContentType];
	NSPredicate *createdDatePredicate = [JHPredicateHelper getCreatedSincePredicate:[self lastQuery]];
    
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[contentTypePredicate, createdDatePredicate]];
}

@end
