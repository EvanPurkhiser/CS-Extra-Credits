//
//  ECAdvisingViewController.h
//  ExtraCredits
//
//  Created by Matthew Watzman on 11/21/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECAdvisingViewController : UIViewController <UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) IBOutlet UIPickerView *advisorSelection;

@property (strong, nonatomic) NSArray *advisorSelectionOptions;

@property (strong, nonatomic) NSArray *scheduleYearSelectionOptions;

@property (strong, nonatomic) NSArray *scheduleSemesterSelectionOptions;

- (IBAction) selectedPickerRow;
- (NSArray *) selectedCourses;

- (IBAction)sendEmail:(id)sender;

@end
