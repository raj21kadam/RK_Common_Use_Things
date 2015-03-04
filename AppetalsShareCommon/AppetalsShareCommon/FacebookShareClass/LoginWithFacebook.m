//
//  LoginWithFacebook.m
//  AppetalsShareCommon
//
//  Created by Appetals on 2/12/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import "LoginWithFacebook.h"
#import "FBConstantsClass.h"



@implementation LoginWithFacebook

+(id) sharedInstance {
    static LoginWithFacebook *sharedInstace = nil;
    static dispatch_once_t onceToken;
    dispatch_once (&onceToken,^ {
        sharedInstace = [[ self alloc] init];
    });
    return sharedInstace;
}

- (id)init {
    if (self = [super init]) {
    
    }
    return self;
}

-(void)doLogoutFromFaceBook {
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        [FBSession.activeSession closeAndClearTokenInformation];
           [[NSNotificationCenter defaultCenter] postNotificationName:kFBLoggedIn object:self];
    }
}
-(void)doLoginWithFaceBook:(id<FacebookDelegate>)delegate {
    _delegate = delegate;
    
    if (FBSession.activeSession.state == FBSessionStateOpen
        || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
        
        [self userInfo];
        
    } else {
        // Open a session showing the user the login UI
        // You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[kFBDefaultPermission,@"email"]
                                           allowLoginUI:YES
                                      completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error) {
             [self sessionStateChanged:session state:state error:error];
         }];
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:kFBLoggedIn object:self];
}

-(void)doLogoutWithFaceBook {
    [[NSNotificationCenter defaultCenter] postNotificationName:kFBLoggedOut object:self];   
}

-(void)checkForStatus {
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile"]
                                           allowLoginUI:NO
                                      completionHandler:^(FBSession *sessison, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // Call this method EACH time the session state changes,
                                          //  NOT just when the session open
                                          [self sessionStateChanged:sessison state:state error:error];
                                      }];
    }
    
}

-(void)userInfo
{
    [[FBRequest requestForMe] startWithCompletionHandler:
     ^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *aUser, NSError *error) {
         if (!error) {
             NSLog(@"User info %@",aUser );
             
             NSMutableDictionary*infoDict = [[NSMutableDictionary alloc] init];
             
             [infoDict setObject:[aUser valueForKey:@"first_name"] forKey:@"first_name"];
             [infoDict setObject:[aUser valueForKey:@"last_name"] forKey:@"last_name"];
             [infoDict setObject:[aUser valueForKey:@"email"] forKey:@"email_id"];
             [infoDict setObject:[aUser valueForKey:@"id"] forKey:@"app_scope_id"];
             [infoDict setObject:[aUser valueForKey:@"name"] forKey:@"dis_name"];
             [infoDict setObject:[aUser valueForKey:@"gender"] forKey:@"gender"];
             NSString*fbID = [aUser valueForKey:@"id"];
             //https://graph.facebook.com/USER_ID/picture?height=200&width=200
             NSString* fbProfileLink = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?height=200&width=200",fbID];
             [infoDict setObject:fbProfileLink forKey:@"profile_link"];
             
             [_delegate facebook_user_info:infoDict];
             
             
             
         }
     }];
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
       // [[NSNotificationCenter defaultCenter] postNotificationName:kFBLoggedIn object:self];
        [self userInfo];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
     
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
          //  [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
               // [self showMessage:alertText withTitle:alertTitle];
                
                // Here we will handle all other errors with a generic error message.
                // We recommend you check our Handling Errors guide for more information
                // https://developers.facebook.com/docs/ios/errors/
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
               // [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        //[self userLoggedOut];
    }
}


-(void)openWebDialog:(NSMutableDictionary*)param
{
    // Put together the dialog parameters
    
    
    // Show the feed dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:param
                                              handler:^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
                                                  if (error) {
                                                      // An error occurred, we need to handle the error
                                                      // See: https://developers.facebook.com/docs/ios/errors
                                                      NSLog(@"Error publishing story: %@", error.description);
                                                  } else {
                                                      if (result == FBWebDialogResultDialogNotCompleted) {
                                                          // User cancelled.
                                                          NSLog(@"User cancelled.");
                                                      } else {
                                                          // Handle the publish feed callback
                                                          NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                                                          
                                                          if (![urlParams valueForKey:@"post_id"]) {
                                                              // User cancelled.
                                                              NSLog(@"User cancelled.");
                                                              
                                                          } else {
                                                              // User clicked the Share button
                                                              NSString *result = [NSString stringWithFormat: @"Posted story, id: %@", [urlParams valueForKey:@"post_id"]];
                                                              NSLog(@"result %@", result);
                                                          }
                                                      }
                                                  }
                                              }];
}

// A function for parsing URL parameters returned by the Feed Dialog.
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}



@end
