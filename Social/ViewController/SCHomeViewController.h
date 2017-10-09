//
//  SCHomeViewController.h
//  Social
//
//  Created by Zijian Wang on 2017/8/30.
//  Copyright © 2017年 Zijian Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@class SCPost;

@interface SCHomeViewController : UIViewController

- (void)loadResultPageWithPosts:(NSArray <SCPost *>*)posts;

@end
