//
//  JPAppDelegate.h
//  JPMessageDemo
//
//  Created by Jochen Pfeiffer on 03.05.13.
//  Copyright (c) 2013 Jochen Pfeiffer. All rights reserved.
//
//  https://github.com/jjochen/JPMessageHandler
//

#import <UIKit/UIKit.h>

@class JPViewController;

@interface JPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) JPViewController *viewController;

@end
