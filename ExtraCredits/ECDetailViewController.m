//
//  ECDetailViewController.m
//  ExtraCredits
//
//  Created by Drew Guarnera, Matthew Watzman, Evan Purkhiser on 11/8/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import "ECDetailViewController.h"
#import "Course.h"
#import "Subject.h"

@interface ECDetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation ECDetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }

    if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        
        // Set nav. bar title (course subject:course number (credits))
        Course *course = self.detailItem;
        self.navigationItem.title = [NSString stringWithFormat:@"%@:%@ (%@ credits)",
                                     course.subject.number,
                                     course.number,
                                     course.credits];
        
        // Set course name label
        self.courseNameLabel.text = [[self.detailItem valueForKey:@"name"] description];
        self.courseNameLabel.textAlignment = NSTextAlignmentCenter;
        self.courseNameLabel.font = [UIFont fontWithName:@"TrebuchetMS-Bold" size:18];
        self.courseNameLabel.numberOfLines = 0;
        self.courseNameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        
        // Set course description label
        self.courseDescriptionView.text = [[self.detailItem valueForKey:@"details"] description];
        
        self.courseSelectionOptions = [[NSArray alloc] initWithObjects:@"Haven't Taken", @"Will Take", @"Won't Take", nil];
        self.yearSelectionOptions = [[NSArray alloc] initWithObjects:@"-",@"2014", @"2015", @"2016", @"2017", @"2018", nil];
        
        self.courseSelection.delegate = self;
        self.courseSelection.dataSource = self;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UIPickerView DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    if(component== 0)
    {
        return [self.courseSelectionOptions count];
    }
    else
    {
        return [self.yearSelectionOptions count];
    }
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(component== 0)
    {
        return [self.courseSelectionOptions objectAtIndex:row];
    }
    else
    {
        return [self.yearSelectionOptions objectAtIndex:row];
    }
}

//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Let's print in the console what the user had chosen;
    NSLog(@"Chosen item: %@", [self.courseSelectionOptions objectAtIndex:row]);
}


#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Master", @"Master");
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = popoverController;
}

- (void)splitViewController:(UISplitViewController *)splitController willShowViewController:(UIViewController *)viewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}

@end
