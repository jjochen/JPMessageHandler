//
//  JPMessage.h
//
//  Created by Jochen Pfeiffer on 07.10.12.
//  Copyright (c) 2012 Jochen Pfeiffer. All rights reserved.
//
//  https://github.com/jjochen/JPMessageHandler
//

#import <Foundation/Foundation.h>



typedef enum {
    JPMessageTypePlain = 0,
    JPMessageTypeLoading,
    JPMessageTypeInfo,
    JPMessageTypeError
} JPMessageType;
static const NSInteger kJPNumberOfMessageTypes = 4;


typedef unsigned int JPMessageID;
static const JPMessageID kJPMessageIDNotSet = 0;
static const NSTimeInterval kJPMessageDurationNotSet = 0;


@protocol JPMessageDelegate;


@interface JPMessage : NSObject


@property (nonatomic, assign) id<JPMessageDelegate> delegate;

@property (nonatomic, assign) JPMessageType type;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, assign) NSTimeInterval minDuration;
@property (nonatomic, assign) NSTimeInterval maxDuration;
@property (nonatomic, assign) JPMessageID messageID;
@property (nonatomic, strong) NSDate *showTime;

@property (nonatomic, readonly) BOOL onScreen;
@property (nonatomic, readonly) BOOL messageIDSet;
@property (nonatomic, readonly) BOOL minDurationSet;
@property (nonatomic, readonly) BOOL maxDurationSet;
@property (nonatomic, readonly) NSTimeInterval timeOnScreen;
@property (nonatomic, readonly) NSTimeInterval timeLeft;

- (void)hideAfterMinDurationOnScreen;
- (void)hideAfterMaxDurationOnScreen;
- (void)hideDirectly;

- (void)didShow;
- (void)didHide;

@end


@protocol JPMessageDelegate <NSObject>
- (void)messageTimerFired:(JPMessage *)message;
@optional
- (void)minDurationTimerFired:(JPMessage *)message;
- (void)userWantsMessageHidden:(JPMessage *)message;
@end
