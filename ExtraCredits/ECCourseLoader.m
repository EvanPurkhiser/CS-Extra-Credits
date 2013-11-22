//
//  ECCourseLoader.m
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 11/18/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import "ECCourseLoader.h"
#import "Course.h"
#import "Subject.h"
#import "CourseTag.h"

// This is the URL that will be checked to update the course list
#define IMPORT_URL @"https://gist.github.com/EvanPurkhiser/7535783/raw/courseSeed.plist"

@implementation LoadedData (ECCourseLoader)

+ (void)updateCourseData:(NSManagedObjectContext *)context
{
    // Get the latest version of the data that we have
    NSFetchRequest *request = [NSFetchRequest new];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"version" ascending:NO]];
    request.entity = [NSEntityDescription entityForName:@"LoadedData" inManagedObjectContext:context];
    request.fetchLimit = 1;

    // Get the updated versions. This will be an empty array or a single entity
    NSArray *currentVersions = [context executeFetchRequest:request error:nil];

    LoadedData *loadedDataModel;

    // If we have no data then initalize from the seed
    if ([currentVersions count] == 0)
    {
        NSLog(@"No data. Loading from local seed");

        // Get the seed data
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"CourseSeed" ofType:@"plist"];
        NSDictionary *data = [[NSDictionary alloc] initWithContentsOfFile:plistPath];

        // Get a new model for the new version we are adding
        loadedDataModel = [[self alloc] initWithEntity:request.entity insertIntoManagedObjectContext:context];

        // Load a new version of the course data from the CourseSeed
        [loadedDataModel initializeNewCourseData:data];
    }

    // If we have a current version grab the model
    else
    {
        loadedDataModel = currentVersions[0];
    }

    // Kick off the background request to updated the course date from the remote courseSeed
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
    ^{
        NSLog(@"Checking for data update from remote seed");

        // Get the seed data from the remote
        NSDictionary *data = [[NSDictionary alloc] initWithContentsOfURL:[NSURL URLWithString:IMPORT_URL]];

        // Only update if the downloaded version is newer
        if ([data[@"version"] integerValue] > [loadedDataModel.version integerValue])
        {
            dispatch_async(dispatch_get_main_queue(),
            ^{
                // Create new model for the version and update for the data
                [[[self alloc] initWithEntity:request.entity insertIntoManagedObjectContext:context] initializeNewCourseData:data];
            });
        }
    });
}

- (void)initializeNewCourseData:(NSDictionary *)data
{
    // Set the version for this new version
    self.version = data[@"version"];
    [[self managedObjectContext] save:nil];

    NSManagedObjectContext *context = [self managedObjectContext];

    // Get descriptors for used entities
    NSEntityDescription *courseEntity    = [NSEntityDescription entityForName:@"Course"    inManagedObjectContext:context];
    NSEntityDescription *subjectEntity   = [NSEntityDescription entityForName:@"Subject"   inManagedObjectContext:context];
    NSEntityDescription *courseTagEntity = [NSEntityDescription entityForName:@"CourseTag" inManagedObjectContext:context];

    // Store subject and tag models in a dictionary
    NSMutableDictionary *subjects = [data[@"subjectNames"] mutableCopy];

    // Iterate over all passed subjects
    for (id subjectNumber in data[@"subjectNames"])
    {
        // Check if subject is already exists
        NSFetchRequest *subjectRequest = [NSFetchRequest new];
        subjectRequest.entity = subjectEntity;
        subjectRequest.predicate = [NSPredicate predicateWithFormat:@"number = %@", subjectNumber];

        NSArray *results = [context executeFetchRequest:subjectRequest error:nil];

        // Get the first or new subject
        Subject *subject = [results count] > 0 ? results[0] : [[Subject alloc] initWithEntity:subjectEntity insertIntoManagedObjectContext:context];

        subject.number = subjectNumber;
        subject.name   = subjects[subjectNumber];

        // Keep track of he Subject managed object for reference later
        subjects[subjectNumber] = subject;
    }

    // Remove old subjects that no longer exists subjects
    NSFetchRequest *oldSubjectsRequest = [NSFetchRequest new];
    oldSubjectsRequest.entity = subjectEntity;
    oldSubjectsRequest.predicate = [NSPredicate predicateWithFormat:@"NOT (number IN %@)", [subjects allKeys]];

    for (NSManagedObject *oldSubjct in [context executeFetchRequest:oldSubjectsRequest error:nil])
    {
        [context deleteObject:oldSubjct];
    }

    [context save:nil];

    // Iterate over all passed courses
    for (NSDictionary *course in data[@"courses"])
    {
        // Find the course if it exists
        NSFetchRequest *courseRequest = [NSFetchRequest new];
        courseRequest.entity = courseEntity;
        courseRequest.predicate = [NSPredicate predicateWithFormat:@"subject.number == %@ AND number == %@", course[@"subject"], course[@"number"]];

        NSArray *results = [context executeFetchRequest:courseRequest error:nil];

        // Get the first or new course
        Course *courseModel = [results count] > 0 ? results[0] : [[Course alloc] initWithEntity:courseEntity insertIntoManagedObjectContext:context];

        // Update the course information
        courseModel.name    = course[@"name"];
        courseModel.number  = course[@"number"];
        courseModel.details = course[@"details"];
        courseModel.subject = subjects[course[@"subject"]];

        // Add course tags
        for (NSString *tag in course[@"tags"])
        {
            NSFetchRequest *courseRequest = [NSFetchRequest new];
            courseRequest.entity = courseTagEntity;
            courseRequest.predicate = [NSPredicate predicateWithFormat:@"tag == %@", tag];

            // Get the tag or create a new tag if nessicary
            NSArray   *results  = [context executeFetchRequest:courseRequest error:nil];
            CourseTag *tagModel = [results count] > 0 ? results[0] : [[CourseTag alloc] initWithEntity:courseTagEntity insertIntoManagedObjectContext:context];

            tagModel.tag = tag;
            [courseModel addTagsObject:tagModel];
        }

        [context save:nil];
    }

    // Iterate through courses again and setup alternative and prerequisit sets
    for (NSDictionary *course in data[@"courses"])
    {
        // Grab the entity
        NSFetchRequest *courseRequest = [NSFetchRequest new];
        courseRequest.entity = courseEntity;
        courseRequest.predicate = [NSPredicate predicateWithFormat:@"subject.number == %@ AND number == %@", course[@"subject"], course[@"number"]];

        Course *courseModel = [context executeFetchRequest:courseRequest error:nil][0];

        NSMutableDictionary *relatedCourses = [@{@"alternatives": @0, @"prerequisites": @0} mutableCopy];

        for (NSString *relationId in [relatedCourses allKeys])
        {
            NSMutableSet *courseSet = [NSMutableSet new];
            relatedCourses[relationId] = courseSet;

            for (NSDictionary *refCourse in course[relationId])
            {
                NSFetchRequest *courseRequest = [NSFetchRequest new];
                courseRequest.entity = courseEntity;
                courseRequest.predicate = [NSPredicate predicateWithFormat:@"subject.number == %@ AND number == %@", refCourse[@"subject"], refCourse[@"number"]];

                [courseSet addObject:[context executeFetchRequest:courseRequest error:nil][0]];
            }
        }

        [courseModel addAlternatives:relatedCourses[@"alternatives"]];
        [courseModel addPrerequisites:relatedCourses[@"prerequisites"]];

        [context save:nil];
    }
}

@end
