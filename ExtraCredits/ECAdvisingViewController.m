//
//  ECAdvisingViewController.m
//  ExtraCredits
//
//  Created by Drew Guarnera, Matthew Watzman, Evan Purkhiser on 11/8/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import "ECAdvisingViewController.h"

@interface ECAdvisingViewController ()

@end

@implementation ECAdvisingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)configureView
{
    self.advisorSelectionOptions = @[@"-", @"Chan", @"Cheng", @"Collard", @"Duan", @"Liszka", @"O’Neil", @"Sutton", @"Xiao"];
    self.scheduleYearSelectionOptions = @[@"-", @"2011", @"2012", @"2013", @"2014", @"2015", @"2016", @"2017", @"2018"];
    self.scheduleSemesterSelectionOptions = @[@"-", @"Spr", @"Sum", @"Fall"];
    
    self.advisorSelection.delegate = self;
    self.advisorSelection.dataSource = self;
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
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    if (component == 0)
        return [self.advisorSelectionOptions count];
    if (component == 1)
        return [self.scheduleYearSelectionOptions count];
    if (component == 2)
        return [self.scheduleSemesterSelectionOptions count];

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
        return [self.advisorSelectionOptions objectAtIndex:row];
    if (component == 1)
        return [self.scheduleYearSelectionOptions objectAtIndex:row];
    if (component == 2)
        return [self.scheduleSemesterSelectionOptions objectAtIndex:row];
    
    return 0;
}

//If the user chooses from the pickerview, it calls this function;
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //Let's print in the console what the user had chosen;
    if (component == 0)
    {
        NSLog(@"Chosen item: %@", [self.advisorSelectionOptions objectAtIndex:row]);
    }
    else
    {
        NSLog(@"Chosen item: %@", [self.scheduleYearSelectionOptions objectAtIndex:row]);
    }
}


@end
