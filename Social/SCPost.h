//
//  AppDelegate.h
//  Social
//
//  Created by Zijian Wang on 2017/8/20.
//  Copyright © 2017年 Zijian Wang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CLLocation;

@interface SCPost : NSObject

@property(nonatomic,copy) NSString *message;
@property(nonatomic) NSString *username;
@property (nonatomic)  CLLocation *location;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
