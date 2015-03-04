//
//  ListViewController.h
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 25/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleOpenSource/GoogleOpenSource.h>
#import <GooglePlus/GooglePlus.h>

@interface ListViewController : UIViewController
@property (nonatomic,assign) BOOL fromTwitter;
@property (nonatomic,assign) BOOL isPosts;
@property (strong, nonatomic) IBOutlet UILabel *header_lebel;
@property (strong, nonatomic) IBOutlet UITableView *my_tableView;

@property (nonatomic,strong) NSArray*table_contentArray;
- (IBAction)backClicked:(id)sender;


@end
