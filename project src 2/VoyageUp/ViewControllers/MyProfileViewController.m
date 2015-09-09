//
//  MyProfileViewController.m
//  VoyageUp
//
//  Created by Deepak on 26/04/15.
//  Copyright (c) 2015 Deepak. All rights reserved.
//

#import "MyProfileViewController.h"
#import "Constants.h"

@interface MyProfileViewController ()

@end

@implementation MyProfileViewController
@synthesize tap,profileDetails;
- (void)viewDidLoad {
    [super viewDidLoad];
    //------------****** navigation bar settings ---------
    self.navigationController.navigationBar.tintColor = COLOR_MAIN_BG_DARK;
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:
     @{NSForegroundColorAttributeName:COLOR_MAIN_BG_DARK,
       NSFontAttributeName:BARBUTTON_FONT
       }
     forState:UIControlStateNormal];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.titleView = [helper SetNavTitle:SCREEN_MY_PROFILE];
    //------------****** ---------
    
    tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    
    _imgPicker = [[UIImagePickerController alloc] init];
    _library = [[ALAssetsLibrary alloc] init];
    
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = CGRectMake(0, 0, self.top_view.frame.size.width, self.top_view.frame.size.height);
    
    photoEdit=false;
    newPhoto=false;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    //[self.scrollView setContentSize:CGSizeMake(0, (isBeginEdited) ? ((IS_IPHONE_4) ? 0 : 920) : ((IS_IPHONE_4) ? 0 : 920))];
    [self.scrollView setContentSize:CGSizeMake([UIScreen mainScreen].bounds.size.width, 800)];
}
-(void)viewWillAppear:(BOOL)animated{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (appDelegate.firstTime)
    {
        appDelegate.firstTime=false;
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if (profileDetails.admin) {
        profileDetails = [ProfileDetails getProfileDetails];
        //if (myConnectionArray.count<1)
        [self getMyConnections];
        // else
        // [self setConnections:myConnectionArray];
    }
    else
    {
           }
    
    
    self.navigationItem.titleView = [helper SetNavTitle:profileDetails.FullName];
    
    [self setFields];
    [self setView];
    isBeginEdited = NO;
    self.userImageView1.layer.cornerRadius = 66.0;
    self.userImageView1.layer.masksToBounds = YES;
    self.userImageView1.layer.borderColor =(__bridge CGColorRef)(COLOR_MAIN_BG);// [UIColor colorWithRed:236.0/255.0 green:240.0/255.0 blue:241.0/255.0 alpha:1.0].CGColor;
    self.userImageView1.layer.borderWidth = 2.0f;
    myConnectionArray= [[DataStoreManager sharedDataStoreManager]getAllmyConnectionsArray];
    self.btn_chat.layer.cornerRadius = 30.0;
    self.btn_chat.layer.masksToBounds = YES;
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    //    NSString *restorationId = self.restorationIdentifier;
    //    if ([restorationId isEqualToString:@"userprofile"]) {
    //[self.navigationController popToRootViewControllerAnimated:YES];
    //    }
    
    
}
//- (void)scrollViewDidScroll:(UIScrollView *)sender { // --- disable horizontal scrolling
////    if (sender.contentOffset.x != 0) {
////        CGPoint offset = sender.contentOffset;
////        offset.x = 0;
////        sender.contentOffset = offset;
////    }
//}
#pragma mark - Internal Methods
-(void)setView{
    
    
    [_txt_Firstname leftViewRectForBounds];
    [_txt_Lastname leftViewRectForBounds];
    //[self.txt_dob leftViewRectForBounds];
    // [_txt_Country leftViewRectForBounds];
    
    self.btn_ChangePassword.clipsToBounds = YES;
    self.btn_ChangePassword.layer.cornerRadius = 3.0f;
    [[self.btn_ChangePassword layer] setBorderWidth:1.0f];
    [[self.btn_ChangePassword layer] setBorderColor:[UIColor colorWithRed:0.0/255.0 green:112.0/255.0 blue:162.0/255.0 alpha:1.0].CGColor];
    
}
-(void)setFields{
    if (!profileDetails)
        profileDetails = [ProfileDetails getProfileDetails];
    _txt_Firstname.text = profileDetails.FirstName;
    _txt_Lastname.text = profileDetails.LastName;
    _txt_Country.text = profileDetails.Country;
    _txt_dob.text = profileDetails.dob;
    if(!newPhoto){
        if (profileDetails.ProfilePhoto.length>0)
            [self.userImageView1 setImageWithURL:[helper getImageUrl:profileDetails.ProfilePhoto]];
    }
    if ([profileDetails.LoginType isEqualToString:@"F"]) {
        self.btn_ChangePassword.enabled=false;
        self.btn_ChangePassword.hidden=true;
    }
    newPhoto=false;
}

#pragma api call

- (void)Update{
    
    
    UIImage *orientaionFixedImage=[self.userImageView1.image fixOrientation]; // ----- orientaion issue ----- fix
    NSData *imgData = UIImageJPEGRepresentation(orientaionFixedImage, 0);
    
    NSDictionary *postobject = [NSDictionary dictionaryWithObjectsAndKeys:
                                _txt_Firstname.text,POST_FIRSTNAME,
                                _txt_Lastname.text,POST_LASTNAME,
                                _txt_dob.text,POST_DOB,
                                _txt_Country.text,POST_COUNTRY,
                                @"M",POST_GENDER,
                                nil];
    [SVProgressHUD showWithStatus:@"Updating" maskType:SVProgressHUDMaskTypeClear];
    [[VoyageUpAPIManager sharedManager] ProfileUpdate:postobject AndPhoto:orientaionFixedImage WithCompletionblock:^(NSDictionary*result,NSError *error)
     {
         @try {
             
             if (result != nil)
             {
                 NSString *title = [result objectForKey:@"title"];
                 NSString *message = [result objectForKey:@"message"];
                 [helper ShowSuccessAlert:self withTitle:title withMessage:message];
                 if ([[result valueForKeyPath:@"status"] isEqualToString:@"success"])
                 {
                     [[ProfileDetails getProfileDetails] saveUserDetails:[result objectForKey:@"result"]];
                     
                 }
                 else
                 {
                     
                 }
                 [SVProgressHUD dismiss];
             }
             
             else
             {
                 [SVProgressHUD dismiss];
             }
             
         }
         @catch (NSException *exception) {
             
         }
         
     }];
    
    
}

#pragma mark validation

#pragma mark - Button Click Methods
- (IBAction)UpdateProfile:(id)sender
{
    [self.view endEditing:YES];
    
    [self Update];
    
}


- (IBAction)CountryPicker:(id)sender
{
    [self.view endEditing:YES];
    EMCCountryPickerController *countryPicker1   = [self.storyboard instantiateViewControllerWithIdentifier:@"EMCCountryPickerController"];
    countryPicker1.showFlags = true;
    countryPicker1.countryDelegate = self;
    countryPicker1.drawFlagBorder = true;
    countryPicker1.flagBorderColor = [UIColor grayColor];
    countryPicker1.flagBorderWidth = 0.5f;
    [self presentViewController:countryPicker1 animated:YES completion:nil];
    
}
- (void)countryController:(id)sender didSelectCountry:(EMCCountry *)chosenCity
{
    self.txt_Country.text = chosenCity.countryName;
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)dismissPickerView:(id)sender
{
    
}
- (void)updateDateField:(id)sender
{
    
    UIDatePicker *picker = (UIDatePicker*)_txt_dob.inputView;
    _txt_dob.text = [self formatDate:picker.date];
}
- (NSString *)formatDate:(NSDate *)date
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
    
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    isBeginEdited = YES;
    //    [self dismissPickerView:nil];
    //    if ((textField.tag>1) ||  IS_IPHONE_4)
    
    if(textField.tag == 5)//&&!IS_IPHONE_4 && )
    {
        //[self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.x+400)];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.x+450)];
        } completion:nil];
        
        
    }
    else
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, textField.frame.origin.x+200)];
        } completion:nil];
        
        
    }
    
    [self.view addGestureRecognizer:tap];
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    isBeginEdited = NO;
    [self.view removeGestureRecognizer:tap];
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder *nextResponder = [textField.superview viewWithTag:nextTag];
    if(textField == _txt_Lastname)
    {
        [self.txt_Country becomeFirstResponder];
        return YES;
        
    }
    
    if (nextResponder)
        [nextResponder becomeFirstResponder];
    
    else
    {
        [textField resignFirstResponder];
        
        return YES;
    }
    
    return YES;
}

- (void)dismissKeyboard {
    isBeginEdited = NO;
    
    [self.view endEditing:YES];
}
-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [self.view addGestureRecognizer:tap];
    if(textView.tag == 4)//&&!IS_IPHONE_4 && )
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, textView.frame.origin.x+550)];
        } completion:nil];
    }
    else
    {
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.scrollView setContentOffset:CGPointMake(0, textView.frame.origin.x+300)];
        } completion:nil];
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.scrollView setContentOffset:CGPointMake(0,0)];
    } completion:nil];
}
#pragma mark profile image- camera and gallery access methods, UIImagePickerControllerDelegate

-(IBAction)chat_Clicked:(id)sender
{
    
}
-(IBAction)addPhoto:(id)sender{
    
    UIButton *clickedButton = (UIButton*)sender;
    profilePhotoNumber=clickedButton.tag;
    
    deleteflag=false;
    imageUpload = [[UIActionSheet alloc]
                   initWithTitle:@"Upload"
                   delegate:self
                   cancelButtonTitle:@"Cancel"
                   destructiveButtonTitle:(nil)
                   otherButtonTitles:@"Take image",@"Choose image", nil];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 3.0 ||
        UIDeviceOrientationIsPortrait([[UIDevice currentDevice] orientation]))
    {
        [imageUpload showInView:self.view];
    } else
    {
        [imageUpload showInView:self.view.window];
    }
    [imageUpload showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if(actionSheet == imageUpload){
        //if (actionSheet.tag==1) {
        
        
        if (buttonIndex == 0)
        {
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypeCamera];
            
        }
        if (buttonIndex == 1)
        {
            [self showImagePickerForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }
        if (buttonIndex == 2 && deleteflag)
        {
            if (callDeleteApi){
                //[self deleteImage];
            }
            else
            {
                [self.userImageView1 setImage:nil];
            }
        }
    }
    else
    {
       
    }
}
- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    _imgPicker.sourceType = sourceType;
    [_imgPicker setAllowsEditing:NO];
    _imgPicker.delegate = self;
    if (_imgPicker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        _imgPicker.showsCameraControls = YES;
    }
    if ( [UIImagePickerController isSourceTypeAvailable:sourceType]) {
        [self presentViewController:_imgPicker animated:YES completion:nil];
    }
    
    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    //Or you can get the image url from AssetsLibrary
    // NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    // [self.userImageView1 setImage:image];
    
    
    
    
    
    [UIView animateWithDuration:0.2f delay:0.1f options:UIViewAnimationOptionCurveEaseIn animations:^{
        
    } completion:^(BOOL finished) {
        
    }];
    [picker dismissViewControllerAnimated:YES completion:^{
        
        [self loadCropView:image];
    }];
}

-(void)finish:(UIImage *)image didCancel:(BOOL)cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
    if(cancel)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        
        
    }
    
    
}

#pragma mark - PECropViewController method and Delegate methods
-(void)loadCropView:(UIImage*)image
{
    PECropViewController *controller = [[PECropViewController alloc] init];
    controller.delegate = self;
    controller.image = image;
    
    
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat length = MIN(width, height);
    controller.imageCropRect = CGRectMake((width - length) / 2,
                                          (height - length) / 2,
                                          length,
                                          length);
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        navigationController.modalPresentationStyle = UIModalPresentationFormSheet;
    }
    
    [self presentViewController:navigationController animated:YES completion:NULL];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage transform:(CGAffineTransform)transform cropRect:(CGRect)cropRect
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
    photoEdit=true;
    [self.userImageView1 setImage:croppedImage];
    
    newPhoto=true;
}

- (void)cropViewControllerDidCancel:(PECropViewController *)controller
{
    [controller dismissViewControllerAnimated:YES completion:NULL];
}
#pragma mark connection types
-(void)getMyConnections
{
    
    
    [[VoyageUpAPIManager sharedManager] GetConnectionList:^(NSDictionary*result,NSError *error) {
        
        NSArray *questionsArrayTemp=[result valueForKeyPath:@"all_connections"];
        NSMutableArray *myConnectionsArray=[result valueForKeyPath:@"my_connections"];
        NSMutableArray *qnArray = [NSMutableArray new];
        for (NSDictionary *pack in questionsArrayTemp)
        {
           
        }
        [[DataStoreManager sharedDataStoreManager] setAllmyConnectionsArrayFrom:myConnectionsArray];
        [[DataStoreManager sharedDataStoreManager] setAllconnectionsArrayFrom:qnArray];
        connectionArray=[[DataStoreManager sharedDataStoreManager]getAllconnectionsArray];
        myConnectionArray=[[DataStoreManager sharedDataStoreManager]getAllmyConnectionsArray];
        myConnectionArray=[helper intToStringArray:myConnectionArray];
        
        
        
    }];
    
    
    
}


#pragma mark check edit or not

#pragma mark - validation


#pragma mark other users

- (IBAction)ShowOptions:(id)sender {
    
    UIActionSheet*  actionSheet;
    actionSheet.tag=2;
    actionSheet= [[UIActionSheet alloc]
                  initWithTitle:nil
                  delegate:self
                  cancelButtonTitle:@"Cancel"
                  destructiveButtonTitle:(nil)
                  otherButtonTitles:@"Chat",@"Invite to Meet",@"Invite for a Coffee", nil];
    
    [actionSheet showInView:self.view];
}
#pragma mark  share my table




@end
