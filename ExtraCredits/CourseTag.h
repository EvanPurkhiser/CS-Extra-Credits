//
//  CourseTag.h
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 11/21/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface CourseTag : NSManagedObject

@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSSet *courses;
@end

@interface CourseTag (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
