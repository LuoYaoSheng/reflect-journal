//
//  JHSafariEventSource.h
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-13.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JHEventSource.h"


@interface JHSafariEventSource : JHEventSource

@property (strong) NSMetadataQuery *query;

@end
