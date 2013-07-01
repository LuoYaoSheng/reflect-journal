//
//  JHAppDelegate.h
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JHEventSourceController.h"

@interface JHAppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@property (readonly) NSArray *eventSortDescriptors;

@property (readonly) JHEventSourceController *eventSourceController;

- (IBAction)saveAction:(id)sender;

@property (weak) IBOutlet NSArrayController *journalArrayController;

- (void)relatedDoubleClicked;
@property (weak) IBOutlet NSTableView *relatedTableView;
@property (weak) IBOutlet NSArrayController *relatedArrayController;

@end
