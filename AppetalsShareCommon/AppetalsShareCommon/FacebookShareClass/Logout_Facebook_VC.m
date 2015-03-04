//
//  Logout_Facebook_VC.m
//  AppetalsShareCommon
//
//  Created by Appetals on 2/12/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import "Logout_Facebook_VC.h"
#import "LoginWithFacebook.h"
#import "FBConstantsClass.h"
@interface Logout_Facebook_VC ()

@end

@implementation Logout_Facebook_VC

- (void)viewDidLoad {
    [super viewDidLoad];

}
-(void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(facebookLogOutSuccesfully) name:kFBLoggedOut object:nil];
}

-(void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)facebookLogOutSuccesfully {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(IBAction)btnLogout:(id)sender {
    
}
@end
