//
//  SCSignInViewController.m
//  Social
//
//  Created by Zijian Wang on 2017/9/8.
//  Copyright © 2017年 Zijian Wang. All rights reserved.
//

#import "SCSignInViewController.h"
#import "SCUser.h"


@interface SCSignInViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation SCSignInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)userLogin
{
    SCUser *user = [SCUser new];
    user.userName = self.nameField.text;
    user.password = self.passwordField.text;
    // TODO move user data to server
    [SCUser userLogInSuccess];
    [SCUser saveDefaultUserName:user.userName];
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UI

- (void)setupUI
{
    self.title = NSLocalizedString(@"Sign in", nil);
    [self.signInButton addTarget:self action:@selector(userLogin) forControlEvents:UIControlEventTouchUpInside];
    self.signInButton.layer.contentsScale = 5;
    self.signInButton.backgroundColor = [UIColor colorWithRed:83.0 / 255.0 green:200.0 / 255.0 blue:118.0 / 255.0 alpha:1.0];
    [self.signInButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.nameField.delegate = self;
    self.passwordField.delegate = self;
}

@end
