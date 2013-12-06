//
//  ECChartViewController.m
//  ExtraCredits
//
//  Created by Drew Guarnera, Matthew Watzman, Evan Purkhiser on 11/8/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import "ECChartViewController.h"
#import "ECAppDelegate.h"
#import "Course.h"
#import "Subject.h"
#import <QuartzCore/QuartzCore.h>

@implementation ECChartViewController

@synthesize pieChart = _pieChart;
@synthesize percentageLabel = _percentageLabel;
@synthesize selectedSliceLabel = _selectedSlice;
@synthesize numOfSlices = _numOfSlices;
@synthesize indexOfSlices = _indexOfSlices;
@synthesize downArrow = _downArrow;
@synthesize slices = _slices;
@synthesize sliceLabels = _sliceLabels;
@synthesize sliceColors = _sliceColors;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)loadChart
{
    // Set slices to an array of size 10
    self.slices = [NSMutableArray arrayWithCapacity:10];
    self.sliceLabels = [NSMutableArray arrayWithCapacity:10];
    
    // Set pie chart properties
    [self.pieChart setDelegate:self];
    [self.pieChart setDataSource:self];
    [self.pieChart setStartPieAngle:M_PI_2]; //optional
    [self.pieChart setAnimationSpeed:1.0]; //optional
    [self.pieChart setLabelFont:[UIFont boldSystemFontOfSize:MAX((int)self.pieChart.pieRadius/10, 20)]]; // optional
    [self.pieChart setLabelColor:[UIColor blackColor]];	//optional, defaults to white
    [self.pieChart setLabelShadowColor:nil]; //optional, defaults to none (nil)
    [self.pieChart setLabelRadius:160];	//optional
    [self.pieChart setShowPercentage:YES]; //optional
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]]; //optional
    [self.pieChart setPieCenter:CGPointMake(self.pieChart.frame.size.width/2, self.pieChart.frame.size.height/2)]; //optional
    [self.pieChart setPieRadius:MIN(self.pieChart.frame.size.width/2, self.pieChart.frame.size.height/2) - 10]; // optional
    [self.pieChart setLabelRadius:self.pieChart.pieRadius/1.75]; // optional
    [self.pieChart setLabelFont:[UIFont boldSystemFontOfSize:MAX((int)self.pieChart.pieRadius/10, 20)]]; // optional
    
    // Configure colors for first 5 slices
    self.sliceColors =[NSArray arrayWithObjects:
                       [UIColor colorWithRed:246/255.0 green:155/255.0 blue:0/255.0 alpha:1],
                       [UIColor colorWithRed:129/255.0 green:195/255.0 blue:29/255.0 alpha:1],
                       [UIColor colorWithRed:62/255.0 green:173/255.0 blue:219/255.0 alpha:1],
                       [UIColor colorWithRed:229/255.0 green:66/255.0 blue:115/255.0 alpha:1],
                       [UIColor colorWithRed:148/255.0 green:141/255.0 blue:139/255.0 alpha:1],nil];
}

- (void)clearChart
{
    // Release pie chart properties (set nil)
    [self setPieChart:nil];
    [self setPercentageLabel:nil];
    [self setSelectedSliceLabel:nil];
    [self setIndexOfSlices:nil];
    [self setNumOfSlices:nil];
    [self setDownArrow:nil];
}

- (void)loadSlices
{
    NSManagedObjectContext *context = ((ECAppDelegate *) [[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *courseRequest = [NSFetchRequest new];
    courseRequest.entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
    
    // Sort by course subject, status, number
    NSSortDescriptor *sortSubject = [[NSSortDescriptor alloc] initWithKey:@"subject" ascending:YES];
    NSSortDescriptor *sortStatus = [[NSSortDescriptor alloc] initWithKey:@"status" ascending:YES];
    NSSortDescriptor *sortNumber  = [[NSSortDescriptor alloc] initWithKey:@"number"  ascending:YES];
    courseRequest.sortDescriptors = @[sortSubject, sortStatus, sortNumber];
    
    NSArray *courses = [context executeFetchRequest:courseRequest error:nil];
    
    // First item is systems track
    if (self.track.selectedSegmentIndex == 0)
    {
        courseRequest.predicate = [NSPredicate predicateWithFormat:@"ANY tags.tag == 'systems-core'"];
        
        // Store last subject (initialize with empty string)
        NSString *lastSubject = @"";

        // Store last status (initialize with empty string)
        NSNumber *lastStatus = [NSNumber numberWithInt:4];
        
        // Store current slice index (for color and incrementing)
        NSInteger sliceIndex = -1;
        
        // Add slices based on subject and status
        for (int i = 0; i < [courses count]; i++)
        {
            
            // Retrieve course
            Course *course = [courses objectAtIndex:i];
            
            // Check to see if a new slice should be created
            if (![course.subject.number isEqual:lastSubject] || ![course.status isEqual:lastStatus]) {
                
                // Set lastSubject
                lastSubject = course.subject.number;
                
                // Set lastStatus
                lastStatus = course.status;
                
                // Create new slice
                NSNumber *slice = [NSNumber numberWithInt:1];
                
                // Set color of slice
                if ([course.status  isEqual: COURSE_HAVE_TAKEN]) {
                    
                    // Dark color
                    // ???
                }
                else {
                    
                    // Light color
                    // ???
                }
                
                // Add slice
                [_slices addObject:slice];
                
                // Add slice label
                NSString *labelStatus;
                
                if ([course.status isEqual:COURSE_HAVE_TAKEN]) {
                    labelStatus = @" (Taken)";
                }
                else {
                    labelStatus = @" (Not Taken)";
                }
                
                [_sliceLabels addObject:[course.subject.name stringByAppendingString:labelStatus]];
                
                // Increment sliceIndex
                ++sliceIndex;
            }
            
            // Otherwise...
            else {
                
                // Add number to current slice
                int count = [[_slices objectAtIndex:sliceIndex] intValue] + 1;
                NSNumber* countObject = [NSNumber numberWithInt:count];
                [_slices replaceObjectAtIndex:sliceIndex withObject:countObject];
            }
        }
    }
    
    // Second item is management track
    else
    {
        courseRequest.predicate = [NSPredicate predicateWithFormat:@"ANY tags.tag == 'management-core'"];
        
        // Add 2 slices (value=50)
        for (int i = 0; i < 2; i++)
        {
            NSNumber *one = [NSNumber numberWithInt:50];
            [_slices addObject:one];
        }
    }
    
    NSLog(@"%lu", (unsigned long)[courses count]);
    
    // Reload data
    [self.pieChart reloadData];
}

-(void) clearSlices
{
    // Remove all slices
    [_slices removeAllObjects];
    
    // Remove all slice labels
    [_sliceLabels removeAllObjects];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load chart
    [self loadChart];
}

- (void)viewDidUnload
{
    // Clear chart
    [self clearChart];
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // Load slices
    [self loadSlices];
}

- (void)viewWillDisappear:(BOOL)animated
{
	// Clear slices
    [self clearSlices];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}


/*
 Currently not implemented, may be useful in the future.
 */
- (IBAction)showSlicePercentage:(id)sender {
    UISwitch *perSwitch = (UISwitch *)sender;
    [self.pieChart setShowPercentage:perSwitch.isOn];
}

#pragma mark - XYPieChart Data Source

- (NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart {
    return self.slices.count;
}

- (CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index {
    return [[self.slices objectAtIndex:index] intValue];
}

- (UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index
{
    return [self.sliceColors objectAtIndex:(index % self.sliceColors.count)];
}

#pragma mark - XYPieChart Delegate

- (void)pieChart:(XYPieChart *)pieChart willSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will select slice at index %lu",(unsigned long)index);
}

- (void)pieChart:(XYPieChart *)pieChart willDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"will deselect slice at index %lu",(unsigned long)index);
}

- (void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did deselect slice at index %lu",(unsigned long)index);
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    NSLog(@"Label at index %lu: %@", (unsigned long)index, [_sliceLabels objectAtIndex:index]);
    self.selectedSliceLabel.text = [NSString stringWithFormat:@"$%@",[self.slices objectAtIndex:index]];
}

- (IBAction)trackChange:(id)sender
{
    // Clear slices
    [self clearSlices];
    
    // Load slices
    [self loadSlices];

    NSLog(@"Selected Index:%ld", (long)self.track.selectedSegmentIndex);
}

@end