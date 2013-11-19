//
//  ECCourseLoader.m
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 11/18/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import "ECCourseLoader.h"
#import "Course.h"

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
            // Create new model for the version and update for the data
            [[[self alloc] initWithEntity:request.entity insertIntoManagedObjectContext:context] initializeNewCourseData:data];
        }
    });
}

- (void)initializeNewCourseData:(NSDictionary *)data
{
    // Set the version for this new version
    self.version = data[@"version"];

    // Get our managed object context and a entity for the Course model
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *courseEntity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];

    // Iterate over all passed courses and check if they exist already
    for (NSDictionary *course in data[@"courses"])
    {
        // Find the course if it exists
        NSFetchRequest *courseRequest = [NSFetchRequest new];
        courseRequest.entity = courseEntity;
        courseRequest.predicate = [NSPredicate predicateWithFormat:@"subject == %@ AND number == %@", course[@"subject"], course[@"number"]];

        NSArray *results = [context executeFetchRequest:courseRequest error:nil];

        // Get the first or new course
        Course *courseModel = [results count] > 0 ? results[0] : [[Course alloc] initWithEntity:courseEntity insertIntoManagedObjectContext:context];

        // Update the course information
        courseModel.name    = course[@"name"];
        courseModel.subject = course[@"subject"];
        courseModel.number  = course[@"number"];
        courseModel.details = course[@"details"];
    }

    dispatch_async(dispatch_get_main_queue(),
    ^{
        [[self managedObjectContext] save:nil];
    });
}

@end
