//
//  Course.h
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 11/18/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * subject;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) NSSet *prerequisits;
@property (nonatomic, retain) NSSet *alternatives;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addTagsObject:(NSManagedObject *)value;
- (void)removeTagsObject:(NSManagedObject *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

- (void)addPrerequisitsObject:(Course *)value;
- (void)removePrerequisitsObject:(Course *)value;
- (void)addPrerequisits:(NSSet *)values;
- (void)removePrerequisits:(NSSet *)values;

- (void)addAlternativesObject:(Course *)value;
- (void)removeAlternativesObject:(Course *)value;
- (void)addAlternatives:(NSSet *)values;
- (void)removeAlternatives:(NSSet *)values;

@end
