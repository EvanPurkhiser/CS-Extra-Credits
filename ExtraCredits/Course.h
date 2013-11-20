//
//  Course.h
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 11/19/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course, CourseTag, Subject;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSSet *alternatives;
@property (nonatomic, retain) NSSet *prerequisits;
@property (nonatomic, retain) NSSet *tags;
@property (nonatomic, retain) Subject *subject;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addAlternativesObject:(Course *)value;
- (void)removeAlternativesObject:(Course *)value;
- (void)addAlternatives:(NSSet *)values;
- (void)removeAlternatives:(NSSet *)values;

- (void)addPrerequisitsObject:(Course *)value;
- (void)removePrerequisitsObject:(Course *)value;
- (void)addPrerequisits:(NSSet *)values;
- (void)removePrerequisits:(NSSet *)values;

- (void)addTagsObject:(CourseTag *)value;
- (void)removeTagsObject:(CourseTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
