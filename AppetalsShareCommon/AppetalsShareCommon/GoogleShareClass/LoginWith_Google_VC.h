//
//  LoginWith_Google_VC.h
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 18/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginWith_Google.h"
@interface LoginWith_Google_VC : UIViewController<googleDelegate>

- (IBAction)loginWithGPlus:(id)sender;
- (IBAction)fetchUserInfo:(id)sender;
- (IBAction)fetchFriends:(id)sender;
- (IBAction)postOnG:(id)sender;

- (IBAction)backClicked:(id)sender;
@end
