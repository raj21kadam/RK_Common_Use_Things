//
//  LoginWith_Google_VC.m
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 18/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import "LoginWith_Google.h"
#import "GPConstantsClass.h"

@implementation LoginWith_Google
{
    BOOL flag;
}

+(id) sharedInstance {
    static LoginWith_Google *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^ {
        sharedInstace = [[self alloc] init];
    });
    return sharedInstace;
}

- (id)init {
    if (self = [super init]) {
        
    }
    return self;
}


#pragma -mark gogle+ Login
-(void)doLoginWithGooglePlus:(id<googleDelegate>)delegate googleClientId:(NSString*)kClientId;{
    
    _delegate = delegate;
    flag = NO;
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.delegate = self;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin,kGTLAuthScopePlusUserinfoProfile,nil];
    signIn.actions = [NSArray arrayWithObjects:@"http://schemas.google.com/ListenActivity",nil];
    [signIn authenticate];
}


#pragma  - mark GooglePlus Delegate
- (void)finishedWithAuth:(GTMOAuth2Authentication *)auth
                   error:(NSError *)error {
    if (error) {
        
        NSLog(@"Error :%@",error);
        
        return;
    }
    if (!flag) {
        NSLog(@"Email_id: %@",[GPPSignIn sharedInstance].userEmail);
        NSLog(@"access Token: %@",[GPPSignIn sharedInstance].idToken);
        [_delegate google_gotoNextScreen];
    }
   
    
}

- (void)didDisconnectWithError:(NSError *)error {
    if (error) {
        
        NSLog(@"Error :%@",error);
        
    } else {
        
        NSLog(@"Error :%@",error);
        
    }
    
}

#pragma -mark fetch user Info
-(void)googlePlusUserInfo:(id<googleDelegate>)delegate
{
    _delegate = delegate;
    
    if ([GPPSignIn sharedInstance].authentication == nil) {
        
        [self showAlertMessage:@"Login" message:@"Please Do Login first."];
        return;
    }
    
    NSMutableDictionary*request = [[NSMutableDictionary alloc] init];
    [request setObject:[NSString stringWithFormat:@"%@",[GPPSignIn sharedInstance].userEmail] forKey:@"email_id"];
    [request setObject:[NSString stringWithFormat:@"%@",[GPPSignIn sharedInstance].idToken] forKey:@"access_token"];
    
    
    // The googlePlusUser member will be populated only if the appropriate
    // scope is set when signing in.
    
    
    // 1. Create a |GTLServicePlus| instance to send a request to Google+.
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init] ;
    plusService.retryEnabled = YES;
    
    GTLQueryPlus *query = [GTLQueryPlus queryForPeopleGetWithUserId:@"me"];
    
    // 2. Set a valid |GTMOAuth2Authentication| object as the authorizer.
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    
    // 3. Use the "v1" version of the Google+ API.*
    plusService.apiVersion = @"v1";
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPerson *person,
                                NSError *error) {
                if (error) {
                    //Handle Error
                    
                    return;
                } else {
//                    NSLog(@"person %@",person);
//                    NSLog(@"Email= %@", [GPPSignIn sharedInstance].authentication.userEmail);
//                    NSLog(@"GoogleID=%@", person.identifier);
//                    NSLog(@"User Name=%@", [person.name.givenName stringByAppendingFormat:@" %@", person.name.familyName]);
//                    NSLog(@"Gender=%@", person.gender);
                    [request setObject:[NSString stringWithFormat:@"%@",person.displayName] forKey:@"display_name"];
                    [request setObject:[NSString stringWithFormat:@"%@",person.image.url] forKey:@"profile_pic"];
                    [request setObject:[NSString stringWithFormat:@"%@",person.gender] forKey:@"gender"];
                    
                    
                    
                    [request setObject:person.identifier forKey:@"app_scope_id"];
                    
                    [_delegate google_userInfo:request];
                    
                     //[[NSNotificationCenter defaultCenter] postNotificationName:kGPUserInfo object:self userInfo:request];
                    
                    //[NSThread detachNewThreadSelector:@selector(hideLoader) toTarget:self withObject:nil];
                }
            }];
    
    
}

#pragma -mark Fetch user Friends List
-(void)googlePlusUserFriendList:(id<googleDelegate>)delegate
{
    
    _delegate = delegate;
    
    if ([GPPSignIn sharedInstance].authentication == nil) {
        
        [self showAlertMessage:@"Login" message:@"Please Do Login first."];
        return;
    }
    
    GTLServicePlus* plusService = [[GTLServicePlus alloc] init];
    plusService.retryEnabled = YES;
    [plusService setAuthorizer:[GPPSignIn sharedInstance].authentication];
    
    
    GTLQueryPlus *query =
    [GTLQueryPlus queryForPeopleListWithUserId:@"me"
                                    collection:kGTLPlusCollectionVisible];
    [plusService executeQuery:query
            completionHandler:^(GTLServiceTicket *ticket,
                                GTLPlusPeopleFeed *peopleFeed,
                                NSError *error) {
                if (error) {
                    GTMLoggerError(@"Error: %@", error);
                } else {
                    // Get an array of people from GTLPlusPeopleFeed
                    NSArray* peopleList = peopleFeed.items;
                    [_delegate google_user_friend_list:peopleList];
                    //NSLog(@"List:%@",peopleList);
                    //[[NSNotificationCenter defaultCenter] postNotificationName:kGPFriendList object:peopleList];
                    
                }
            }];
    
    
}

#pragma -mark post on google
-(void)shareLoginWithGooglePlus:(NSString*)kClientId;{
    
    flag = YES;
    GPPSignIn *signIn = [GPPSignIn sharedInstance];
    signIn.delegate = self;
    signIn.shouldFetchGoogleUserEmail = YES;
    signIn.clientID = kClientId;
    signIn.scopes = [NSArray arrayWithObjects:kGTLAuthScopePlusLogin,kGTLAuthScopePlusUserinfoProfile,nil];
    signIn.actions = [NSArray arrayWithObjects:@"http://schemas.google.com/ListenActivity",nil];
    [signIn authenticate];
}


-(void)postOnGooglePlus:(NSString*)message urlLocation:(NSString*)urlstring clientID:(NSString*)kCLientID
{
    [self shareLoginWithGooglePlus:kCLientID];
    //[self shareLoginWithGooglePlus:YES googleClientId:kCLientID];
    
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    
    [shareBuilder setURLToShare:[NSURL URLWithString:urlstring]];
    
    [shareBuilder setPrefillText:message];
    
    
    [shareBuilder open];
}

#pragma -mark post on google with deeplinking
-(void)postOnGooglePlus:(NSString*)message urlLocation:(NSString*)urlstring deepLinkId:(NSString*)linkId    clientID:(NSString*)kCLientID
{
    [self shareLoginWithGooglePlus:kCLientID];
    //[self shareLoginWithGooglePlus:YES googleClientId:kCLientID];
    
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    
    [shareBuilder setURLToShare:[NSURL URLWithString:urlstring]];
    
    [shareBuilder setPrefillText:message];
    
    [shareBuilder setContentDeepLinkID:[NSString stringWithFormat:@"rest=%@",linkId]];//1234567
    
    [shareBuilder open];
}

#pragma -mark post on google with deeplinking
-(void)postOnGooglePlus:(NSString*)message urlLocation:(NSString*)urlstring deepLinkId:(NSString*)linkId buttonTitle:(NSString*)buttonTitle deepLinkURL:(NSString*)deepLinkURL clientID:(NSString*)kCLientID
{
    [self shareLoginWithGooglePlus:kCLientID];
    //[self shareLoginWithGooglePlus:YES googleClientId:kCLientID];
    
    id<GPPNativeShareBuilder> shareBuilder = [[GPPShare sharedInstance] nativeShareDialog];
    
    [shareBuilder setURLToShare:[NSURL URLWithString:urlstring]];
    
    [shareBuilder setPrefillText:message];
    
    [shareBuilder setContentDeepLinkID:[NSString stringWithFormat:@"rest=%@",linkId]];//1234567
    
    [shareBuilder setCallToActionButtonWithLabel:buttonTitle URL:[NSURL URLWithString:deepLinkURL] deepLinkID:[NSString stringWithFormat:@"rsvp==%@",linkId]];//@"https://www.example.com/reservation/4815162342/"
    
    [shareBuilder open];
}





#pragma -mark AlertView
-(void)showAlertMessage:(NSString*)title message:(NSString*)msg
{
    UIAlertView*alert = [[UIAlertView alloc] initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
}


@end
