//
//  ECMasterViewController.h
//  ExtraCredits
//
//  Created by Drew Guarnera, Matthew Watzman, Evan Purkhiser on 11/8/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECDetailViewController;

#import <CoreData/CoreData.h>

@interface ECMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate> {
    NSMutableDictionary *courses_;
    NSString *documentPlistPath;
}

@property (nonatomic, retain) NSMutableDictionary* courses;

@property (strong, nonatomic) ECDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
