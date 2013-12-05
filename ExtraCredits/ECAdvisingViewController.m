//
//  ECAdvisingViewController.m
//  ExtraCredits
//
//  Created by Drew Guarnera, Matthew Watzman, Evan Purkhiser on 11/8/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import "ECAdvisingViewController.h"
#import "ECAppDelegate.h"
#import "Course.h"

@interface ECAdvisingViewController ()

@end

@implementation ECAdvisingViewController
{
    NSDictionary *_advisors;
    NSDictionary *_courseSemester;
}

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
    _advisors = @{
        @"Chan":    @"chan@uakron.edu",
        @"Cheng":   @"echeng@uakron.edu",
        @"Collard": @"collard@uakron.edu",
        @"Duan":    @"duan@uakron.edu",
        @"Liszka":  @"liszka@uakron.edu",
        @"O’Neil":  @"toneil@uakron.edu ",
        @"Sutton":  @"asutton@uakron.edu",
        @"Xiao":    @"xiao@uakron.edu",
    };

    _courseSemester = @{
        @"Spring": COURSE_SPRING,
        @"Summer": COURSE_SUMMER,
        @"Fall":   COURSE_FALL,
    };

    self.advisorSelectionOptions = [@[@""] arrayByAddingObjectsFromArray:[_advisors allKeys]];
    self.scheduleYearSelectionOptions = @[@"", @"2011", @"2012", @"2013", @"2014", @"2015", @"2016", @"2017", @"2018"];
    self.scheduleSemesterSelectionOptions = [@[@""] arrayByAddingObjectsFromArray:[[_courseSemester allKeys] sortedArrayUsingSelector:
                                                                                    @selector(localizedCaseInsensitiveCompare:)]];
    
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

- (IBAction)sendEmail:(id)sender
{
    ECAppDelegate *appDelegate = (ECAppDelegate *) [[UIApplication sharedApplication] delegate];

    NSFetchRequest *courseRequest = [NSFetchRequest new];
    courseRequest.entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:appDelegate.managedObjectContext];

    NSNumber *semester = _courseSemester[[self.scheduleSemesterSelectionOptions objectAtIndex:[self.advisorSelection selectedRowInComponent:2]]];
    NSNumber *year     = [self.scheduleYearSelectionOptions objectAtIndex:[self.advisorSelection selectedRowInComponent:1]];

    courseRequest.predicate = [NSPredicate predicateWithFormat:@"status = %@ AND semester = %@ AND year = %@", COURSE_WILL_TAKE, semester, year];

    NSArray *courses = [appDelegate.managedObjectContext executeFetchRequest:courseRequest error:nil];

    // Notify if no courses to email
    if ([courses count] == 0)
    {
        [[[UIAlertView alloc] initWithTitle:@"Nope!" message:@"No courses marked to be taken for the specified year / semester" delegate:self cancelButtonTitle:@"Oh, OK" otherButtonTitles: nil] show];

        return;
    }

    NSString *advisor = [self.advisorSelectionOptions objectAtIndex:[self.advisorSelection selectedRowInComponent:0]];
    NSString *email = _advisors[advisor];

    NSMutableString *messages = [NSMutableString new];

    for (Course *course in courses)
    {
        [messages appendFormat:@" * %@\n", course.name];
    }

    NSString *message = [NSString stringWithFormat:@"Dr. %@,\n\nHere's a list of courses I was looking at taking:\n\n%@\n What do you think?\n\nThanks,\n\nSend from ExtraCredits", advisor, messages];

    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"mailto:?to=%@&subject=%@&body=%@",
                                                [email stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [@"Advising" stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding],
                                                [message stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]]];

    [[UIApplication sharedApplication] openURL:url];
}

@end
