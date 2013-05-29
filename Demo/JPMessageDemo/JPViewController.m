//
//  JPViewController.m
//  JPMessageDemo
//
//  Created by Jochen Pfeiffer on 03.05.13.
//  Copyright (c) 2013 Jochen Pfeiffer. All rights reserved.
//
//  https://github.com/jjochen/JPMessageHandler
//

#import "JPViewController.h"

@interface JPViewController ()

@property (strong, nonatomic) JPMessageHandler *messageHandler;
@property (assign, nonatomic) JPMessageID loadingMessagID;

@end

@implementation JPViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.messageHandler = [[JPMessageHandler alloc] initWithSuperview:self.view];
    self.messageHandler.delegate = self;
    
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    CGFloat rowHeight = iPad ? 35 : 27;
    
    self.messageHandler.marginBottom = 0;
    self.messageHandler.backgroundView = nil;
    self.messageHandler.backgroundColor = [UIColor clearColor];
    self.messageHandler.rowHeight = rowHeight;
    self.messageHandler.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageHandler.defaultMinDuration = 0;
    self.messageHandler.defaultMaxDuration = 5;
    self.messageHandler.font = [UIFont boldSystemFontOfSize:14.0f];
    self.messageHandler.textColor = [UIColor whiteColor];
    self.messageHandler.imageColor = nil;
    self.messageHandler.hideButtonColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.messageHandler.messageShadowColor = [UIColor blackColor];
    self.messageHandler.messageShadowOffset = CGSizeMake(0, 2);
    self.messageHandler.messageGradientColors = @[
                                                  (id)[UIColor colorWithWhite:0.000 alpha:0.200].CGColor,
                                                  (id)[UIColor colorWithWhite:0.000 alpha:0.400].CGColor
                                                  ];
    
    
    
    self.loadingMessagID = kJPMessageIDNotSet;
}

- (void)startLoading {
    self.loadingMessagID = [self.messageHandler showMessage:@"Loading ..." type:JPMessageTypeLoading];
}
- (void)stopLoading {
    self.loadingMessagID = kJPMessageIDNotSet;
}
#pragma mark - IBActions

- (IBAction)showMessageButtonPressed:(id)sender {
    [self.messageHandler showMessage:@"Info Message" type:JPMessageTypeInfo];
}
- (IBAction)startLoadingButtonPressed:(id)sender {
    if (self.loadingMessagID == kJPMessageIDNotSet) {
        [self startLoading];
    } else {
        [self.messageHandler showMessage:@"Stop current process first." type:JPMessageTypeInfo];
    }
}
- (IBAction)stopLoadingButtonPressed:(id)sender {
    if (self.loadingMessagID != kJPMessageIDNotSet) {
        [self.messageHandler hideMessageWithID:self.loadingMessagID];
        [self stopLoading];
    } else {
        [self.messageHandler showMessage:@"Sorry, nothing is loading." type:JPMessageTypeError];
    }
}
- (IBAction)showErrorButtonPressed:(id)sender {
    [self.messageHandler showMessage:@"Long Error Message (min 4sec)" type:JPMessageTypeError minDuration:4.0 maxDuration:10.0];
    
}

#pragma mark - JPMessageHandlerDelegate

- (BOOL)messageHandler:(JPMessageHandler *)messageHandler shouldHideMessage:(JPMessage *)message
{
    if (message.messageID == self.loadingMessagID) {
        [self stopLoading];
    }
    return YES;
}

- (void)messageHandler:(JPMessageHandler *)messageHandler didHideMessage:(JPMessage *)message
{
    
}
- (void)messageHandler:(JPMessageHandler *)messageHandler didShowMessage:(JPMessage *)message
{
    
}

@end
