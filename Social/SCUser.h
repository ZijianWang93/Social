//
//  AppDelegate.h
//  Social
//
//  Created by Zijian Wang on 2017/8/20.
//  Copyright © 2017年 Zijian Wang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SCUser : NSObject

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *password;

+ (BOOL)isUserLogin;
+ (void)userLogInSuccess;
+ (NSString *)defaultUserName;
+ (void)saveDefaultUserName:(NSString *)username;

@end
