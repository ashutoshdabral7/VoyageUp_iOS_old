//
//  VUChatMessageViewController.m
//  VoyageUp
//
//  Created by Deepak on 16/05/15.
//  Copyright (c) 2015 Deepak. All rights reserved.
//

#import "VUChatMessageViewController.h"

#import "LIMessage.h"


@interface VUChatMessageViewController ()

@end

@implementation VUChatMessageViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // [self prepareChatMessageArray];
    ProfileDetails *profile=[ProfileDetails getProfileDetails];
    myName=profile.FullName;
    myImage=profile.ProfilePhoto;
  UITapGestureRecognizer*  tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.chatListTableView addGestureRecognizer:tap];
    self.msgTextView.layer.borderColor = [UIColor colorWithRed:210.0/255.0 green:210.0/255.0 blue:210.0/255.0 alpha:1.0].CGColor;
    self.msgTextView.layer.borderWidth = 1.0f;
    // Do any additional setup after loading the view.
}
- (void)dismissKeyboard {
    
    [self.view endEditing:YES];
}
- (void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter   defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter   defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
    [repeatTimer invalidate];
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark - ITextView delegate

- (void)textViewDidEndEditing:(UITextView *)textView
{
    
    
}
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
    
    
   }
@end
