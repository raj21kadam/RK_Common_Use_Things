//
//  LoginWith_Google_VC.m
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 18/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import "LoginWith_Google_VC.h"
#import "GPConstantsClass.h"
#import "Twitter_Login_VC.h"
#import "ProfileViewController.h"
#import "KVNProgress.h"
@interface LoginWith_Google_VC ()

@end

@implementation LoginWith_Google_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated {
    
    /*Twitter_Login_VC*test = [[Twitter_Login_VC alloc] init];
    NSMutableDictionary*dict = [[NSMutableDictionary alloc] init];
    
   
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userInfo:)
                                                 name:kGPUserInfo
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(user_friend_list:)
                                                 name:kGPFriendList
                                               object:nil];*/
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginWithGPlus:(id)sender {
    
    [KVNProgress showWithStatus:@"Loading..."];
     [[LoginWith_Google sharedInstance] doLoginWithGooglePlus:self googleClientId:kClientId];
   
}

- (IBAction)fetchUserInfo:(id)sender {
    
    [[LoginWith_Google sharedInstance] googlePlusUserInfo:self];
}

- (IBAction)fetchFriends:(id)sender {
    [[LoginWith_Google sharedInstance] googlePlusUserFriendList:self];
}

- (IBAction)postOnG:(id)sender {
    
    [[LoginWith_Google sharedInstance] postOnGooglePlus:@"Hello Testing" urlLocation:@""clientID:kClientId];
}

- (IBAction)backClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma -mark GooglePlus Delegate
-(void)google_userInfo:(NSMutableDictionary *)info
{
    NSLog(@"user info: %@",info);
}

-(void)google_user_friend_list:(NSArray *)list
{
    NSLog(@"friendList: %@",list);
}

-(void)google_gotoNextScreen
{
    ProfileViewController *moveTO = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    moveTO.fromTwitter = NO;
    moveTO.fromFB = NO;
    [self.navigationController pushViewController:moveTO animated:YES];
}
@end
