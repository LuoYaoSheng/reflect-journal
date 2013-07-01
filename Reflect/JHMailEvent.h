//
//  JHMailEvent.h
//  Reflect
//
//  Created by Jeremiah Hall on 2013-06-05.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "JHEvent.h"


@interface JHMailEvent : JHEvent

@property (nonatomic, retain) NSString * mailMessagePath;
@property (readonly) NSImage *icon;

@end
