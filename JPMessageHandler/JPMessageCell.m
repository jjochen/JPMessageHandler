//
//  JPMessageCell.m
//
//  Created by Jochen Pfeiffer on 07.10.12.
//  Copyright (c) 2012 Jochen Pfeiffer. All rights reserved.
//
//  https://github.com/jjochen/JPMessageHandler
//

#import "JPMessageCell.h"
#import <QuartzCore/QuartzCore.h>
#import "JPMessage.h"
#import "JPXButton.h"
#import "UIImage+Tinting.h"


#define LEFT_MARGIN 12
#define INNER_MARGIN 20

@interface JPMessageCell ()
{
    JPMessage *_message;
    UIColor *_shadowColor;
    CGSize _shadowOffset;
    BOOL _xButtonVisible;
    UIColor *_imageColor;
}

@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) UIImageView *warningImage;
@property (nonatomic, strong) UIImageView *errorImage;
@property (nonatomic, strong) JPXButton *xButton;

@end

@implementation JPMessageCell

+ (Class)layerClass
{
	return [CAGradientLayer class];
}


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initialization];
    }
    return self;
}

- (void)initialization
{
    self.clipsToBounds = NO;
    self.backgroundColor = [UIColor clearColor];
    
    self.autoresizesSubviews = YES;
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.contentView.autoresizesSubviews = YES;
    
    self.errorImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_error.png"]];
    self.errorImage.layer.opacity = 1;
    self.errorImage.layer.shadowOpacity = 1;
    self.errorImage.layer.shadowRadius = 0;
    self.errorImage.layer.shouldRasterize = YES;
    self.errorImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.errorImage.clipsToBounds = NO;
    
    self.warningImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_warning.png"]];
    self.warningImage.layer.opacity = 1;
    self.warningImage.layer.shadowOpacity = 1;
    self.warningImage.layer.shadowRadius = 0;
    self.warningImage.layer.shouldRasterize = YES;
    self.warningImage.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.warningImage.clipsToBounds = NO;
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [self.activityIndicator startAnimating];
    self.activityIndicator.layer.opacity = 1;
    self.activityIndicator.layer.shadowOpacity = 1;
    self.activityIndicator.layer.shadowRadius = 0;
    self.activityIndicator.layer.shouldRasterize = YES;
    self.activityIndicator.layer.rasterizationScale = [UIScreen mainScreen].scale;
    self.activityIndicator.clipsToBounds = NO;
    
    self.xButton = [[JPXButton alloc] initWithFrame:CGRectZero];
    self.xButton.color = [UIColor colorWithWhite:0.9 alpha:0.9];
    [self.xButton addTarget:self action:@selector(hide:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textLabel.opaque = NO;
    self.textLabel.backgroundColor = [UIColor clearColor];
    self.textLabel.textAlignment = NSTextAlignmentLeft;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    
    
    [self.contentView addSubview:self.errorImage];
    [self.contentView addSubview:self.warningImage];
    [self.contentView addSubview:self.activityIndicator];
    [self.contentView addSubview:self.xButton];
    
    self.warningImage.hidden = YES;
    self.activityIndicator.hidden = YES;
    self.errorImage.hidden = YES;


    // table view is rotated. Rotate cells back.
    self.transform = CGAffineTransformMakeRotation(M_PI);
    
    
    
    /* defaults */
    
    self.shadowColor = [UIColor colorWithWhite:0 alpha:1];
    self.shadowOffset = CGSizeMake(0, 2);
    self.gradientColors = @[
                            (id)[UIColor colorWithWhite:0 alpha:0.2].CGColor,
                            (id)[UIColor colorWithWhite:0 alpha:0.4].CGColor
                            ];
    self.textColor = [UIColor colorWithWhite:1 alpha:1];
    self.font = [UIFont boldSystemFontOfSize:14];
    self.imageColor = nil;
    self.hideButtonColor = [UIColor colorWithWhite:1 alpha:0.8];
    self.xButtonVisible = NO;
}


#pragma mark - Properties 

- (void)setMessage:(JPMessage *)message
{
    _message = message;
    
    self.xButtonVisible = !message.minDurationSet;
    self.textLabel.text = message.text;
    
    [self setNeedsLayout];
}
- (JPMessage *)message
{
    return _message;
}


- (void)setShadowColor:(UIColor *)shadowColor
{
    _shadowColor = shadowColor;

    self.errorImage.layer.shadowColor = shadowColor.CGColor;
    self.warningImage.layer.shadowColor = shadowColor.CGColor;
    self.activityIndicator.layer.shadowColor = shadowColor.CGColor;
    self.textLabel.shadowColor = shadowColor;
    self.xButton.shadowColor = shadowColor;
}
- (UIColor *)shadowColor
{
    return _shadowColor;
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    _shadowOffset = shadowOffset;
    
    self.errorImage.layer.shadowOffset = shadowOffset;
    self.warningImage.layer.shadowOffset = shadowOffset;
    self.activityIndicator.layer.shadowOffset = shadowOffset;
    self.textLabel.shadowOffset = shadowOffset;
    self.xButton.shadowOffset = shadowOffset;
}
- (CGSize)shadowOffset
{
    return _shadowOffset;
}

- (void)setGradientColors:(NSArray *)gradientColors
{
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    gradientLayer.colors = gradientColors;
}
- (NSArray *)gradientColors
{
    CAGradientLayer *gradientLayer = (CAGradientLayer *)self.layer;
    return gradientLayer.colors;
    
}

- (void)setTextColor:(UIColor *)textColor
{
    self.textLabel.textColor = textColor;
}
- (UIColor *)textColor
{
    return self.textLabel.textColor;
}

- (void)setFont:(UIFont *)font
{
    self.textLabel.font = font;
}
- (UIFont *)font
{
    return self.textLabel.font;
}

- (void)setHideButtonColor:(UIColor *)hideButtonColor
{
    self.xButton.color = hideButtonColor;
}
- (UIColor *)hideButtonColor
{
    return self.xButton.color;
}

- (void)setImageColor:(UIColor *)imageColor
{
    if (imageColor != _imageColor) {
        _imageColor = imageColor;
        
        if (imageColor == nil) {
            self.warningImage.image = [UIImage imageNamed:@"message_warning.png"];
            self.errorImage.image = [UIImage imageNamed:@"message_error.png"];
        } else {
            self.warningImage.image = [UIImage tintedImageNamed:@"message_warning.png" color:imageColor];
            self.errorImage.image = [UIImage tintedImageNamed:@"message_error.png" color:imageColor];
        }
    }
}
- (UIColor *)imageColor
{
    return _imageColor;
}


- (void)setXButtonVisible:(BOOL)xButtonVisible
{
    _xButtonVisible = xButtonVisible;
    
    self.xButton.alpha = xButtonVisible ? 1.0f : 0.0f;
    self.xButton.userInteractionEnabled = xButtonVisible;
}
- (void)setXButtonVisible:(BOOL)xButtonVisible animated:(BOOL)animated
{
    if (animated) {
        [UIView animateWithDuration:0.25f animations:^{
            self.xButtonVisible = xButtonVisible;
        }];
    } else {
        self.xButtonVisible = xButtonVisible;
    }
}





#pragma mark - Layout

- (void)layoutSubviews
{    
    CGRect iconFrame;
    switch (self.message.type) {
        case JPMessageTypePlain:
            iconFrame = CGRectZero;
            break;
        case JPMessageTypeLoading:
            iconFrame.size = self.activityIndicator.frame.size;
            iconFrame.origin.x = LEFT_MARGIN;
            iconFrame.origin.y = (self.contentView.bounds.size.height - iconFrame.size.height)/2;
            self.activityIndicator.frame = iconFrame;
            break;
        case JPMessageTypeInfo:
            iconFrame.size = self.warningImage.frame.size;
            iconFrame.origin.x = LEFT_MARGIN;
            iconFrame.origin.y = (self.contentView.bounds.size.height - iconFrame.size.height)/2;
            self.warningImage.frame = iconFrame;
            break;
        case JPMessageTypeError:
            iconFrame.size = self.errorImage.frame.size;
            iconFrame.origin.x = LEFT_MARGIN;
            iconFrame.origin.y = (self.contentView.bounds.size.height - iconFrame.size.height)/2;
            self.errorImage.frame = iconFrame;
            break;
    }
    
    
    switch (self.message.type) {
        case JPMessageTypePlain:
            self.errorImage.hidden = YES;
            self.warningImage.hidden = YES;
            self.activityIndicator.hidden = YES;
            break;
        case JPMessageTypeLoading:
            self.errorImage.hidden = YES;
            self.warningImage.hidden = YES;
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            break;
        case JPMessageTypeInfo:
            self.errorImage.hidden = YES;
            self.warningImage.hidden = NO;
            self.activityIndicator.hidden = YES;
            break;
        case JPMessageTypeError:
            self.errorImage.hidden = NO;
            self.warningImage.hidden = YES;
            self.activityIndicator.hidden = YES;
            break;
            
    }
    
    CGRect messageFrame;
    messageFrame.origin.y = 0;
    messageFrame.origin.x = iconFrame.size.width + iconFrame.origin.x + LEFT_MARGIN;
    messageFrame.size.height = self.contentView.bounds.size.height;
    messageFrame.size.width = self.contentView.bounds.size.width - messageFrame.origin.x - INNER_MARGIN;
    
    self.textLabel.frame = messageFrame;
    
    
    CGRect xButtonFrame;
    xButtonFrame.size.height = self.frame.size.height;
    xButtonFrame.size.width = xButtonFrame.size.height;
    xButtonFrame.origin.x = self.contentView.bounds.size.width - xButtonFrame.size.width - 2;
    xButtonFrame.origin.y = 0;
    self.xButton.circleRadius = xButtonFrame.size.height * 0.6;
    self.xButton.frame = xButtonFrame;

    self.backgroundColor = [UIColor clearColor];
    self.textLabel.backgroundColor = [UIColor clearColor];
    
    self.xButton.userInteractionEnabled = YES;
    [self bringSubviewToFront:self.xButton];
    [self.xButton setNeedsDisplay];
    
}

- (void)hide:(id)sender
{
    if (self.message.onScreen) {
        [self.message hideAfterMinDurationOnScreen];
    }
}
@end
