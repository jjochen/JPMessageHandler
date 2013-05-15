//
//  UIImage+Tinting.m
//  JPMessageDemo
//
//  Created by Jochen Pfeiffer on 15.05.13.
//  Copyright (c) 2013 Jochen Pfeiffer. All rights reserved.
//

#import "UIImage+Tinting.h"

@implementation UIImage (Tinting)
+ (UIImage *)tintedImageNamed:(NSString *)name color:(UIColor *)color
{
	UIImage *image = [UIImage imageNamed:name];
	CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
	UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[image drawInRect:rect];
	CGContextSetFillColorWithColor(context, [color CGColor]);
	CGContextSetBlendMode(context, kCGBlendModeSourceAtop);
	CGContextFillRect(context, rect);
	UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return result;
}
@end
