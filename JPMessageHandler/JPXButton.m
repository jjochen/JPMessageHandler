//
//  JPXButton.m
//
//  Created by Jochen Pfeiffer on 26.03.11.
//  Copyright 2011 Jochen Pfeiffer. All rights reserved.
//
//  https://github.com/jjochen/JPMessageHandler
//

#import "JPXButton.h"


@implementation JPXButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0];
        self.showsTouchWhenHighlighted = YES;
        
        self.color = [UIColor colorWithWhite:0.8 alpha:0.8];
        self.shadowColor = [UIColor blackColor];
        self.shadowOffset = CGSizeMake(0, 1);
        self.shadowRadius = 0.5;
        self.circleRadius = 0.0;
    }
    return self;
}

/*
 
 A B C
 H X D
 G F E
 
 */

- (void)drawRect:(CGRect)rect
{
    CGRect quad = rect;
    float minSide = fminf(rect.size.width, rect.size.height);
    float quadHeight = minSide;
    if (self.circleRadius != 0 && self.circleRadius < quadHeight) {
        quadHeight = self.circleRadius;
    }
    quad.size = CGSizeMake(quadHeight, quadHeight);
    
    
    CGRect buttonRect = quad;
    buttonRect.origin.x += (rect.size.width - quadHeight)/2;
    buttonRect.origin.y += (rect.size.height - quadHeight)/2;
    
    
    
    CGSize Xinset = CGSizeMake(buttonRect.size.width/10, buttonRect.size.height/10);
    CGSize inset = CGSizeMake(buttonRect.size.width/4, buttonRect.size.height/4);
    float radius = Xinset.height;
    
	CGRect Xrect = buttonRect;
    Xrect.origin.x += inset.width;
    Xrect.origin.y += inset.height;
    Xrect.size.width -= inset.width*2;
    Xrect.size.height -= inset.height*2;
    
    
    
	CGPoint center = CGPointMake(buttonRect.origin.x + buttonRect.size.width/2, buttonRect.origin.y + buttonRect.size.height/2);
    
    
	CGPoint pointA  = CGPointMake(Xrect.origin.x, Xrect.origin.y);
	CGPoint pointA1 = CGPointMake(Xrect.origin.x, Xrect.origin.y + Xinset.height);
	CGPoint pointA2 = CGPointMake(Xrect.origin.x + Xinset.width, Xrect.origin.y);
	CGPoint pointB  = CGPointMake(center.x, center.y - Xinset.height);
	CGPoint pointC  = CGPointMake(Xrect.origin.x + Xrect.size.width, Xrect.origin.y);
	CGPoint pointC1 = CGPointMake(Xrect.origin.x + Xrect.size.width - Xinset.width, Xrect.origin.y);
	CGPoint pointC2 = CGPointMake(Xrect.origin.x + Xrect.size.width, Xrect.origin.y + Xinset.height);
	CGPoint pointD  = CGPointMake(center.x + Xinset.width, center.y);
	CGPoint pointE  = CGPointMake(Xrect.origin.x + Xrect.size.width, Xrect.origin.y + Xrect.size.height);
	CGPoint pointE1 = CGPointMake(Xrect.origin.x + Xrect.size.width, Xrect.origin.y + Xrect.size.height - Xinset.height);
	CGPoint pointE2 = CGPointMake(Xrect.origin.x + Xrect.size.width - Xinset.width, Xrect.origin.y + Xrect.size.height);
	CGPoint pointF  = CGPointMake(center.x, center.y + Xinset.height);
	CGPoint pointG  = CGPointMake(Xrect.origin.x, Xrect.origin.y + Xrect.size.height);
	CGPoint pointG1 = CGPointMake(Xrect.origin.x + Xinset.width, Xrect.origin.y + Xrect.size.height);
	CGPoint pointG2 = CGPointMake(Xrect.origin.x, Xrect.origin.y + Xrect.size.height - Xinset.height);
	CGPoint pointH  = CGPointMake(center.x - Xinset.width, center.y);   
    
    
    
	CGContextRef context = UIGraphicsGetCurrentContext();
	
    
    CGContextAddEllipseInRect(context, buttonRect);    
	
    CGContextMoveToPoint(context, pointA2.x, pointA2.y);
    CGContextAddArcToPoint(context, pointA.x, pointA.y, pointA1.x, pointA1.y, radius);
    CGContextAddLineToPoint(context, pointH.x, pointH.y);
    CGContextAddLineToPoint(context, pointG2.x, pointG2.y);
    CGContextAddArcToPoint(context, pointG.x, pointG.y, pointG1.x, pointG1.y, radius);
    CGContextAddLineToPoint(context, pointF.x, pointF.y);
    CGContextAddLineToPoint(context, pointE2.x, pointE2.y);
    CGContextAddArcToPoint(context, pointE.x, pointE.y, pointE1.x, pointE1.y, radius);
    CGContextAddLineToPoint(context, pointD.x, pointD.y);
    CGContextAddLineToPoint(context, pointC2.x, pointC2.y);
    CGContextAddArcToPoint(context, pointC.x, pointC.y, pointC1.x, pointC1.y, radius);
    CGContextAddLineToPoint(context, pointB.x, pointB.y);
    CGContextAddLineToPoint(context, pointA2.x, pointA2.y);
    
    CGContextClosePath(context);
	
    
    if (self.shadowColor) {
        CGContextSetShadowWithColor(context, self.shadowOffset, self.shadowRadius, [self.shadowColor CGColor]);
    }
	[self.color setFill];
	CGContextDrawPath (context, kCGPathFill);

}

@end
