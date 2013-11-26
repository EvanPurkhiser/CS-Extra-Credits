//
//  CourseTracked.h
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 11/26/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Course;

@interface CourseTracked : NSManagedObject

@property (nonatomic, retain) NSNumber * completed;
@property (nonatomic, retain) Course *course;

@end
