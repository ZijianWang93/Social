//
//  SCPostDetailViewController.m
//  Social
//
//  Created by Zijian Wang on 2017/9/8.
//  Copyright © 2017年 Zijian Wang. All rights reserved.
//

#import "SCPostDetailViewController.h"
#import "SCPost.h"

@interface SCPostDetailViewController ()

@property (weak, nonatomic) IBOutlet UITextView *postView;
@property (strong, nonatomic) SCPost *post;

@end

@implementation SCPostDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    if (self.postView) {
        self.postView.text = self.post.message;
    }
}

- (void)setupUI
{
    self.title = NSLocalizedString(@"Detail", nil);
}

- (void)viewDidLayoutSubviews {
    [self.postView setContentOffset:CGPointZero animated:NO];
}

- (void)loadDetailViewWithPost:(SCPost *)post
{
    self.post = post;
}

@end
