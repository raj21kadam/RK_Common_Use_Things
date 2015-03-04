//
//  LoginWith_Facebook_VC.h
//  AppetalsShareCommon
//
//  Created by Appetals on 2/11/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import <UIKit/UIKit.h>
//Import LoginWithFacebook.h file
#import "LoginWithFacebook.h"
//Add delegate in og LoginWithFacebook

@interface LoginWith_Facebook_VC : UIViewController<FacebookDelegate> {

}

- (IBAction)backClicked:(id)sender;
@property (nonatomic,retain) IBOutlet UIView *vwFBContainer;
-(IBAction)doLogin:(id)sender;
- (IBAction)shareclicked:(id)sender;

@end
