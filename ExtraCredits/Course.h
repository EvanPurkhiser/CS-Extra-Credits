//
//  Course.h
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 12/3/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define COURSE_NOT_TAKEN  @0
#define COURSE_HAVE_TAKEN @1
#define COURSE_WILL_TAKE  @2
#define COURSE_WONT_TAKE  @3

#define COURSE_SPRING @1
#define COURSE_FALL   @2
#define COURSE_SUMMER @3

@class Course, CourseTag, Subject;

@interface Course : NSManagedObject

@property (nonatomic, retain) NSNumber * credits;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSNumber * semester;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSNumber * year;
@property (nonatomic, retain) NSSet *alternatives;
@property (nonatomic, retain) NSSet *prerequisites;
@property (nonatomic, retain) Subject *subject;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Course (CoreDataGeneratedAccessors)

- (void)addAlternativesObject:(Course *)value;
- (void)removeAlternativesObject:(Course *)value;
- (void)addAlternatives:(NSSet *)values;
- (void)removeAlternatives:(NSSet *)values;

- (void)addPrerequisitesObject:(Course *)value;
- (void)removePrerequisitesObject:(Course *)value;
- (void)addPrerequisites:(NSSet *)values;
- (void)removePrerequisites:(NSSet *)values;

- (void)addTagsObject:(CourseTag *)value;
- (void)removeTagsObject:(CourseTag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
