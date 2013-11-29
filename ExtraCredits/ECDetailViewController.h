//
//  ECDetailViewController.h
//  ExtraCredits
//
//  Created by Drew Guarnera, Matthew Watzman, Evan Purkhiser on 11/8/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECDetailViewController : UIViewController <UISplitViewControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;

@property (weak, nonatomic) IBOutlet UITextView *courseDescriptionView;

@property (strong, nonatomic) IBOutlet UIPickerView *courseSelection;

@property (strong, nonatomic) NSArray *courseSelectionOptions;

@property (strong, nonatomic) NSArray *yearSelectionOptions;

- (IBAction) selectedPickerRow;

@end