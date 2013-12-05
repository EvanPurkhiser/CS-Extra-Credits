//
//  ECChartViewController.h
//  ExtraCredits
//
//  Created by Drew Guarnera, Matthew Watzman, Evan Purkhiser on 11/8/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"

@interface ECChartViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource>

@property (strong, nonatomic) IBOutlet XYPieChart *pieChart;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;
@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;
@property (strong, nonatomic) IBOutlet UITextField *numOfSlices;
@property (strong, nonatomic) IBOutlet UISegmentedControl *indexOfSlices;
@property (strong, nonatomic) IBOutlet UIButton *downArrow;
@property(nonatomic, strong) NSMutableArray *slices;
@property(nonatomic, strong) NSArray *sliceColors;

@property (weak, nonatomic) IBOutlet UISegmentedControl *track;
- (IBAction)trackChange:(id)sender;

- (void)loadChart;

@end