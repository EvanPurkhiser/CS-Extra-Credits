//
//  ECFilterViewController.h
//  ExtraCredits
//
//  Created by Drew Guarnera on 11/21/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ECFilterViewController;

@protocol ECFilterViewControllerDelegate <NSObject>
- (void)filterViewControllerDidCancel:(ECFilterViewController *)controller;
- (void)filterViewControllerDidSave:(ECFilterViewController *)controller;
@end

@interface ECFilterViewController : UITableViewController

@property (nonatomic, weak) id <ECFilterViewControllerDelegate> delegate;

@property NSArray      *filterNames;
@property NSDictionary *filterPredicates;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

- (NSPredicate *) constructPredicate;

@end


