//
//  SCCreatePostViewController.h
//  Social
//
//  Created by Zijian Wang on 2017/9/8.
//  Copyright © 2017年 Zijian Wang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SCCreatePostViewControllerDelegate <NSObject>

- (void)didCreatePost;

@end
@interface SCCreatePostViewController : UIViewController

@property (nonatomic, weak) id<SCCreatePostViewControllerDelegate> delegate;

@end
