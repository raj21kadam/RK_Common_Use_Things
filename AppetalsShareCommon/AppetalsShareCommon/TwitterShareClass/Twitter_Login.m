//
//  Twitter_Login.m
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 18/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import "Twitter_Login.h"

@implementation Twitter_Login

+(id) sharedInstance {
    static Twitter_Login *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^ {
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}


-(id)init
{
    if (self == [super init]) {
        //return self;
    }
    return self;
}


#pragma -mark Twitter Login through SLComposer

-(void )doLogin:(id<twitterDelegate>)delegate
{
    _delegate = delegate;
    
    __block NSMutableDictionary * tempDict;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        // Create account store, followed by a Twitter account identifer
        //ACAccountStore *account = [[ACAccountStore alloc] init];
        self.accountStore=[[ACAccountStore alloc]init];
        
        ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        // Request access from the user to use their Twitter accounts.
        [self.accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
         {
             // Did user allow us access?
             if (granted == YES)
             {
                 // Populate array with all available Twitter accounts
                 NSArray *arrayOfAccounts = [self.accountStore accountsWithAccountType:accountType];
                 
                 // Populate the tableview
                 if ([arrayOfAccounts count] > 0)
                 {
                     ACAccount *twitterAccount=[arrayOfAccounts objectAtIndex:0];
                     NSLog(@"twitter details :\n%@\n",twitterAccount);
                     tempDict = [[NSMutableDictionary alloc] initWithDictionary:
                                 [twitterAccount dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"properties"]]];
                     NSString *tempUserID = [[tempDict objectForKey:@"properties"] objectForKey:@"user_id"];
                     NSString *tempUserName = twitterAccount.username;
                     
                     NSLog(@"credential %@",[tempDict objectForKey:@"properties"]);
                     
                     NSLog(@"twitter user_id :\n%@\ntwitter user_name :\n%@",tempUserID,tempUserName);
                     //[self fetchTimelineForUser:tempUserID :twitterAccount];
                     //                     [self getTwitterImage];
                     //                     [SLRequest re]
                     
                     NSMutableDictionary*dict = [[NSMutableDictionary alloc] init];
                     [dict setObject:tempUserID forKey:@"user_id"];
                     [dict setObject:tempUserName forKey:@"user_name"];
                     
                     
                     [_delegate twitter_userInfo:dict];
                     
                 }
                 
             }else{
                 UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please check Twitter Settings." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
             }
             
         }];
        
        
        
        
    }
    else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:@"go to setting then loged in a twitter" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
        
        // return [[NSMutableDictionary alloc] init];
    }
    
}

#pragma -mark get the twitter Account
-(void)twitterFriendList:(id<twitterDelegate>)delegate
{
    _delegate = delegate;
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        // Create account store, followed by a Twitter account identifer
        //ACAccountStore *account = [[ACAccountStore alloc] init];
        self.accountStore=[[ACAccountStore alloc]init];
        
        ACAccountType *accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        // Request access from the user to use their Twitter accounts.
        [self.accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
         {
             // Did user allow us access?
             if (granted == YES)
             {
                 // Populate array with all available Twitter accounts
                 NSArray *arrayOfAccounts = [self.accountStore accountsWithAccountType:accountType];
                 
                 // Populate the tableview
                 if ([arrayOfAccounts count] > 0)
                 {
                     ACAccount *twitterAccount=[arrayOfAccounts objectAtIndex:0];
                     
                     [self getTwitterFriendsForAccount:twitterAccount];
                 }
             }else{
                 UIAlertView * alert=[[UIAlertView alloc]initWithTitle:nil message:@"Please check Twitter Settings." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                 [alert show];
             }
         }];
        
        
    }else{
        UIAlertView * alert=[[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Go to setting then loged in a twitter" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Ok", nil];
        [alert show];
        
    }
}

#pragma mark - AlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex==0) {
    }
    else
    {
        [self openSettings];
    }
}

#pragma -mark open Settings

- (void)openSettings
{
    BOOL canOpenSettings = (&UIApplicationOpenSettingsURLString != NULL);
    if (canOpenSettings) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma -mark Fetch user Friend list
-(void)getTwitterFriendsForAccount:(ACAccount*)account {
    // In this case I am creating a dictionary for the account
    // Add the account screen name
    NSMutableDictionary *accountDictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", nil];
    // Add the user id (I needed it in my case, but it's not necessary for doing the requests)
    [accountDictionary setObject:[[[account dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"properties"]] objectForKey:@"properties"] objectForKey:@"user_id"] forKey:@"user_id"];
    // Setup the URL, as you can see it's just Twitter's own API url scheme. In this case we want to receive it in JSON
    NSURL *followingURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/friends/list.json"];//https://api.twitter.com/1.1/friends/list.json
    // Pass in the parameters (basically '.ids.json?screen_name=[screen_name]')
    NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:account.username, @"screen_name", @"200", @"count", nil];
    // Setup the request
    //    TWRequest *twitterRequest = [[TWRequest alloc] initWithURL:followingURL
    //                                                    parameters:parameters
    //                                                 requestMethod:TWRequestMethodGET];
    SLRequest *twitterRequest  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodGET
                                                              URL:followingURL
                                                       parameters:parameters];
    // This is important! Set the account for the request so we can do an authenticated request. Without this you cannot get the followers for private accounts and Twitter may also return an error if you're doing too many requests
    [twitterRequest setAccount:account];
    // Perform the request for Twitter friends
    [twitterRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (error) {
            // deal with any errors - keep in mind, though you may receive a valid response that contains an error, so you may want to look at the response and ensure no 'error:' key is present in the dictionary
        }
        NSError *jsonError = nil;
        // Convert the response into a dictionary
        NSDictionary *twitterFriends = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:&jsonError];
        // Grab the Ids that Twitter returned and add them to the dictionary we created earlier
        //[accountDictionary setObject:[twitterFriends objectForKey:@"ids"] forKey:@"ids"];
        
        NSArray* friemds=[twitterFriends objectForKey:@"users"];
        
        [_delegate twitter_user_friend_list:friemds];
       
    }];
}

#pragma -mark post simple message on twitter 
-(void)postOnTwitter:(UIViewController*)viewController message:(NSString*)msg
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:msg];
        
        //Adding the URL to the facebook post value from iOS
        
        [controller addURL:[NSURL URLWithString:@""]];//http://www.mobile.safilsunny.com
        
        //Adding the Image to the facebook post value from iOS
        
        //[controller addImage:[UIImage imageNamed:@"fb.png"]];
        
        [viewController presentViewController:controller animated:YES completion:Nil];
        
    }
    else{
        NSLog(@"UnAvailable");
    }
}

#pragma -mark post on twitter with custon image an dredirect url
-(void)postOnTwitter:(UIViewController*)viewController message:(NSString*)msg withimage:(UIImage*)image redirectURL:(NSString*)urlString
{
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        
        SLComposeViewControllerCompletionHandler myBlock = ^(SLComposeViewControllerResult result){
            if (result == SLComposeViewControllerResultCancelled) {
                
                NSLog(@"Cancelled");
                
            } else
                
            {
                NSLog(@"Done");
            }
            
            [controller dismissViewControllerAnimated:YES completion:Nil];
        };
        controller.completionHandler =myBlock;
        
        //Adding the Text to the facebook post value from iOS
        [controller setInitialText:msg];
        
        //Adding the URL to the facebook post value from iOS
        
        [controller addURL:[NSURL URLWithString:urlString]];
        
        //Adding the Image to the facebook post value from iOS
        
        [controller addImage:image];
        
        [viewController presentViewController:controller animated:YES completion:Nil];
        
    }
    else{
        NSLog(@"UnAvailable");
    }
}

#pragma -mark fetch user timeline
-(void)fetchUserTimeline:(id<twitterDelegate>)delegate user_screen_name:(NSString*)user_name
{
        _delegate = delegate;
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account
                                      accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        [account requestAccessToAccountsWithType:accountType
                                         options:nil completion:^(BOOL granted, NSError *error)
         {
             if (granted == YES)
             {
                 NSArray *arrayOfAccounts = [account
                                             accountsWithAccountType:accountType];
                 
                 if ([arrayOfAccounts count] > 0)
                 {
                     ACAccount *twitterAccount =
                     [arrayOfAccounts lastObject];
                     // my user id  = 2329888404
                     NSURL *requestURL = [NSURL URLWithString:
                                          @"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                     
                     //NSDictionary *parameters =@{@"screen_name" : @"@techotopia", @"include_rts" : @"0", @"trim_user" : @"1",@"count" : @"20"};
                     
                     NSDictionary* params = @{@"count" : @"20", @"screen_name" : user_name};//@"appetals_social"
                     
                     SLRequest *postRequest = [SLRequest
                                               requestForServiceType:SLServiceTypeTwitter
                                               requestMethod:SLRequestMethodGET
                                               URL:requestURL parameters:params];
                     
                     postRequest.account = twitterAccount;
                     
                     [postRequest performRequestWithHandler:
                      ^(NSData *responseData, NSHTTPURLResponse
                        *urlResponse, NSError *error)
                      {
                          NSArray* feedType = [NSJSONSerialization
                                      JSONObjectWithData:responseData
                                      options:NSJSONReadingMutableLeaves
                                      error:&error];
                          
                          if (feedType.count != 0) {
                              dispatch_async(dispatch_get_main_queue(), ^{
                                  
                                      NSLog(@"Feed Data: %@ ",feedType);
                                  
                                  [_delegate user_timeLine_posts:feedType];
                                  
                              });
                          }
                      }];
                 }
             } else {
                 // Handle failure to get account access
                
                     NSLog(@"Feed  TW fails ");
                
             }
         }];


}

#pragma -mark fetch user timeline with specified number of posts
-(void)fetchUserTimeline:(id<twitterDelegate>)delegate user_screen_name:(NSString*)user_name post_count:(NSString*)count
{
    _delegate = delegate;
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account
                                  accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [account requestAccessToAccountsWithType:accountType
                                     options:nil completion:^(BOOL granted, NSError *error)
     {
         if (granted == YES)
         {
             NSArray *arrayOfAccounts = [account
                                         accountsWithAccountType:accountType];
             
             if ([arrayOfAccounts count] > 0)
             {
                 ACAccount *twitterAccount =
                 [arrayOfAccounts lastObject];
                 // my user id  = 2329888404
                 NSURL *requestURL = [NSURL URLWithString:
                                      @"https://api.twitter.com/1.1/statuses/user_timeline.json"];
                 
                 //NSDictionary *parameters =@{@"screen_name" : @"@techotopia", @"include_rts" : @"0", @"trim_user" : @"1",@"count" : @"20"};
                 
                 NSDictionary* params = @{@"count" : count, @"screen_name" : user_name};//@"appetals_social"
                 
                 SLRequest *postRequest = [SLRequest
                                           requestForServiceType:SLServiceTypeTwitter
                                           requestMethod:SLRequestMethodGET
                                           URL:requestURL parameters:params];
                 
                 postRequest.account = twitterAccount;
                 
                 [postRequest performRequestWithHandler:
                  ^(NSData *responseData, NSHTTPURLResponse
                    *urlResponse, NSError *error)
                  {
                      NSArray* feedType = [NSJSONSerialization
                                           JSONObjectWithData:responseData
                                           options:NSJSONReadingMutableLeaves
                                           error:&error];
                      
                      if (feedType.count != 0) {
                          dispatch_async(dispatch_get_main_queue(), ^{
                              
                              NSLog(@"Feed Data: %@ ",feedType);
                              
                              [_delegate user_timeLine_posts:feedType];
                              
                          });
                      }
                  }];
             }
         } else {
             // Handle failure to get account access
             
             NSLog(@"Feed  TW fails ");
             
         }
     }];
}


-(void)twitter_fetch_userInfo:(id<twitterDelegate>)delegate Twitter_name:(NSString*)twittername
{
    _delegate = delegate;
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com/1.1/users/show.json"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:twittername,@"screen_name",nil];
    
    self.account = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [self.account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSArray *twitterAccounts = [self.account accountsWithAccountType:twitterAccountType];
    
    // Runing on iOS 6
    if (NSClassFromString(@"SLComposeViewController") && [SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        [self.account requestAccessToAccountsWithType:twitterAccountType options:NULL completion:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 
                 SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url                                      parameters:params];
                 
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    
                                    [NSURLConnection sendAsynchronousRequest:request.preparedURLRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response1, NSData *data, NSError *error)
                                     {
                                         dispatch_async(dispatch_get_main_queue(), ^
                                                        {
                                                            if (data)
                                                            {
                                                                //                                                                [self loadData:data];
                                                                
                                                                NSString* newStr = [[NSString alloc] initWithData:data
                                                                                                         encoding:NSUTF8StringEncoding];
                                                                //NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] ;
                                                                
                                                                
                                                                NSLog(@"data:%@",newStr);
                                                                NSError *jsonError;
                                                                NSData *objectData = [newStr dataUsingEncoding:NSUTF8StringEncoding];
                                                                NSDictionary *json = [NSJSONSerialization JSONObjectWithData:objectData
                                                                                                                     options:NSJSONReadingMutableContainers
                                                                                                                       error:&jsonError];
                                                                NSLog(@"Dictionary data:%@",json);
                                                                [_delegate twitter_user_completeInfo:json];
                                                            }
                                                        });
                                     }];
                                });
             }
         }];
    }
    else if (NSClassFromString(@"TWTweetComposeViewController") && [TWTweetComposeViewController canSendTweet]) // Runing on iOS 5
    {
        [self.account requestAccessToAccountsWithType:twitterAccountType withCompletionHandler:^(BOOL granted, NSError *error)
         {
             if (granted)
             {
                 TWRequest *request = [[TWRequest alloc] initWithURL:url parameters:params requestMethod:TWRequestMethodGET];
                 [request setAccount:[twitterAccounts lastObject]];
                 
                 dispatch_async(dispatch_get_main_queue(), ^
                                {
                                    [NSURLConnection sendAsynchronousRequest:request.signedURLRequest queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response1, NSData *data, NSError *error)
                                     {
                                         dispatch_async(dispatch_get_main_queue(), ^
                                                        {
                                                            if (data)
                                                            {
                                                                NSString* newStr = [[NSString alloc] initWithData:data
                                                                                                         encoding:NSUTF8StringEncoding];
                                                                
                                                                
                                                                NSLog(@"data:%@",newStr);                                                           }
                                                        });
                                     }];
                                    
                                    
                                });
             }
         }];
    }

}

@end
