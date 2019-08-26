//
//  TNSCircleLayout.m
//  TNSWord
//
//  Created by mac on 15/8/1.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSCircleLayout.h"

@implementation TNSCircleLayout

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

//better not more than 20 sentences per chapter,but not less than 14
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    //center point
    CGPoint circleCenter = CGPointMake(self.collectionView.frame.size.width * 0.5, self.collectionView.frame.size.height * 0.5);
    
    attrs.size = CGSizeMake(50, 50);
    NSInteger itemCount = [self.collectionView numberOfItemsInSection:indexPath.section];
    
    //1.count > 6 [6 can be change]
    if (itemCount > 6)
    {
        if (indexPath.item < 6)
        {
            
            CGFloat circleRadius = 50;
            
            CGFloat angleDelta = M_PI * 2 / 6;
            
            CGFloat angle = indexPath.item * angleDelta;
            attrs.center = CGPointMake(circleCenter.x + circleRadius * cosf(angle), circleCenter.y - circleRadius * sinf(angle));
        }
        //located in outward circle if index >= 6
        else if(indexPath.item >= 6)
        {
            // radius
            CGFloat circleRadius = 50 + attrs.size.height;
            //  angleDelta
            CGFloat angleDelta = M_PI * 2 / (itemCount - 6);
            //  angle
            CGFloat angle = (indexPath.item-6) * angleDelta;
            attrs.center = CGPointMake(circleCenter.x + circleRadius * cosf(angle), circleCenter.y - circleRadius * sinf(angle));
        }
    }
    // should avoid this case -- not a good choice then
    else if(itemCount <= 6)
    {
        
        CGFloat circleRadius = 50;
        
        CGFloat angleDelta = M_PI * 2 / 6;
         
        CGFloat angle = indexPath.item * angleDelta;
        attrs.center = CGPointMake(circleCenter.x + circleRadius * cosf(angle), circleCenter.y - circleRadius * sinf(angle));
    }
    
    
    
    attrs.zIndex = indexPath.item;
    
    return attrs;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *array = [NSMutableArray array];
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (int i = 0; i<count; i++) {
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [array addObject:attrs];
    }
    return array;
}
@end
