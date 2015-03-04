//
//  ProfileViewController.h
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 25/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginWith_Google.h"
#import "Twitter_Login.h"

@interface ProfileViewController : UIViewController<googleDelegate,twitterDelegate>

- (IBAction)backClicked:(id)sender;
@property (nonatomic,assign) BOOL fromFB;
@property (nonatomic,strong) NSMutableDictionary*userInfo;
@property (nonatomic,assign) BOOL fromTwitter;
@property (strong, nonatomic) IBOutlet UILabel *lbl_name;
@property (strong, nonatomic) IBOutlet UILabel *lbl_email;
@property (strong, nonatomic) IBOutlet UILabel *lbl_gender;
@property (strong, nonatomic) IBOutlet UIImageView *profileImage;
- (IBAction)fetchFriendsClicked:(id)sender;
- (IBAction)postOnWallClicked:(id)sender;
- (IBAction)fetchUserPosts:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *fetchuserPost_outlet;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *allBtns;

@end
