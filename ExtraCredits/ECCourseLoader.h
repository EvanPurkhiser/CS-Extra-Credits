//
//  ECCourseLoader.h
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 11/18/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadedData.h"

@interface LoadedData (ECCourseLoader)

+ (void)updateCourseData:(NSManagedObjectContext *)context;

@end
