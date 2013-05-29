//
//  JPXButton.h
//
//  Created by Jochen Pfeiffer on 26.03.11.
//  Copyright 2011 Jochen Pfeiffer. All rights reserved.
//
//  https://github.com/jjochen/JPMessageHandler
//

#import <UIKit/UIKit.h>


@interface JPXButton : UIButton {
    UIColor *_color;
    UIColor *_shadowColor;
    CGSize _shadowOffset;
    CGFloat _shadowRadius;
    CGFloat _circleRadius;
}
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, assign) CGFloat shadowRadius;
@property (nonatomic, assign) CGFloat circleRadius;

@end
