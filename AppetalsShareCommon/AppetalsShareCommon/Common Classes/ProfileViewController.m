//
//  ProfileViewController.m
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 25/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import "ProfileViewController.h"
#import "GPConstantsClass.h"
#import "KVNProgress.h"
#import "ListViewController.h"
#import "LoginWithFacebook.h"
@interface ProfileViewController ()

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [KVNProgress showWithStatus:@"Loading..."];
    for(UIButton*btn in _allBtns)
    {
        btn.layer.cornerRadius = 5;
        btn.clipsToBounds = YES;
    }
    
    _profileImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    _profileImage.layer.borderWidth = 2;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    if (!_fromTwitter) {
        if (_fromFB) {
            _fetchuserPost_outlet.hidden = YES;
            _lbl_name.text = [_userInfo valueForKey:@"dis_name"];
            _lbl_email.text = [NSString stringWithFormat:@"%@",[_userInfo valueForKey:@"email_id"]];
            _lbl_gender.text = [NSString stringWithFormat:@"%@",[_userInfo valueForKey:@"gender"]];
            
            NSData*imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[_userInfo valueForKey:@"profile_link"]]];
            _profileImage.image = [UIImage imageWithData:imageData];
            [KVNProgress dismiss];
        }else{
        _fetchuserPost_outlet.hidden = YES;
        
        [[LoginWith_Google sharedInstance] googlePlusUserInfo:self];
        }
    }else{
        _fetchuserPost_outlet.hidden = NO;
        NSString*twitterName = [_userInfo valueForKey:@"user_name"];
        [[Twitter_Login sharedInstance] twitter_fetch_userInfo:self Twitter_name:twitterName];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)fetchFriendsClicked:(id)sender {
    if (_fromTwitter) {
         [[Twitter_Login sharedInstance] twitterFriendList:self];
    }else{
         if(_fromFB){
             UIAlertView*alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:@"Not allowed to fetch friends!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
             [alert show];
         }else
         [[LoginWith_Google sharedInstance] googlePlusUserFriendList:self];
    }
}

- (IBAction)postOnWallClicked:(id)sender {
    
    if (_fromTwitter) {
        [[Twitter_Login sharedInstance] postOnTwitter:self message:@"This is testing from my Twitter library." withimage:[UIImage imageNamed:@"dummy.png"] redirectURL:@""];
    }else{
        if(_fromFB){
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           @"Sharing Tutorial", @"name",
                                           @"Build great social apps and get more installs.", @"caption",
                                           @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                           @"https://developers.facebook.com/docs/ios/share/", @"link",
                                           @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                           nil];
            [[LoginWithFacebook sharedInstance] openWebDialog:params];
        }else
         [[LoginWith_Google sharedInstance] postOnGooglePlus:@"Hello Testing" urlLocation:@""clientID:kClientId];
    }
}

- (IBAction)fetchUserPosts:(id)sender {
    if (_fromTwitter) {
         [[Twitter_Login sharedInstance] fetchUserTimeline:self user_screen_name:@"BeingSalmanKhan"];
    }
}
- (IBAction)backClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma -mark GooglePlus Delegate
-(void)google_userInfo:(NSMutableDictionary *)info
{
    NSLog(@"user info: %@",info);
    _lbl_name.text = [info valueForKey:@"display_name"];
    _lbl_email.text = [info valueForKey:@"email_id"];
    _lbl_gender.text = [info valueForKey:@"gender"];
    
    NSData*imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[info valueForKey:@"profile_pic"]]];
    _profileImage.image = [UIImage imageWithData:imageData];
    
    [KVNProgress dismiss];
}

-(void)google_user_friend_list:(NSArray *)list
{
    NSLog(@"friendList: %@",list);
    ListViewController *moveTO = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    moveTO.fromTwitter = NO;
    moveTO.table_contentArray = list;
    //    [self.navigationController pushViewController:moveTO animated:YES];
    [self presentViewController:moveTO animated:YES completion:nil];
}


#pragma -mark Twitter Custom Delegate
-(void)twitter_userInfo:(NSMutableDictionary *)info
{
    NSLog(@"Twitter user Info:%@",info);
    
    [KVNProgress dismiss];
}

-(void)twitter_user_friend_list:(NSArray*)list
{
    NSLog(@"user list:%@",list);
    ListViewController *moveTO = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    moveTO.fromTwitter = YES;
    moveTO.table_contentArray = list;
    moveTO.isPosts = NO;
    //    [self.navigationController pushViewController:moveTO animated:YES];
    [self presentViewController:moveTO animated:YES completion:nil];
}

-(void)user_timeLine_posts:(NSArray*)posts
{
    NSLog(@"user_timeLine_posts:%@",posts);
    ListViewController *moveTO = [[ListViewController alloc] initWithNibName:@"ListViewController" bundle:nil];
    moveTO.fromTwitter = YES;
    moveTO.table_contentArray = posts;
    moveTO.isPosts = YES;
    //    [self.navigationController pushViewController:moveTO animated:YES];
    [self presentViewController:moveTO animated:YES completion:nil];
}

-(void)twitter_user_completeInfo:(NSDictionary*)info
{
    NSLog(@"User complete Info: %@",info);
    _lbl_name.text = [info valueForKey:@"name"];
    _lbl_email.text = [NSString stringWithFormat:@"%@ Friends",[info valueForKey:@"friends_count"]];
    _lbl_gender.text = [NSString stringWithFormat:@"%@ Followes",[info valueForKey:@"followers_count"]];
    
    NSData*imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:[info valueForKey:@"profile_image_url"]]];
    _profileImage.image = [UIImage imageWithData:imageData];
    [KVNProgress dismiss];
}

/*
 data:{"id":3017015522,"id_str":"3017015522","name":"Appetals Test","screen_name":"appetals_social","location":"","profile_location":null,"description":"","url":null,"entities":{"description":{"urls":[]}},"protected":false,"followers_count":3,"friends_count":40,"listed_count":0,"created_at":"Thu Feb 12 05:40:10 +0000 2015","favourites_count":0,"utc_offset":null,"time_zone":null,"geo_enabled":true,"verified":false,"statuses_count":0,"lang":"en","contributors_enabled":false,"is_translator":false,"is_translation_enabled":false,"profile_background_color":"C0DEED","profile_background_image_url":"http:\/\/abs.twimg.com\/images\/themes\/theme1\/bg.png","profile_background_image_url_https":"https:\/\/abs.twimg.com\/images\/themes\/theme1\/bg.png","profile_background_tile":false,"profile_image_url":"http:\/\/abs.twimg.com\/sticky\/default_profile_images\/default_profile_3_normal.png","profile_image_url_https":"https:\/\/abs.twimg.com\/sticky\/default_profile_images\/default_profile_3_normal.png","profile_link_color":"0084B4","profile_sidebar_border_color":"C0DEED","profile_sidebar_fill_color":"DDEEF6","profile_text_color":"333333","profile_use_background_image":true,"default_profile":true,"default_profile_image":true,"following":false,"follow_request_sent":false,"notifications":false,"suspended":false,"needs_phone_verification":false}
 */

@end
