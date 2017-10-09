//
//  SCHomeTableViewCell.h
//  Social
//
//  Created by Zijian Wang on 2017/8/30.
//  Copyright © 2017年 Zijian Wang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SCPost;

@interface SCHomeTableViewCell : UITableViewCell
- (void)loadCellWithPost:(SCPost *)post;
+ (CGFloat)cellHeight;

@end
