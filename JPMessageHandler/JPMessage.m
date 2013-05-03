//
//  JPMessage.m
//
//  Created by Jochen Pfeiffer on 07.10.12.
//  Copyright (c) 2012 Jochen Pfeiffer. All rights reserved.
//
//  https://github.com/jjochen/JPMessageHandler
//

#import "JPMessage.h"

@interface JPMessage ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSTimer *minDurationTimer;

@end


@implementation JPMessage

- (id)init
{
    self = [super init];
    if (self == nil) return nil;
    
    self.minDuration = kJPMessageDurationNotSet;
    self.maxDuration = kJPMessageDurationNotSet;
    self.messageID = kJPMessageIDNotSet;
    self.text = nil;
    
    return self;
}

- (BOOL)minDurationSet
{
    return (self.minDuration != kJPMessageDurationNotSet);
}
- (BOOL)maxDurationSet
{
    return (self.maxDuration != kJPMessageDurationNotSet);
}
- (BOOL)messageIDSet
{
    return (self.messageID != kJPMessageIDNotSet);
}

#pragma mark - show / hide

- (void)didHide
{
    [self resetTimer];
    [self resetMinDurationTimer];
    
    
}

- (void)didShow
{
    self.showTime = [NSDate date];
    [self hideAfterMaxDurationOnScreen];
    [self startMinDurationTimer];
}

#pragma mark - timer


- (NSTimeInterval)timeLeft
{
    if (self.timer != nil && self.timer.isValid) {
        return [self.timer.fireDate timeIntervalSinceNow];
    }
    return 0;
}
- (NSTimeInterval)timeOnScreen
{
    if (self.showTime != nil) {
        return [[NSDate date] timeIntervalSinceDate:self.showTime];
    }
    return 0;
}

- (void)hideAfterMaxDurationOnScreen
{
    [self resetTimer];
    if (self.maxDurationSet) {
        [self startTimerWithDuration:self.maxDuration];
    }
}
- (void)hideAfterMinDurationOnScreen
{
    NSTimeInterval duration = 0;
    if (self.minDurationSet) {
        duration = self.minDuration - self.timeOnScreen;
    }
    if (duration > 0) {
        [self startTimerWithDuration:duration];
    } else {
        [self resetTimer];
        [self resetMinDurationTimer];
        [self timerFired];
    }
}
- (void)hideDirectly
{
    [self resetTimer];
    [self resetMinDurationTimer];
    [self timerFired];
}

- (void)startTimerWithDuration:(NSTimeInterval)duration
{
    [self resetTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:duration
                                                  target:self
                                                selector:@selector(timerFired)
                                                userInfo:nil
                                                 repeats:NO];
}

- (void)startMinDurationTimer
{
    [self resetMinDurationTimer];
    if (self.minDurationSet) {
        self.minDurationTimer = [NSTimer scheduledTimerWithTimeInterval:self.minDuration
                                                                 target:self
                                                               selector:@selector(minDurationTimerFired)
                                                               userInfo:nil
                                                                repeats:NO];

    }
}

- (void)resetTimer
{
    if (self.timer.isValid) [self.timer invalidate];
    self.timer = nil;
}

- (void)resetMinDurationTimer
{
    if (self.minDurationTimer.isValid) [self.minDurationTimer invalidate];
    self.minDurationTimer = nil;
}

- (void)timerFired
{
	if (self.delegate) {
		if ([self.delegate respondsToSelector:@selector(messageTimerFired:)]) {
			[self.delegate messageTimerFired:self];
		}
	}
}

- (void)userWantsMessageHidden
{
	if (self.delegate) {
		if ([self.delegate respondsToSelector:@selector(userWantsMessageHidden:)]) {
			[self.delegate userWantsMessageHidden:self];
		} else {
            [self timerFired];
        }
	} else {
        [self timerFired];
    }
}

- (void)minDurationTimerFired
{
	if (self.delegate) {
		if ([self.delegate respondsToSelector:@selector(minDurationTimerFired:)]) {
			[self.delegate minDurationTimerFired:self];
		}
	}
}



@end
