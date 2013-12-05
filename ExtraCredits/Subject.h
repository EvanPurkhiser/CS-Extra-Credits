//
//  Subject.h
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 11/26/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define SUBJECT_COLORS @[[UIColor blueColor], \
                         [UIColor redColor],  \
                         [UIColor colorWithRed:70.0/255.0 green:150.0/255.0 blue:20.0/255.0 alpha:1.0],  \
                         [UIColor colorWithRed:202.0/255.0 green:20.0/255.0 blue:222.0/255.0 alpha:1.0], \
                         [UIColor colorWithRed:57.0/255.0 green:168.0/255.0 blue:155.0/255.0 alpha:1.0], \
]

@class Course;

@interface Subject : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * number;
@property (nonatomic, retain) NSSet *courses;
@end

@interface Subject (CoreDataGeneratedAccessors)

- (void)addCoursesObject:(Course *)value;
- (void)removeCoursesObject:(Course *)value;
- (void)addCourses:(NSSet *)values;
- (void)removeCourses:(NSSet *)values;

@end
