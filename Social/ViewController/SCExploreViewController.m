//
//  SCExploreViewController.m
//  Social
//
//  Created by Zijian Wang on 2017/9/1.
//  Copyright © 2017年 Zijian Wang. All rights reserved.
//

#import "SCExploreViewController.h"
#import <MapKit/MapKit.h>
#import "SCLocationManager.h"
#import "SCPostManager.h"
#import "SCPost.h"
#import "SCHomeViewController.h"
#import "SCPostDetailViewController.h"

static NSString * const SCAnnotationIdentifier = @"post.pin";

@interface SCExploreViewController () <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *reloadButton;
@property (strong, nonatomic) NSArray <SCPost *>* posts;
@property (strong, nonatomic) CLLocation *center;
@property (assign, nonatomic) CLLocationDistance radius;

@end

@implementation SCExploreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
    [self reloadPosts];
}

- (void)setupUI
{
    self.title = NSLocalizedString(@"Explore", nil);
    [self.reloadButton setTitle:NSLocalizedString(@"Search This Area", nil) forState:UIControlStateNormal];
    [self.reloadButton addTarget:self action:@selector(reloadPosts) forControlEvents:UIControlEventTouchUpInside];
    [self.reloadButton setBackgroundColor:[UIColor colorWithRed:83.0 / 255.0 green:200.0 / 255.0 blue:118.0 / 255.0 alpha:1.0]];
    [self.reloadButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.reloadButton.layer.cornerRadius = 5;
    [self setupMap];
}

- (void)setupMap
{
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    CLLocationCoordinate2D coordinate = [[SCLocationManager sharedManager] getUserCurrentLocation].coordinate;
    MKCoordinateSpan span = MKCoordinateSpanMake(1.0, 1.0);
    MKCoordinateRegion region = MKCoordinateRegionMake(coordinate, span);
    [self.mapView setRegion:region];
}

- (void)updateMapWithPosts
{
    for (SCPost *post in self.posts) {;
        MKPointAnnotation *annotation = [MKPointAnnotation new];
        [annotation setCoordinate:post.location.coordinate];
        [self.mapView addAnnotation:annotation];
    }
}

- (NSArray<SCPost *> *)postInLocation:(CLLocationCoordinate2D)coordinate
{
    NSMutableArray<SCPost *> *posts = [NSMutableArray new];
    for (SCPost *post in self.posts) {
        CLLocationCoordinate2D postCoordinate = post.location.coordinate;
        if ((fabs(postCoordinate.latitude - coordinate.latitude) <= 0.001) &&
            (fabs(postCoordinate.longitude - coordinate.longitude) <= 0.001)) {
            [posts addObject:post];
        }
    }
    return posts;
}

#pragma mark - action
- (void)reloadPosts
{
    // coordinate of map center
    CLLocationCoordinate2D centerCoordinate = [self.mapView centerCoordinate];
    self.center = [[CLLocation alloc] initWithLatitude:centerCoordinate.latitude longitude:centerCoordinate.longitude];
    
    // cooridinate of top left conner of map
    CLLocationCoordinate2D topCenterCoordinate = [self.mapView convertPoint:CGPointMake(0, 0) toCoordinateFromView:self.mapView];
    CLLocation *topCenter = [[CLLocation alloc] initWithLatitude:topCenterCoordinate.latitude longitude:topCenterCoordinate.longitude];
    self.radius = [self.center distanceFromLocation:topCenter];
    
    [self fetchPostsWithLocation:self.center];
}

- (void)fetchPostsWithLocation:(CLLocation *)location
{
    __weak typeof (self) weakSelf = self;
    
    [SCPostManager getPostsWithLocation:location range:self.radius andCompletion:^(NSArray<SCPost *> *posts, NSError *error) {
        weakSelf.posts = posts;
        NSLog(@"posts count: %ld", (long)posts.count);
        [weakSelf updateMapWithPosts];
    }];
}

- (void)showPostsInMapWithLocation:(CLLocationCoordinate2D)coordinate
{
    NSArray<SCPost *> *posts =[self postInLocation:coordinate];
    if (posts.count == 1) {
        SCPostDetailViewController *detailViewController = [[SCPostDetailViewController alloc] initWithNibName:NSStringFromClass([SCPostDetailViewController class]) bundle:nil];
        [detailViewController loadDetailViewWithPost:posts.firstObject];
        [self.navigationController pushViewController:detailViewController animated:YES];
    }
    else if (posts.count > 1) {
        SCHomeViewController *postsViewController = [[SCHomeViewController alloc] initWithNibName:NSStringFromClass([SCHomeViewController class]) bundle:nil];
        [postsViewController loadResultPageWithPosts:posts];
        [self.navigationController pushViewController:postsViewController animated:YES];
    }
}

#pragma mark - MKMapViewDelegate
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [mapView deselectAnnotation:view.annotation animated:YES];
    [self showPostsInMapWithLocation:view.annotation.coordinate];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKAnnotationView *annotationView = nil;
    if (annotation != mapView.userLocation) {
        annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:SCAnnotationIdentifier];
        annotationView.image = [UIImage imageNamed:@"Shape"];
        annotationView.canShowCallout = NO;
    }
    
    return annotationView;
}

@end
