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
{
    NSDictionary *_courseStatus;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
            [self disableControlsForiPad:NO];
        }
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
        
        _courseStatus = @{
            @"Haven't": COURSE_NOT_TAKEN,
            @"Have":         COURSE_HAVE_TAKEN,
            @"Will":     COURSE_WILL_TAKE,
            @"Won't":    COURSE_WONT_TAKE,
        };

        self.courseSelectionOptions = [_courseStatus allKeys];
        self.yearSelectionOptions = @[@"-", @"2011", @"2012", @"2013", @"2014", @"2015", @"2016", @"2017", @"2018"];
        self.semesterSelectionOptions = @[@"-", @"Spring", @"Summer", @"Fall"];
        
        self.courseSelection.delegate = self;
        self.courseSelection.dataSource = self;

        NSInteger statusRow = [self.courseSelectionOptions indexOfObject:
                               [_courseStatus allKeysForObject:self.detailItem.status][0]];
        [self.courseSelection selectRow:statusRow inComponent:0 animated:NO];

        if ([self.detailItem.year integerValue] == 0)
        {
            [self.courseSelection selectRow:0 inComponent:1 animated:NO];
        }
        else
        {
            NSInteger yearRow = [self.yearSelectionOptions indexOfObject:[self.detailItem.year stringValue]];
            [self.courseSelection selectRow:yearRow inComponent:1 animated:NO];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self disableControlsForiPad:YES];
    }

	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.detailItem.status = _courseStatus[[self.courseSelectionOptions objectAtIndex:[self.courseSelection selectedRowInComponent:0]]];
    
    NSInteger yearRow = [self.courseSelection selectedRowInComponent:1];
    NSLog(@"%ld", (long)yearRow);
    if (yearRow == 0)
    {
        // Year zero for unknown
        self.detailItem.year = 0;
    }
    else
    {
        self.detailItem.year = [NSNumber numberWithInt:[[self.yearSelectionOptions objectAtIndex:yearRow] intValue]];
    }
    
    [[self.detailItem managedObjectContext] save:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) disableControlsForiPad:(BOOL) visible
{
    if (visible) {
        self.courseDescriptionView.hidden = YES;
        self.courseNameLabel.hidden = YES;
        self.courseSelection.hidden = YES;
    }
    else {
        self.courseDescriptionView.hidden = NO;
        self.courseNameLabel.hidden = NO;
        self.courseSelection.hidden = NO;
    }
}

#pragma mark - UIPickerView DataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    if (component == 0)
        return [self.courseSelectionOptions count];
    
    if (component == 1)
        return [self.yearSelectionOptions count];
    
    if (component == 2)
        return [self.semesterSelectionOptions count];
    
    return 0;
}

#pragma mark - UIPickerView Delegate
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 30.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
        return [self.courseSelectionOptions objectAtIndex:row];
    
    if (component == 1)
        return [self.yearSelectionOptions objectAtIndex:row];
    
    if (component == 2)
        return [self.semesterSelectionOptions objectAtIndex:row];
    
    return 0;
}

#pragma mark - Split view

- (void)splitViewController:(UISplitViewController *)splitController willHideViewController:(UIViewController *)viewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)popoverController
{
    barButtonItem.title = NSLocalizedString(@"Courses", @"Courses");
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
