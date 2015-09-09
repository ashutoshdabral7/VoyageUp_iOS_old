//
//  VUMenuViewController.h
//  VoyageUp
//
//  Created by Deepak on 26/04/15.
//  Copyright (c) 2015 Deepak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MenuTableViewCell.h"

@interface VUMenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,loginSuccessDelegate>{
    
    NSArray *menuItems;
    UITextField *txt_shareMytable;
    UITextField *oldpassword,*newpassword,*confirmpassword;
    NSString *oldpass,*newpass,*confirmpass;
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *photoView;
@property (strong, nonatomic) IBOutlet UIImageView *blurImageView;
@property (strong, nonatomic) IBOutlet UIImageView *photoImageView;
- (IBAction)takePhoto:(id)sender;
- (IBAction)editProfile:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *lbl_userName;

@end
