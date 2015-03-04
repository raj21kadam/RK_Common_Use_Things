//
//  Twitter_Login.h
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 18/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Twitter/Twitter.h>
#import <Accounts/Accounts.h>
@protocol twitterDelegate <NSObject>
@required
-(void)twitter_userInfo:(NSMutableDictionary*)info;
@optional
-(void)twitter_user_completeInfo:(NSDictionary*)info;
-(void)twitter_user_friend_list:(NSArray*)list;
-(void)user_timeLine_posts:(NSArray*)posts;
@end

@interface Twitter_Login : NSObject<UIAlertViewDelegate>
{
    
}
// TWitter API LIST
//https://dev.twitter.com/rest/reference/get/followers/list
@property(nonatomic,strong)id <twitterDelegate> delegate;
@property (nonatomic, strong) ACAccountStore*accountStore;
@property (nonatomic, strong) ACAccountStore *account;
+(id)sharedInstance;

-(void)twitter_fetch_userInfo:(id<twitterDelegate>)delegate Twitter_name:(NSString*)twittername;

// It will authenticate user with twitter
// Parameter:twitterDelegate
// use eg:[[LoginWith_Google sharedInstance] doLogin:self];
// Requirments: Add twitterDelegate and implement -(void)userInfo:(NSMutableDictionary*)info;
// User must be logged in to twitter from Device app
-(void)doLogin:(id<twitterDelegate>)delegate;

// It will Post user message on twitter
// Parameter:
// 1. viewController: user's current view i.e self
// 2. msg: post message
// use eg:[[LoginWith_Google sharedInstance] postOnTwitter:self message:@"This is testing from my Twitter library."];
// Requirments:
// 1. User must be logged in to twitter from Device app
-(void)postOnTwitter:(UIViewController*)viewController message:(NSString*)msg;

// It will Post user message with given Image and redirect URL on twitter
// Parameter:
// 1. viewController: user's current view i.e self
// 2. msg: post message
// 3. image: Image to share on twitter
// 4. urlString: redirect url - where to go after clicking on your twitter post
// use eg:[[LoginWith_Google sharedInstance] postOnTwitter:self message:@"This is testing from my Twitter library." withimage:[UIImage imageNamed:@"dummy.png"] redirectURL:@""];
// Requirments:
// 1. User must be logged in to twitter from Device app
-(void)postOnTwitter:(UIViewController*)viewController message:(NSString*)msg withimage:(UIImage*)image redirectURL:(NSString*)urlString;

// It gives users twitter friend List
// Parameter: twitterDelegate
// once it retrives the user friend list . It will call -(void)user_friend_list:(NSArray*)list
// use eg: [[Twitter_Login sharedInstance] twitterFriendList:self];
// Requirments: Add twitterDelegate and implement optional method -(void)user_friend_list:(NSArray*)list;
-(void)twitterFriendList:(id<twitterDelegate>)delegate;

// It gives users or friends timeline posts List
// Parameter: twitterDelegate
// 2. user_name: twitter account user name
// once it retrives the user friend list . It will call -(void)user_timeLine_posts:(NSArray*)posts
// Default we fetch 20 posts
// use eg: [[Twitter_Login sharedInstance] fetchUserTimeline:self user_screen_name:@"Raj21kadamRaj"];
// Requirments: Add twitterDelegate and implement optional method -(void)user_timeLine_posts:(NSArray*)posts;
-(void)fetchUserTimeline:(id<twitterDelegate>)delegate user_screen_name:(NSString*)user_name;

// It gives users or friends timeline posts List
// Parameter: twitterDelegate
// 2. user_name: twitter account user name
// 3. count: fetch post count
// once it retrives the user friend list . It will call -(void)user_timeLine_posts:(NSArray*)posts
// use eg: [[Twitter_Login sharedInstance] fetchUserTimeline:self user_screen_name:@"Raj21kadamRaj" post_count:@"30"];
// Requirments: Add twitterDelegate and implement optional method -(void)user_timeLine_posts:(NSArray*)posts;
-(void)fetchUserTimeline:(id<twitterDelegate>)delegate user_screen_name:(NSString*)user_name post_count:(NSString*)count;
@end
