//
//  AppDelegate.h
//  VoyageUp
//
//  Created by Deepak on 20/04/15.
//  Copyright (c) 2015 Deepak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VUContactsViewController.h"
#import "VUMenuViewController.h"

@import SystemConfiguration.CaptiveNetwork;
@interface AppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic)CLGeocoder *geocoder;
@property (strong, nonatomic)CLPlacemark *placemark;
@property (nonatomic, assign) BOOL Islogin;
@property (nonatomic, retain) NSString *apns_token;
@property (nonatomic, retain) NSString *network_token;
@property (nonatomic, retain) NSString *api_key;
@property (nonatomic, retain) NSString *Latitude;
@property (nonatomic, retain) NSString *longitude;
@property (nonatomic, retain) NSString *geofenceArea;
@property BOOL signUp;
@property (nonatomic, assign) BOOL firstTime;
- (void)locationUpdate:(NSString*)latitude;
@end

