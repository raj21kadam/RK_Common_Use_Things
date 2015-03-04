//
//  Appetals_Share_VC.h
//  AppetalsShareCommon
//
//  Created by Appetals on 2/10/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Appetals_Share_VC : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) IBOutlet UITableView *tblShare;
-(IBAction)btnShareClick:(id)sender;
@end
