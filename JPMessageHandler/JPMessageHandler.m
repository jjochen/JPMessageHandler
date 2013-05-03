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

#define VIEW_DEBUG 1

#define MIN_DURATION 0.0f
#define MAX_DURATION 5.0f


#define ROW_HEIGHT 25
#define ROW_HEIGHT_IPAD 35


@interface JPMessageHandler ()

@property (nonatomic, strong) NSMutableArray *messageQueue;
@property (nonatomic, strong) UITableView *messageTableView;

@end


@implementation JPMessageHandler

static NSString *cellIdentifier = @"MessageCell";

- (id)initWithSuperview:(UIView *)superview
{
    self = [super init];
    if (self == nil) return nil;
    
    BOOL iPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    
    self.messageQueue = [[NSMutableArray alloc] init];
    
    CGRect frame = superview.bounds;
    frame.origin.y = frame.size.height;
    frame.size.height = 0.0f;
    
    self.messageTableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.messageTableView.delegate = self;
    self.messageTableView.dataSource = self;
    self.messageTableView.backgroundView = nil;
    self.messageTableView.backgroundColor = [UIColor clearColor];
    self.messageTableView.rowHeight = (iPad) ? ROW_HEIGHT_IPAD : ROW_HEIGHT;
    self.messageTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.messageTableView.allowsSelection = NO;
    self.messageTableView.transform = CGAffineTransformMakeRotation(-M_PI);
    self.messageTableView.userInteractionEnabled = YES;
    self.messageTableView.scrollEnabled = NO;
    self.messageTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    [superview addSubview:self.messageTableView];
    
    return self;
}

#pragma mark - messge queue
- (JPMessageID)showMessage:(NSString *)text type:(JPMessageType)type
{
    BOOL isLoading = (type == JPMessageTypeLoading);
    
    JPMessage *message = [[JPMessage alloc] init];
    message.delegate = self;
    message.type = type;
    message.text = text;
    message.minDuration = (isLoading) ? MIN_DURATION : MIN_DURATION;
    message.maxDuration = (isLoading) ? kJPMessageDurationNotSet : MAX_DURATION;
    
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
            cell = [[JPMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            //cell.frame = CGRectMake(0.0, 0.0, self.messageTableView.bounds.size.width, self.messageTableView.rowHeight);
            
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
