//
//  JPMessageCell.h
//
//  Created by Jochen Pfeiffer on 07.10.12.
//  Copyright (c) 2012 Jochen Pfeiffer. All rights reserved.
//
//  https://github.com/jjochen/JPMessageHandler
//

#import <UIKit/UIKit.h>

@class JPMessage;
@class XButton;

@interface JPMessageCell : UITableViewCell


@property (nonatomic, strong) JPMessage *message;
@property (nonatomic, assign) BOOL xButtonVisible;
- (void)setXButtonVisible:(BOOL)xButtonVisible animated:(BOOL)animated;


@end
