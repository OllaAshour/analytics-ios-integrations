//
//  AppDelegate.m
//  Simple Integrations Example
//
//  Created by Olla Ashour on 11/21/19.
//  Copyright © 2019 Segment. All rights reserved.
//

#import "AppDelegate.h"
#import <Analytics/SEGAnalytics.h>
#import <SEGFacebookAppEventsIntegrationFactory.h>
#import <SEGFirebaseIntegrationFactory.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // Override point for customization after application launch.
    [SEGAnalytics debug:YES];
    SEGAnalyticsConfiguration *config = [SEGAnalyticsConfiguration configurationWithWriteKey:@"WRITE_KEY"];
    
    config.trackApplicationLifecycleEvents = YES;          // Enable this to record certain application events automatically!
    config.recordScreenViews = YES;                        // Enable this to record screen views automatically!
    config.flushAt = 1;                                    // Flush events to Segment every 1 event
    
    // Add any of your bundled integrations.
    [config use:[SEGFacebookAppEventsIntegrationFactory instance]]; //Use Facebook
    [config use:[SEGFirebaseIntegrationFactory instance]]; // Use Firebase
    
    [SEGAnalytics setupWithConfiguration:config];
    
    [[SEGAnalytics sharedAnalytics] identify:@"segment-fake-tester"
                                      traits:@{ @"email": @"tool@fake-segment-tester.com" }];
    
    [[SEGAnalytics sharedAnalytics] track:@"Completed Order"
                               properties:@{ @"title": @"Launch Screen", @"revenue": @14.50 }];
    
   

    [SEGAnalytics debug:YES];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
