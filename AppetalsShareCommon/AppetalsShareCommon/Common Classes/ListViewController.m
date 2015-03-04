//
//  ListViewController.m
//  AppetalsShareCommon
//
//  Created by Raj Kadam on 25/02/15.
//  Copyright (c) 2015 Appetals. All rights reserved.
//

#import "ListViewController.h"
#import "FriendsTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+WebCache.h"

@interface ListViewController ()
{
    
}
@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [_my_tableView registerNib:[UINib nibWithNibName:@"FriendsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"FriendsTableViewCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    if (_fromTwitter) {
        if (_isPosts) {
            _header_lebel.text = @"Twitter Posts";
        }else
        _header_lebel.text = @"Twitter Friends";
        [_my_tableView reloadData];
    }else{
        _header_lebel.text = @"Google Plus Friends";
        [_my_tableView reloadData];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    //number of rows in section
    
    return [_table_contentArray count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FriendsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FriendsTableViewCell" forIndexPath:indexPath];
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
-(void) configureCell:(FriendsTableViewCell*)cell atIndexPath:(NSIndexPath*) indexpath{
    cell.backgroundColor = [UIColor clearColor];
    
    
    if(_fromTwitter){
        NSDictionary*oneRecord = [_table_contentArray objectAtIndex:indexpath.row];
        if (_isPosts) {
            NSString*profileImagePath = [oneRecord valueForKey:@"profile_image_url"];
            if (profileImagePath.length>0) {
                [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",profileImagePath]]placeholderImage:[UIImage imageNamed:@"dummyImage"]options:SDWebImageRefreshCached];
            }else{
                cell.profileImage.image = [UIImage imageNamed:@"dummyImage"];
            }
            
            cell.name_label.text = [NSString stringWithFormat:@"%@",[oneRecord valueForKey:@"text"]];
            //cell.location_label.text = [NSString stringWithFormat:@"%@",[oneRecord valueForKey:@"location"]];
        }else{
        NSString*profileImagePath = [oneRecord valueForKey:@"profile_image_url"];
        if (profileImagePath.length>0) {
            [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",profileImagePath]]placeholderImage:[UIImage imageNamed:@"dummyImage"]options:SDWebImageRefreshCached];
        }else{
            cell.profileImage.image = [UIImage imageNamed:@"dummyImage"];
        }
        
        cell.name_label.text = [NSString stringWithFormat:@"%@",[oneRecord valueForKey:@"name"]];
        cell.location_label.text = [NSString stringWithFormat:@"%@",[oneRecord valueForKey:@"location"]];
        }
    }else{
     GTLPlusPerson *person = [_table_contentArray objectAtIndex:indexpath.row];
        
        NSString*profileImagePath = person.image.url;
        if (profileImagePath.length>0) {
            [cell.profileImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",profileImagePath]]placeholderImage:[UIImage imageNamed:@"dummyImage"]options:SDWebImageRefreshCached];
        }else{
            cell.profileImage.image = [UIImage imageNamed:@"dummyImage"];
        }
        
        cell.name_label.text = person.displayName;
        //cell.location_label.text = [NSString stringWithFormat:@"%@",[oneRecord valueForKey:@"location"]];
    }
    
}


- (IBAction)backClicked:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
