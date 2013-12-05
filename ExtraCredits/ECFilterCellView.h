//
//  ECFilterCellView.h
//  ExtraCredits
//
//  Created by Purkhiser,Evan on 12/3/13.
//  Copyright (c) 2013 iOS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ECFilterCellView : UITableViewCell

@property (nonatomic, weak) IBOutlet UILabel  *filterName;
@property (nonatomic, weak) IBOutlet UISwitch *statusSwitch;

@end
