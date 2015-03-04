//
//  LoginWithFacebook.h
//  AppetalsShareCommon
//
//  Created by Appetals on 2/12/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@protocol FacebookDelegate <NSObject>

-(void)facebook_user_info:(NSMutableDictionary*)info;
@end

@interface LoginWithFacebook : NSObject {

}

@property (nonatomic,weak)id<FacebookDelegate>delegate;
+(id)sharedInstance;
-(void)doLoginWithFaceBook:(id<FacebookDelegate>)delegate;
-(void)openWebDialog:(NSMutableDictionary*)param;
@end
