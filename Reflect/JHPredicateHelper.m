//
//  JHPredicateHelper.m
//  Reflect
//
//  Created by Jeremiah Hall on 6/28/13.
//  Copyright (c) 2013 Jeremiah Hall. All rights reserved.
//

#import "JHPredicateHelper.h"

static NSUInteger options = (NSCaseInsensitivePredicateOption|NSDiacriticInsensitivePredicateOption);

@implementation JHPredicateHelper

+ (NSPredicate *)getAddedSincePredicate:(NSDate *)since {
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemDateAdded"] rightExpression:[NSExpression expressionForConstantValue:since] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:options];
}

+ (NSPredicate *)getCreatedSincePredicate:(NSDate *)since {
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemFSCreationDate"] rightExpression:[NSExpression expressionForConstantValue:since] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:options];
}

+ (NSPredicate *)getUpdatedSincePredicate:(NSDate *)since {
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemFSContentChangeDate"] rightExpression:[NSExpression expressionForConstantValue:since] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:options];
}

+ (NSPredicate *)getContentCreatedSincePredicate:(NSDate *)since {
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemContentCreationDate"] rightExpression:[NSExpression expressionForConstantValue:since] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:options];
}

+ (NSPredicate *)getAddedPredicateAfter:(NSDate *)after andBefore:(NSDate *)before {
    NSPredicate *afterPred = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemDateAdded"] rightExpression:[NSExpression expressionForConstantValue:after] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:options];
    NSPredicate *beforePred = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemDateAdded"] rightExpression:[NSExpression expressionForConstantValue:before] modifier:NSDirectPredicateModifier type:NSLessThanOrEqualToPredicateOperatorType options:options];
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[afterPred, beforePred]];
}

+ (NSPredicate *)getCreatedPredicateAfter:(NSDate *)after andBefore:(NSDate *)before {
    NSPredicate *afterPred = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemFSCreationDate"] rightExpression:[NSExpression expressionForConstantValue:after] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:options];
    NSPredicate *beforePred = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemFSCreationDate"] rightExpression:[NSExpression expressionForConstantValue:before] modifier:NSDirectPredicateModifier type:NSLessThanOrEqualToPredicateOperatorType options:options];
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[afterPred, beforePred]];
}

+ (NSPredicate *)getUpdatedPredicateAfter:(NSDate *)after andBefore:(NSDate *)before {
    NSPredicate *afterPred = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemFSContentChangeDate"] rightExpression:[NSExpression expressionForConstantValue:after] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:options];
    NSPredicate *beforePred = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemFSContentChangeDate"] rightExpression:[NSExpression expressionForConstantValue:before] modifier:NSDirectPredicateModifier type:NSLessThanOrEqualToPredicateOperatorType options:options];
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[afterPred, beforePred]];
}

+ (NSPredicate *)getContentTypePredicate:(NSString *)type {
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemContentType"] rightExpression:[NSExpression expressionForConstantValue:type] modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:options];
}

+ (NSPredicate *)getDisplayNamePredicate:(NSString *)name {
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemDisplayName"] rightExpression:[NSExpression expressionForConstantValue:name] modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:options];
}

+ (NSPredicate *)getKindPredicate:(NSString *)kind {
    return [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"kMDItemKind"] rightExpression:[NSExpression expressionForConstantValue:kind] modifier:NSDirectPredicateModifier type:NSEqualToPredicateOperatorType options:options];
}

+ (NSPredicate *)getTimestampWithinAnHourOfPredicate:(NSDate *)ts {
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the end date components
    NSDateComponents *oneHourBeforeComp = [[NSDateComponents alloc] init];
    oneHourBeforeComp.hour = -1;
    NSDate *oneHourBefore = [calendar dateByAddingComponents:oneHourBeforeComp
                                                      toDate:ts
                                                     options:0];
    
    NSDateComponents *oneHourAfterComp = [[NSDateComponents alloc] init];
    oneHourAfterComp.hour = 1;
    NSDate *oneHourAfter = [calendar dateByAddingComponents:oneHourAfterComp
                                                      toDate:ts
                                                     options:0];
    NSPredicate *afterPred = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"timestamp"] rightExpression:[NSExpression expressionForConstantValue:oneHourBefore] modifier:NSDirectPredicateModifier type:NSGreaterThanOrEqualToPredicateOperatorType options:options];
    NSPredicate *beforePred = [NSComparisonPredicate predicateWithLeftExpression:[NSExpression expressionForKeyPath:@"timestamp"] rightExpression:[NSExpression expressionForConstantValue:oneHourAfter] modifier:NSDirectPredicateModifier type:NSLessThanOrEqualToPredicateOperatorType options:options];
    return [NSCompoundPredicate andPredicateWithSubpredicates:@[afterPred, beforePred]];
}

@end
