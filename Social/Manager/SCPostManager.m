//
//  SCPostManager.m
//  Social
//
//  Created by Zijian Wang on 2017/9/7.
//  Copyright © 2017年 Zijian Wang. All rights reserved.
//

#import "SCPostManager.h"
#import "SCPost.h"
#import "AFNetworking.h"
#import "SCUser.h"
#import "SCLocationManager.h"
#import <MapKit/MapKit.h>

// update if necessary
static NSString * const SCBaseURLString = @"https://temporal-grin-180122.appspot.com";

@implementation SCPostManager

+ (void)createPostWithMessage:(NSString *)message andCompletion:(void(^)(NSError *error))completionBlock
{
    // POST url
    NSString *urlString = [SCBaseURLString stringByAppendingString:@"/post"];
    
    // create sesstion manager
    AFHTTPSessionManager *sessionManager = [AFHTTPSessionManager manager];
    
    // create POST body dictionary
    NSString *userName = [SCUser defaultUserName];
    CLLocation *currentLocation = [[SCLocationManager sharedManager] getUserCurrentLocation];
    NSDictionary *body = @{@"user" : userName,
                           @"message" : message,
                           @"location" : @{@"lat" : @(currentLocation.coordinate.latitude),
                                           @"lon" : @(currentLocation.coordinate.longitude)
                                           }};
    // generate JSON string from NSDictioanry
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:body options:0 error:&error];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    // create and config URL request
    NSMutableURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:urlString parameters:nil error:&error];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[jsonString dataUsingEncoding:NSUTF8StringEncoding]];
    
    // API call with completion block
    [[sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (completionBlock) {
            completionBlock(error);
        }
    }] resume];
}

+ (void)getPostsWithLocation:(CLLocation *)location range:(NSInteger)range andCompletion:(void(^)(NSArray <SCPost *>* posts, NSError *error))completionBlock
{
    // ignore edge case
    if ((location.coordinate.latitude <= 0.001) &&
        (location.coordinate.longitude <= 0.001)) {
        return;
    }
    
    // construct url
    NSString *locationString = [NSString stringWithFormat:@"/search?lat=%@&lon=%@", @(location.coordinate.latitude), @(location.coordinate.longitude)];
    if (range != 0) {
        locationString = [locationString stringByAppendingString:[NSString stringWithFormat:@"&range=%@", @(fabs(range/1000.0))]];
    }
    NSString *urlString = [SCBaseURLString stringByAppendingString:locationString];
    NSLog(@"load posts with url: %@", urlString);
    
    // API call with completion success and failure block
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSMutableArray *result = [NSMutableArray new];
        if (completionBlock && [responseObject isKindOfClass:[NSArray class]]) {
            for (NSDictionary *dict in responseObject) {
                SCPost *post = [[SCPost alloc] initWithDictionary:dict];
                if (post.message) {
                    [result addObject:post];
                }
            }
            completionBlock(result.copy, nil);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (completionBlock) {
            completionBlock(nil, error);
        }
    }];
}

@end
