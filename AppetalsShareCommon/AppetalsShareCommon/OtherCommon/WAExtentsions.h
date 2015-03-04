//
//  WAExtentsionss.h
//
//  Created by Abhishek ermin on 07/03/13.
//

#import <UIKit/UIKit.h>
//#import "Constants.h"


@interface UIViewController (WAExtentsions)

-(void)startPushAnimation;
-(void)startPopAnimation;
@end

@interface UIView (WAExtentsions)
- (UIImage*)screenshot;
-(void)addBorder:(float)width radius:(float)radius;
-(void)addDropShadow;
@end

@interface UIImage (WAExtentsions)

- (UIImage *)blurredImage:(CGFloat)blurRate;

@end

@interface NSString (WAExtentsions)
- (BOOL) validateTextOnly;
- (BOOL) validatePhoneNumber;
- (BOOL) validateDigitOnlyl;
- (BOOL) validateEmail;
- (BOOL) validateEmpty;

- (NSString *) md5;
@end

@interface NSDate (WAExtentsions)

-(NSString*)addEventToCalender:(NSString *)titleString;
-(void)deleteEventForID:(NSString*)idString;
-(void)editEventForID:(NSString*)idString;
-(NSDate*)addDay:(int)days;



@end



