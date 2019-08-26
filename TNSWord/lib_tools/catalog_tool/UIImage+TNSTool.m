//
//  UIImage+TNSTool.m
//  TNSWord
//
//  Created by mac on 15/8/17.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "UIImage+TNSTool.h"

@implementation UIImage (TNSTool)

+ (instancetype)circleImageWithImage:id borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor
{
    UIImage *oldImage = [[UIImage alloc] init];
    
//    TNLog(@"%@",[id class]);
    if([id isKindOfClass:[UIImage class] ] )
    {
        oldImage = (UIImage *)id;
    }
    else if ([id isKindOfClass:[NSString class] ] )
    {
        oldImage = [UIImage imageNamed:(NSString *)id];
    }
    
    else
    {
        TNLog(@"error");
        return nil;
    }
    
    
    CGFloat imageW = oldImage.size.width + 2 * borderWidth;
    CGFloat imageH = oldImage.size.height + 2 * borderWidth;
    CGSize imageSize = CGSizeMake(imageW, imageH);
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    
    [borderColor set];
    CGFloat bigRadius = imageW * 0.5;
    CGFloat centerX = bigRadius;
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx);
    
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    CGContextClip(ctx);
    
    [oldImage drawInRect:CGRectMake(borderWidth, borderWidth, oldImage.size.width, oldImage.size.height)];
    
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)setImageWithBounds:(CGRect)bounds
{
    UIGraphicsBeginImageContext(bounds.size);
    
    [self drawInRect:bounds];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
    
}


@end
