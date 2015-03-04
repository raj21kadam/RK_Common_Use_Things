//
//  Twitter_Login_VC.m
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 18/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import "Twitter_Login_VC.h"
#import "ProfileViewController.h"
#import "KVNProgress.h"
@interface Twitter_Login_VC ()

@end

@implementation Twitter_Login_VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (IBAction)loginClicked:(id)sender {
    [KVNProgress showWithStatus:@"Logging with Twitter..."];
    [[Twitter_Login sharedInstance] doLogin:self];
    
}

- (IBAction)postOnTwitter:(id)sender {
    
    [[Twitter_Login sharedInstance] postOnTwitter:self message:@"This is testing from my Twitter library." withimage:[UIImage imageNamed:@"dummy.png"] redirectURL:@""];
    
}

- (IBAction)fetchFriends:(id)sender {
    [[Twitter_Login sharedInstance] twitterFriendList:self];
}

- (IBAction)backClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)fetchUserTimeline:(id)sender {
    
    [[Twitter_Login sharedInstance] fetchUserTimeline:self user_screen_name:@"BeingSalmanKhan"];
}

#pragma -mark Twitter Custom Delegate
-(void)twitter_userInfo:(NSMutableDictionary *)info
{
    NSLog(@"Twitter user Info:%@",info);
    
    ProfileViewController *moveTO = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    moveTO.fromTwitter = YES;
    moveTO.userInfo = info;
//    [self.navigationController pushViewController:moveTO animated:YES];
    [self presentViewController:moveTO animated:YES completion:nil];
    [KVNProgress dismiss];
}

-(void)twitter_user_friend_list:(NSArray*)list
{
    NSLog(@"user list:%@",list);
}

-(void)user_timeLine_posts:(NSArray*)posts
{
    NSLog(@"user_timeLine_posts:%@",posts);
}

@end
