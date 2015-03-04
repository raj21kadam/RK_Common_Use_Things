//
//  Appetals_Share_VC.m
//  AppetalsShareCommon
//
//  Created by Appetals on 2/10/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import "Appetals_Share_VC.h"
#import "Appetals_Share_CellTableViewCell.h"
#import "FacebookShareClass/LoginWith_Facebook_VC.h"
#import "TwitterShareClass/Twitter_Login_VC.h"
#import "GoogleShareClass/LoginWith_Google_VC.h"
@interface Appetals_Share_VC ()
{
    NSMutableArray *arrShareList;
}
@end

@implementation Appetals_Share_VC

- (void)viewDidLoad {
    arrShareList = [[NSMutableArray alloc] initWithObjects:@"Login With Facebook",@"Login With Google", @"Login With Twitter", @"Share on Social Media",nil];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrShareList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Appetals_Share_CellTableViewCell";
    Appetals_Share_CellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Appetals_Share_CellTableViewCell"];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"Appetals_Share_CellTableViewCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    cell.lblTitle.text = [arrShareList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.row == 0) {
        LoginWith_Facebook_VC *moveTO = [[LoginWith_Facebook_VC alloc] initWithNibName:@"LoginWith_Facebook_VC" bundle:nil];
        [self.navigationController pushViewController:moveTO animated:YES];
    }else if (indexPath.row == 1) {
        LoginWith_Google_VC *moveTO = [[LoginWith_Google_VC alloc] initWithNibName:@"LoginWith_Google_VC" bundle:nil];
        [self.navigationController pushViewController:moveTO animated:YES];
    }else if (indexPath.row == 2) {
        Twitter_Login_VC *moveTO = [[Twitter_Login_VC alloc] initWithNibName:@"Twitter_Login_VC" bundle:nil];
        [self.navigationController pushViewController:moveTO animated:YES];
    }
    else if (indexPath.row == 3) {
        NSString *string = @"Testing....";
        NSURL *url = [NSURL URLWithString:@"www.google.com"];
        
        UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[string, url]
                                          applicationActivities:nil];
        activityViewController.excludedActivityTypes = @[UIActivityTypePostToFacebook];
        [self.navigationController presentViewController:activityViewController
                                                animated:YES
                                              completion:^{
                                                  
                                              }];
    }
}

-(IBAction)btnShareClick:(id)sender {
    
}

@end
