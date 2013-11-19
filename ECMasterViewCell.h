//
//  ECMasterViewCell.h
//  ExtraCredits
//
//  Created by Drew Guarnera on 11/18/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECMasterViewCell : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel *courseName;
@property (nonatomic, weak) IBOutlet UILabel *courseID;
@property (nonatomic, weak) IBOutlet UISwitch *courseSelected;

@end
