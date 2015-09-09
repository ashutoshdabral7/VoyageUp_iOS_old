//
//  ContactsListViewController.h
//  VoyageUp
//
//  Created by Deepak on 11/05/15.
//  Copyright (c) 2015 Deepak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ContactListCell.h"
#import "LoginViewController.h"
#import "GMDCircleLoader.h"
@interface ContactsListViewController : UIViewController<loginSuccessDelegate>
{
    NSArray *userListArray;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *view_emptyList;
-(IBAction)reloadList:(id)sender;
@end
