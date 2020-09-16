// Copyright (c) Microsoft Corporation. All rights reserved.
// Licensed under the MIT License.


#import <Cordova/NSDictionary+CordovaPreferences.h>
#import "MSAppDelegate.h"
#import "MSExamplesViewController.h"
#import "MSFriendManager.h"

#import "MeridianiOFFICEPlugin.h"
#import "MeridianiOFFICE.h"

@import AppCenterAnalytics;

@implementation MeridianiOFFICEPlugin

- (void)pluginInitialize
{
    [AppCenterShared configureWithSettings: self.commandDelegate.settings];
    [MSAppCenter startService:[MSAnalytics class]];

    BOOL enableInJs = [self.commandDelegate.settings
                       cordovaBoolSettingForKey:@"APPCENTER_ANALYTICS_ENABLE_IN_JS"
                       defaultValue:NO];

    if (enableInJs) {
        // Avoid starting an analytics session.
        // Note that we don't call this if startEnabled is true, because
        // that causes a session to try and start before MSAnalytics is started.
        [MSAnalytics setEnabled:false];
    }

    //[MSAnalytics setAutoPageTrackingEnabled:false]; // TODO: once the underlying SDK supports this, make sure to call this
}

- (void)testing:(CDVInvokedUrlCommand *)command
{
  NSLog(@"testing ioffice meridian plugin");
}

@implementation MSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSLog(@"ioffice meridian initializing");

    // configure the Meridian SDK
    MRConfig *config = [MRConfig new];

    // If samples are to be run via Default/US servers, use these values
    [config domainConfig].domainRegion = MRDomainRegionDefault;
    config.applicationToken = @"eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ0IjoxNTc5MzAwMjM4LCJ2YWx1ZSI6IjJmOWIwMjY1YmQ2NzZmOTIxNjQ5YTgxNDBlNGZjN2I4YWM0YmYyNTcifQ.pxYOq2oyyudM3ta_bcij4R_hY1r3XG6xIDATYDW4zIk";

    // If samples are to be run via EU servers, use these values instead
    // [config domainConfig].domainRegion = MRDomainRegionEU;
    // config.applicationToken = @"50b4558f8fbfd96e26e122785e61b1589e1a13a5";

    // must be called once, in application:didFinishLaunching
    [Meridian configure:config];

    // set our default appearance to be a green color matching our app icon (this has nothing to do with Meridian)
    [UINavigationBar appearance].tintColor = [UIColor whiteColor];
    [UINavigationBar appearance].barTintColor = [UIColor colorWithRed:0.1395 green:0.8678 blue:0.7167 alpha:1.0];
    [UINavigationBar appearance].barStyle = UIBarStyleBlack;
    [[UITextField appearanceWhenContainedInInstancesOfClasses:@[UISearchBar.class]] setTintColor:[[UIView alloc] init].tintColor];

    // create a controller to demonstrate use of specific Meridian APIs
    MSExamplesViewController *examplesViewController = [[MSExamplesViewController alloc] init];

    // create the main window and display it
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:examplesViewController];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];

    // Start posting location updates
    [MSFriendManager setActiveManager:[MSFriendManager manager1]];

    return YES;
}
- (BOOL)application:(UIApplication *)app
            openURL:(NSURL *)url
            options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options {
    [[MSFriendManager manager1] acceptInviteURL:url];
    return YES;
}

@end
