//
//  ECFilterViewController.m
//  ExtraCredits
//
//  Created by Drew Guarnera on 11/21/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import "ECFilterViewController.h"
#import "ECMasterViewController.h"
#import "ECFilterCellView.h"

@interface ECFilterViewController ()

@end

@implementation ECFilterViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.filterNames = @[@"Core Requirements",
                         @"Systems Track Required",
                         @"Business Track Required",
                         @"Completed Courses",
                         @"Incomplete Courses"];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (IBAction)cancel:(id)sender
{
    [self.delegate filterViewControllerDidCancel:self];
}

// Will need to do more than close the view
- (IBAction)done:(id)sender
{
    [self.delegate filterViewControllerDidSave:self];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.filterNames.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ECFilterCellView *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.filterName.text = self.filterNames[indexPath.row];

    return cell;
}

// Construct the predicate from the current filter status
-(NSPredicate *)constructPredicate
{




}

@end
