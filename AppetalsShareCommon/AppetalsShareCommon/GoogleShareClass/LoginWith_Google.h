//
//  LoginWith_Google_VC.h
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 18/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@protocol googleDelegate <NSObject>
@optional
//please do login first to fetch user info and friends
-(void)google_userInfo:(NSMutableDictionary*)info;
-(void)google_user_friend_list:(NSArray*)list;
-(void)google_gotoNextScreen;

@end

@interface LoginWith_Google : NSObject<GPPSignInDelegate>
@property(nonatomic,strong)id<googleDelegate>delegate;

+(id)sharedInstance;

// It will authenticate user with G+
// Parameter:nil
// use eg: [[LoginWith_Google sharedInstance] doLoginWithGooglePlus:self googleClientId:@"your client id"];
-(void)doLoginWithGooglePlus:(id<googleDelegate>)delegate googleClientId:(NSString*)kClientId;


// It gives users basic info
// Parameter: googleDelegate
// once it receives the user info . it will call -(void)userInfo:(NSMutableDictionary*)info
// use eg: [[LoginWith_Google sharedInstance] googlePlusUserInfo:self];
// Requirments: Add googleDelegate and implement -(void)userInfo:(NSMutableDictionary*)info;
-(void)googlePlusUserInfo:(id<googleDelegate>)delegate;

// It gives users friend List
// Parameter: googleDelegate
// once it retrives the user friend list . it will call -(void)user_friend_list:(NSArray*)list
// use eg: [[LoginWith_Google sharedInstance] googlePlusUserFriendList:self];
// Requirments: Add googleDelegate and implement -(void)user_friend_list:(NSArray*)list;
-(void)googlePlusUserFriendList:(id<googleDelegate>)delegate;

// It opens google The share preview, which includes the title, description, and a thumbnail,
// Parameter: message
// 2 urlLocation:The share preview is generated from the page at the specified URL location.
// use eg: [[LoginWith_Google sharedInstance] postOnGooglePlus:@"your post msg" urlLocation:@"www.google.com" clientID:@"your client id"];
-(void)postOnGooglePlus:(NSString*)message urlLocation:(NSString*)urlstring clientID:(NSString*)kCLientID;

// It opens google The share preview, which includes the title, description, and a thumbnail,
// Parameter: message
// 2. urlLocation:The share preview is generated from the page at the specified URL location.
// 3. deepLinkID:This line passes the string "rest=1234567" to your native application
// if somebody opens the link on a supported mobile device
// use eg: [[LoginWith_Google sharedInstance] postOnGooglePlus:@"your post msg" urlLocation:@"www.google.com" deepLinkId:@"1234567" clientID:@"your client id"];
-(void)postOnGooglePlus:(NSString*)message urlLocation:(NSString*)urlstring deepLinkId:(NSString*)linkId clientID:(NSString*)kCLientID;

// It opens google The share preview, which includes the title, description, and a thumbnail,
// Parameter: message
// 2. The share preview is generated from the page at the specified URL location.
// 3. This line passes the string "rest=1234567" to your native application
// if somebody opens the link on a supported mobile device
// 4.buttonTitle:This method creates a call-to-action button with the label "RSVP".
// 5.deepLinkURL: URL specifies where people will go if they click the button on a platform
// that doesn't support deep linking.
// 6.deepLinkID: specifies the deep-link identifier that is passed to your native
//  application on platforms that do support deep linking
// use eg: [[LoginWith_Google sharedInstance] postOnGooglePlus:@"your post msg" urlLocation:@"www.google.com" deepLinkId:@"1234567" buttonTitle:@"Go" deepLinkURL:@"https://www.example.com/reservation/4815162342/" clientID:@"your client id"];
-(void)postOnGooglePlus:(NSString*)message urlLocation:(NSString*)urlstring deepLinkId:(NSString*)linkId buttonTitle:(NSString*)buttonTitle deepLinkURL:(NSString*)deepLinkURL clientID:(NSString*)kCLientID;
@end
