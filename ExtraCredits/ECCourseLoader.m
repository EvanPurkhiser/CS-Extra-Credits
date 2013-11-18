//
//  ECCourseLoader.m
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 11/18/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import "ECCourseLoader.h"

// This is the URL that will be checked to update the course list
#define IMPORT_URL "https://gist.github.com/EvanPurkhiser/7535783/raw/courseSeed.plist"

@implementation LoadedData (ECCourseLoader)

+ (void)updateCourseData:(NSManagedObjectContext *)context
{
    // Get the latest version of the data that we have
    NSFetchRequest *request = [NSFetchRequest new];
    request.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"version" ascending:NO]];
    request.entity = [NSEntityDescription entityForName:@"LoadedData" inManagedObjectContext:context];
    request.fetchLimit = 1;

    // Get the updated versions. This will be an empty array or a single entity
    NSArray *updatedVersions = [context executeFetchRequest:request error:nil];

    // If we have no data then initalize from the seed
    if ([updatedVersions count] == 0)
    {
        NSLog(@"No data. Loading from local seed");


    }

    // Kick off the background request to updated the course date from the remote courseSeed
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0),
    ^{
        NSLog(@"Checking for data update from remote seed");


    });
}

@end
