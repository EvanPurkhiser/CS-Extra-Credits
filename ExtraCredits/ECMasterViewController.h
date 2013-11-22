//
//  ECMasterViewController.h
//  ExtraCredits
//
//  Created by Drew Guarnera, Matthew Watzman, Evan Purkhiser on 11/8/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ECFilterViewController.h"

@class ECDetailViewController;

@interface ECMasterViewController : UITableViewController <NSFetchedResultsControllerDelegate, ECFilterViewControllerDelegate>

@property (strong, nonatomic) ECDetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
