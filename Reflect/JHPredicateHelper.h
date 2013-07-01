//
//  JHPredicateHelper.h
//  Reflect
//
//  Created by Jeremiah Hall on 6/28/13.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JHPredicateHelper : NSObject

+ (NSPredicate *)getAddedSincePredicate:(NSDate *)since;
+ (NSPredicate *)getCreatedSincePredicate:(NSDate *)since;
+ (NSPredicate *)getUpdatedSincePredicate:(NSDate *)since;

+ (NSPredicate *)getContentCreatedSincePredicate:(NSDate *)since;

+ (NSPredicate *)getAddedPredicateAfter:(NSDate *)after andBefore:(NSDate *)before;
+ (NSPredicate *)getCreatedPredicateAfter:(NSDate *)after andBefore:(NSDate *)before;
+ (NSPredicate *)getUpdatedPredicateAfter:(NSDate *)after andBefore:(NSDate *)before;

+ (NSPredicate *)getContentTypePredicate:(NSString *)type;

+ (NSPredicate *)getCalUIDPredicate:(NSString *)uid;

+ (NSPredicate *)getDisplayNamePredicate:(NSString *)name;
+ (NSPredicate *)getKindPredicate:(NSString *)kind;

+ (NSPredicate *)getTimestampWithinAnHourOfPredicate:(NSDate *)ts;
@end
