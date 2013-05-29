//
//  UIImage+Tinting.h
//
//  Created by Jochen Pfeiffer on 15.05.13.
//  Copyright (c) 2013 Jochen Pfeiffer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tinting)
+ (UIImage *)tintedImageNamed:(NSString *)name color:(UIColor *)color;
@end
