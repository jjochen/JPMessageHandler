//
//  JPMessageHandler.h
//
//  Created by Jochen Pfeiffer on 07.10.12.
//  Copyright (c) 2012 Jochen Pfeiffer. All rights reserved.
//
//  https://github.com/jjochen/JPMessageHandler
//

#import <UIKit/UIKit.h>
#import "JPMessage.h"

@protocol JPMessageHandlerDelegate;

@interface JPMessageHandler : NSObject <UITableViewDelegate, UITableViewDataSource, JPMessageDelegate>


@property (nonatomic, assign) id<JPMessageHandlerDelegate> delegate;

@property (nonatomic, assign) CGFloat marginBottom;
@property (nonatomic, assign) CGFloat rowHeight;
@property (nonatomic, assign) UITableViewCellSeparatorStyle separatorStyle;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *messageShadowColor;
@property (nonatomic, assign) CGSize messageShadowOffset;
@property (nonatomic, strong) NSArray *messageGradientColors;
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *textColor;

@property (nonatomic, strong) UIColor *hideButtonColor;
@property (nonatomic, strong) UIColor *imageColor;

@property (nonatomic, assign) NSTimeInterval defaultMinDuration;
@property (nonatomic, assign) NSTimeInterval defaultMaxDuration;


- (id)initWithSuperview:(UIView *)superview;

- (JPMessageID)showMessage:(NSString *)text type:(JPMessageType)type minDuration:(NSTimeInterval)minDuration maxDuration:(NSTimeInterval)maxDuration;
- (JPMessageID)showMessage:(NSString *)text type:(JPMessageType)type;
- (JPMessageID)showMessage:(JPMessage *)message;

- (JPMessage *)messageWithID:(JPMessageID)messageID;
- (void)hideMessageWithID:(JPMessageID)messageID;
- (void)hideMessage:(JPMessage *)message;

@end



@protocol JPMessageHandlerDelegate <NSObject>

@optional
- (BOOL)messageHandler:(JPMessageHandler *)messageHandler shouldHideMessage:(JPMessage *)message;
- (void)messageHandler:(JPMessageHandler *)messageHandler didShowMessage:(JPMessage *)message;
- (void)messageHandler:(JPMessageHandler *)messageHandler didHideMessage:(JPMessage *)message;

@end