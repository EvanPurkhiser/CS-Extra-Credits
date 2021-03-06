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

@property (strong, nonatomic) IBOutlet UILabel *selectedSliceLabel;

@property(nonatomic, strong) NSMutableArray *slices;

@property(nonatomic, strong) NSMutableArray *sliceLabels;

@property(nonatomic, strong) NSMutableArray *sliceColors;

@property (weak, nonatomic) IBOutlet UISegmentedControl *track;

- (IBAction)trackChange:(id)sender;

- (void)loadChart;

@end