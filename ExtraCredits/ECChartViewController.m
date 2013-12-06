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
@synthesize selectedSliceLabel = _selectedSlice;
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
    // Initialize slices to an array of size 10
    self.slices = [NSMutableArray arrayWithCapacity:10];
    
    // Initialize slice labels to an array of size 10
    self.sliceLabels = [NSMutableArray arrayWithCapacity:10];
    
    // Initialize slice colors to an array of size 10
    self.sliceColors = [NSMutableArray arrayWithCapacity:10];
    
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
}

- (void)clearChart
{
    // Release pie chart properties (set nil)
    [self setPieChart:nil];
    [self setSelectedSliceLabel:nil];
}

- (void)loadSlices
{
    NSManagedObjectContext *context = ((ECAppDelegate *) [[UIApplication sharedApplication] delegate]).managedObjectContext;
    
    NSFetchRequest *courseRequest = [NSFetchRequest new];
    courseRequest.entity = [NSEntityDescription entityForName:@"Course" inManagedObjectContext:context];
    
    // Sort by course subject, status, number
    NSSortDescriptor *sortSubject = [[NSSortDescriptor alloc] initWithKey:@"subject" ascending:YES];
    NSSortDescriptor *sortStatus = [[NSSortDescriptor alloc] initWithKey:@"status" ascending:NO];
    NSSortDescriptor *sortNumber  = [[NSSortDescriptor alloc] initWithKey:@"number"  ascending:YES];
    courseRequest.sortDescriptors = @[sortSubject, sortStatus, sortNumber];
    
    NSArray *courses = [context executeFetchRequest:courseRequest error:nil];
    
    // First item is systems track
    if (self.track.selectedSegmentIndex == 0)
    {
        courseRequest.predicate = [NSPredicate predicateWithFormat:@"ANY tags.tag == 'systems-core'"];
    }
    // Second item is management track
    else
    {
        courseRequest.predicate = [NSPredicate predicateWithFormat:@"ANY tags.tag == 'management-core'"];
    }
    
    // Store last subject (initialize with empty string)
    NSString *lastSubject = @"";
    
    // Store last status (initialize with 4)
    NSNumber *lastStatus = [NSNumber numberWithInt:4];
    
    // Store current slice index (for incrementing)
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
                UIColor *color = course.subject.color;
                
                // Add color to array
                [_sliceColors addObject:color];
            }
            else {
                
                // Light color (alpha 0.75)
                UIColor *color = [course.subject.color colorWithAlphaComponent:0.80];
                
                // Add color to array
                [_sliceColors addObject:color];
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
    
    // Center label text
    self.selectedSliceLabel.textAlignment = NSTextAlignmentCenter;
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
    self.selectedSliceLabel.text = @"";
}

- (void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index
{
    NSLog(@"did select slice at index %lu",(unsigned long)index);
    NSLog(@"Label at index %lu: %@", (unsigned long)index, [_sliceLabels objectAtIndex:index]);
    self.selectedSliceLabel.text = [_sliceLabels objectAtIndex:index];
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