//
//  Subject.m
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 11/26/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import "Subject.h"
#import "Course.h"


@implementation Subject

@dynamic name;
@dynamic number;
@dynamic courses;

- (UIColor *) color
{
    // Horrible way to get a index
    NSFetchRequest *courseRequest = [NSFetchRequest new];
    courseRequest.entity = self.entity;
    NSArray *subjects = [self.managedObjectContext executeFetchRequest:courseRequest error:nil];

    NSUInteger index = [subjects indexOfObject:self];

    return SUBJECT_COLORS[index % [SUBJECT_COLORS count]];
}

@end
