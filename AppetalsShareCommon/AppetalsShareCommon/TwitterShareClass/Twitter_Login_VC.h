//
//  Twitter_Login_VC.h
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 18/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Twitter_Login.h"
@interface Twitter_Login_VC : UIViewController<twitterDelegate>

- (IBAction)loginClicked:(id)sender;
- (IBAction)postOnTwitter:(id)sender;
- (IBAction)fetchFriends:(id)sender;

- (IBAction)backClicked:(id)sender;
- (IBAction)fetchUserTimeline:(id)sender;

@end
