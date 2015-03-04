//
//  LoginWith_Facebook_VC.m
//  AppetalsShareCommon
//
//  Created by Appetals on 2/11/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import "LoginWith_Facebook_VC.h"
#import "FBConstantsClass.h"
#import "Logout_Facebook_VC.h"
#import "ProfileViewController.h"
@interface LoginWith_Facebook_VC ()

@end

@implementation LoginWith_Facebook_VC

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(facebookLoginSuccesfully)
                                                 name:kFBLoggedIn
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)facebookLoginSuccesfully {
    Logout_Facebook_VC *moteTO = [[Logout_Facebook_VC alloc] initWithNibName:@"Logout_Facebook_VC" bundle:nil];
    [self.navigationController pushViewController:moteTO animated:YES];
}

-(IBAction)doLogin:(id)sender {
    [[LoginWithFacebook sharedInstance] doLoginWithFaceBook:self];
}

- (IBAction)shareclicked:(id)sender {
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Sharing Tutorial", @"name",
                                   @"Build great social apps and get more installs.", @"caption",
                                   @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
                                   @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                   nil];
     [[LoginWithFacebook sharedInstance] openWebDialog:params];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)backClicked:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma facebook delegate
-(void)facebook_user_info:(NSMutableDictionary *)info
{
    NSLog(@"FB user info: %@",info);
    ProfileViewController *moveTO = [[ProfileViewController alloc] initWithNibName:@"ProfileViewController" bundle:nil];
    moveTO.fromTwitter = NO;
     moveTO.userInfo = info;
    moveTO.fromFB = YES;
    [self.navigationController pushViewController:moveTO animated:YES];
    
}

@end
