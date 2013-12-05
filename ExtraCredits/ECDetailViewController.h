//
//  ECDetailViewController.h
//  ExtraCredits
//
//  Created by Drew Guarnera, Matthew Watzman, Evan Purkhiser on 11/8/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface ECDetailViewController : UIViewController <UISplitViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) Course *detailItem;

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;

@property (weak, nonatomic) IBOutlet UITextView *courseDescriptionView;

@property (strong, nonatomic) IBOutlet UIPickerView *courseSelection;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

@property (strong, nonatomic) NSArray *courseSelectionOptions;

@property (strong, nonatomic) NSArray *yearSelectionOptions;

@property (strong, nonatomic) NSArray *semesterSelectionOptions;

- (IBAction)saveiPadDetail:(id)sender;

@end