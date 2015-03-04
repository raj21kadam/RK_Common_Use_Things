//
//  FriendsTableViewCell.m
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 25/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import "FriendsTableViewCell.h"

@implementation FriendsTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    _bgView.layer.cornerRadius = 4;
    _bgView.clipsToBounds = YES;
    
    _profileImage.layer.cornerRadius = 4;
    _profileImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
