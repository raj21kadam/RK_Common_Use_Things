//
//  FriendsTableViewCell.h
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 25/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FriendsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
@property (strong, nonatomic) IBOutlet UILabel *name_label;
@property (strong, nonatomic) IBOutlet UILabel *location_label;

@end
