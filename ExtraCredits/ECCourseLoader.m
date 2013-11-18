//
//  ECCourseLoader.m
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 11/18/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import "ECCourseLoader.h"

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
        if ([[data valueForKey:@"version"] integerValue] > [loadedDataModel.version integerValue])
        {
            // Create new model for the version and update for the data
            [[[self alloc] initWithEntity:request.entity insertIntoManagedObjectContext:context] initializeNewCourseData:data];
        }
    });
}

- (void)initializeNewCourseData:(NSDictionary *)data
{
    NSLog(@"DOING UPDATE NOW!");
}

@end
