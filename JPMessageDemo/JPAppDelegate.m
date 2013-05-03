//
//  JPAppDelegate.m
//  JPMessageDemo
//
//  Created by Jochen Pfeiffer on 03.05.13.
//  Copyright (c) 2013 Jochen Pfeiffer. All rights reserved.
//
//  https://github.com/jjochen/JPMessageHandler
//

#import "JPAppDelegate.h"

#import "JPViewController.h"

@implementation JPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    self.viewController = [[JPViewController alloc] initWithNibName:@"JPViewController" bundle:nil];
    self.window.rootViewController = self.viewController;
    
    [self.window makeKeyAndVisible];
    return YES;
}

@end
