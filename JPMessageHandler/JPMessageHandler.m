//
//  JPMessageHandler.m
//
//  Created by Jochen Pfeiffer on 07.10.12.
//  Copyright (c) 2012 Jochen Pfeiffer. All rights reserved.
//
//  https://github.com/jjochen/JPMessageHandler
//

#import "JPMessageHandler.h"
#import "JPMessageCell.h"

#define VIEW_DEBUG 0

#define MIN_DURATION 0.0f
#define MAX_DURATION 5.0f

#define IS_PAD ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define ROW_HEIGHT (IS_PAD ? 35 : 25)


@interface JPMessageHandler ()
{
    CGFloat _marginBottom;
}
@property (nonatomic, strong) NSMutableArray *messageQueue;
@property (nonatomic, strong) UITableView *messageTableView;

@end


@implementation JPMessageHandler

static NSString *cellIdentifier = @"MessageCell";

- (id)initWithSuperview:(UIView *)superview
{
    self = [super init];
    if (self == nil) return nil;
    
    
    self.messageQueue = [[NSMutableArray alloc] init];
    
    
    CGRect frame = superview.bounds;
    frame.origin.y = frame.size.height;
    frame.size.height = 0.0f;
    
    self.messageTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.allowsSelection = NO;
    self.messageTableView.transform = CGAffineTransformMakeRotation(-M_PI);
    self.messageTableView.userInteractionEnabled = YES;
    self.messageTableView.scrollEnabled = NO;
    self.messageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [superview addSubview:self.messageTableView];
    
    
    /* defaults */
    self.marginBottom = 0;
    self.backgroundView = nil;
    self.backgroundColor = [UIColor clearColor];
    self.rowHeight = ROW_HEIGHT;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.defaultMinDuration = MIN_DURATION;
    self.defaultMaxDuration = MAX_DURATION;
    
    /* cell defaults */
    self.font = [UIFont boldSystemFontOfSize:14.0f];
    self.textColor = [UIColor whiteColor];
    self.messageShadowColor = [UIColor blackColor];
    self.messageShadowOffset = CGSizeMake(0, 2);
    self.messageGradientColors = @[
                                   (id)[UIColor colorWithWhite:0 alpha:0.2].CGColor,
                                   (id)[UIColor colorWithWhite:0 alpha:0.4].CGColor
                                   ];
    self.imageColor = nil;
    self.hideButtonColor = [UIColor colorWithWhite:1 alpha:0.8];
    
    return self;
}

#pragma mark - Properties

- (CGFloat)marginBottom
{
    return _marginBottom;
}
- (void)setMarginBottom:(CGFloat)marginBottom
{
    _marginBottom = marginBottom;
    [self adjustFrame];
}

- (CGFloat)rowHeight
{
    return self.messageTableView.rowHeight;
}
- (void)setRowHeight:(CGFloat)rowHeight
{
    self.messageTableView.rowHeight = rowHeight;
}

- (UIView *)backgroundView
{
    return self.messageTableView.backgroundView;
}
- (void)setBackgroundView:(UIView *)backgroundView
{
    self.messageTableView.backgroundView = backgroundView;
}

- (UIColor *)backgroundColor
{
    return self.messageTableView.backgroundColor;
}
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    self.messageTableView.backgroundColor = backgroundColor;
}

- (UITableViewCellSeparatorStyle)separatorStyle
{
    return self.messageTableView.separatorStyle;
}
- (void)setSeparatorStyle:(UITableViewCellSeparatorStyle)separatorStyle
{
    self.messageTableView.separatorStyle = separatorStyle;
}

#pragma mark - messge queue
- (JPMessageID)showMessage:(NSString *)text type:(JPMessageType)type
{
    BOOL isLoading = (type == JPMessageTypeLoading);
    
    JPMessage *message = [[JPMessage alloc] init];
    message.delegate = self;
    message.type = type;
    message.text = text;
    message.minDuration = (isLoading) ? self.defaultMinDuration : self.defaultMinDuration;
    message.maxDuration = (isLoading) ? kJPMessageDurationNotSet : self.defaultMaxDuration;
    
    return [self showMessage:message];
}
- (JPMessageID)showMessage:(NSString *)text type:(JPMessageType)type minDuration:(NSTimeInterval)minDuration maxDuration:(NSTimeInterval)maxDuration
{
    JPMessage *message = [[JPMessage alloc] init];
    message.delegate = self;
    message.type = type;
    message.text = text;
    message.minDuration = minDuration;
    message.maxDuration = maxDuration;
    
    return [self showMessage:message];
}

- (JPMessageID)showMessage:(JPMessage *)message
{
    if (message != nil) {
        [self debugLog:[NSString stringWithFormat:@"show message: %@", message.text]];
        message.messageID = [self nextID];
        
        [self.messageQueue addObject:message];
        NSIndexPath *indexPath = [self indexPathForMessage:message];
        [self debugLog:[NSString stringWithFormat:@"number of rows: %d", [self.messageTableView numberOfRowsInSection:0]]];
        
        
        [self adjustTableViewHeight];
        
        [self.messageTableView beginUpdates];
        [self.messageTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        [self.messageTableView endUpdates];
        
        [message didShow];
        
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(messageHandler:didShowMessage:)]) {
                [self.delegate messageHandler:self didShowMessage:message];
            }
        }
        return message.messageID;
    }
    return kJPMessageIDNotSet;
}


- (void)hideMessageWithID:(JPMessageID)messageID
{
    JPMessage *message = [self messageWithID:messageID];
    [self hideMessage:message];
}

- (void)hideMessage:(JPMessage *)message
{
    [self debugLog:[NSString stringWithFormat:@"hide message: %@", message.text]];
    [message hideAfterMinDurationOnScreen];
}

- (void)removeMessageFromScreen:(JPMessage *)message
{
    [self debugLog:[NSString stringWithFormat:@"remove message: %@", message.text]];
    
    if (message != nil) {
        
        BOOL shouldHide = YES;
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(messageHandler:shouldHideMessage:)]) {
                shouldHide = [self.delegate messageHandler:self shouldHideMessage:message];
            }
        }
        
        if (shouldHide) {
            NSIndexPath *indexPath = [self indexPathForMessage:message];
            [self.messageQueue removeObject:message];
            
            
            
            [self.messageTableView beginUpdates];
            [self.messageTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self.messageTableView endUpdates];
            
            
            [message didHide];
            
            if (self.delegate) {
                if ([self.delegate respondsToSelector:@selector(messageHandler:didHideMessage:)]) {
                    [self.delegate messageHandler:self didHideMessage:message];
                }
            }
        }
    }
}

#pragma mark - message queuing 

- (NSInteger)queueIndexForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger lastIndex = self.messageQueue.count - 1;
    NSInteger index = lastIndex - indexPath.row;
    
    if (index < 0 || index > lastIndex) return NSNotFound;
    return index;
}
- (NSInteger)queueIndexForMessage:(JPMessage *)message
{
    NSInteger index = [self.messageQueue indexOfObject:message];
    
    NSInteger lastIndex = self.messageQueue.count - 1;
    if (index < 0 || index > lastIndex) return NSNotFound;
    return index;
}

- (NSIndexPath *)indexPathForQueueIndex:(NSInteger)index
{
    NSInteger lastIndex = self.messageQueue.count - 1;
    if (index < 0 || index > lastIndex) return nil;
    
    NSInteger row = lastIndex - index;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    return indexPath;
}
- (NSIndexPath *)indexPathForMessage:(JPMessage *)message
{
    NSInteger index = [self queueIndexForMessage:message];
    NSIndexPath *indexPath = [self indexPathForQueueIndex:index];
    return indexPath;
}

- (JPMessage *)messageForQueueIndex:(NSInteger)index
{
    JPMessage *message = (self.messageQueue)[index];
    return message;
}
- (JPMessage *)messageForIndexPath:(NSIndexPath *)indexPath
{
    NSInteger index = [self queueIndexForIndexPath:indexPath];
    JPMessage *message = [self messageForQueueIndex:index];
    return message;
}

- (JPMessageCell *)cellForMessage:(JPMessage *)message
{
    NSIndexPath *indexPath = [self indexPathForMessage:message];
    return (JPMessageCell *)[self.messageTableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - JPMessageDelegate

- (void)messageTimerFired:(JPMessage *)message
{
    [self removeMessageFromScreen:message];
}

- (void)userWantsMessageHidden:(JPMessage *)message
{
    
    [self removeMessageFromScreen:message];
}


- (void)minDurationTimerFired:(JPMessage *)message
{
    JPMessageCell *cell = [self cellForMessage:message];
    [cell setXButtonVisible:YES animated:YES];
}

#pragma mark - UI messageView

- (void)toggleMessageTableViewHidden
{
    self.messageTableView.hidden = !self.messageTableView.hidden;
}

- (void)hideMessageTableView
{
    self.messageTableView.hidden = YES;
}

- (void)adjustTableViewHeight
{
    NSInteger numberOfRows = self.messageQueue.count;
    CGFloat rowHeight = self.messageTableView.rowHeight;
    
    CGFloat tableViewHeight = rowHeight * numberOfRows;
    CGRect frame = self.messageTableView.frame;
    CGFloat delta = frame.size.height - tableViewHeight;
    
    frame.origin.y += delta;
    frame.size.height -= delta;
    
    self.messageTableView.frame = frame;
    
}

- (void)adjustFrame {
    if (self.messageTableView.superview) {
        CGRect frame = self.messageTableView.superview.bounds;
        frame.origin.y = frame.size.height - self.marginBottom;
        frame.size.height = 0.0f;
        
        self.messageTableView.frame = frame;
    }
}


#pragma mark - mesage ID

- (JPMessage *)messageWithID:(JPMessageID)messageID
{
    for (JPMessage *message in self.messageQueue)
    {
        if (message.messageID == messageID) {
            return message;
        }
    }
    return nil;
}

- (int)nextID
{
    int maxID = 0;
    for (JPMessage *message in self.messageQueue) {
        if (message.messageID > maxID) maxID = message.messageID;
    }
    return maxID + 1;
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.messageTableView) {
        return self.messageQueue.count;
    }
    return 0;
}



// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    if (tableView == self.messageTableView) {
        
        cell = (JPMessageCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            
            JPMessageCell *messageCell = [[JPMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];

            messageCell.font = self.font;
            messageCell.textColor = self.textColor;
            messageCell.shadowColor = self.messageShadowColor;
            messageCell.shadowOffset = self.messageShadowOffset;
            messageCell.gradientColors = self.messageGradientColors;
            messageCell.hideButtonColor = self.hideButtonColor;
            messageCell.imageColor = self.imageColor;
            cell = messageCell;
        }
	} 
	
	[self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[JPMessageCell class]]) {
        JPMessageCell *messageCell = (JPMessageCell *)cell;
        JPMessage *message = [self messageForIndexPath:indexPath];
        messageCell.message = message;
    };
}

#pragma mark - UITableView Delegate methods

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView == self.messageTableView) {
        
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath  
{
    [self adjustTableViewHeight];
}


#pragma mark - debug

- (void)debugLog:(NSObject *)object
{
    if (VIEW_DEBUG) {
        NSLog(@"%@", object);
    }
}

@end
