//
//  SCCreatePostViewController.m
//  Social
//
//  Created by Zijian Wang on 2017/9/8.
//  Copyright © 2017年 Zijian Wang. All rights reserved.
//

#import "SCCreatePostViewController.h"
#import "SCPostManager.h"
#import "SCPost.h"

static NSString * const SCPostTextPlaceHolder = @"Enter your post here...";

@interface SCCreatePostViewController () <UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *postTextView;

@end

@implementation SCCreatePostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupUI];
}

- (void)setupUI
{
    self.title = NSLocalizedString(@"Post", nil);
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"POST", nil) style:UIBarButtonItemStyleDone target:self action:@selector(createPost)];
    self.navigationItem.rightBarButtonItem = barButton;
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor colorWithRed:83.0 / 255.0 green:200.0 / 255.0 blue:118.0 / 255.0 alpha:1.0];
    self.postTextView.delegate = self;
    self.postTextView.text = SCPostTextPlaceHolder;
    self.postTextView.textColor = [UIColor lightGrayColor];
}

#pragma mark -- action
- (void)createPost
{
    __weak typeof(self) weakSelf = self;
    [SCPostManager createPostWithMessage:self.postTextView.text andCompletion:^(NSError *error) {
        if (error) {
            NSLog(@"%@", error);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"Please try again later.", nil) preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil) style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:okButton];
            [weakSelf presentViewController:alert animated:YES completion:nil];
        }
        else {
            NSLog(@"Post created");
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if ([weakSelf.delegate respondsToSelector:@selector(didCreatePost)]) {
                [weakSelf.delegate didCreatePost];
            }
        }
    }];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:SCPostTextPlaceHolder]) {
        textView.text = @"";
        textView.textColor = [UIColor darkTextColor];
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length == 0) {
        textView.text = SCPostTextPlaceHolder;
        textView.textColor = [UIColor lightGrayColor];
    }
    [textView resignFirstResponder];
}

@end
