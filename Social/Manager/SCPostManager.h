//
//  SCPostManager.h
//  Social
//
//  Created by Zijian Wang on 2017/9/7.
//  Copyright © 2017年 Zijian Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class SCPost;
@class CLLocation;

@interface SCPostManager : NSObject

/*
 * Create posts with message
 */
+ (void)createPostWithMessage:(NSString *)message andCompletion:(void(^)(NSError *error))completionBlock;

/*
 * load all posts within a givin location and range
 */
+ (void)getPostsWithLocation:(CLLocation *)location range:(NSInteger)range andCompletion:(void(^)(NSArray <SCPost *>* posts, NSError *error))completionBlock;

@end
