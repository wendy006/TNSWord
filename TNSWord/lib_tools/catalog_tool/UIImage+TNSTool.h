//
//  UIImage+TNSTool.h
//  TNSWord
//
//  Created by mac on 15/8/17.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (TNSTool)

+ (instancetype)circleImageWithImage:id borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;


- (UIImage *)setImageWithBounds:(CGRect)bounds;
@end
