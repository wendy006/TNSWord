//
//  TNSLineLayout.m
//  TNSWord
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSLineLayout.h"
//static const CGFloat TNItemWH = 50;
@interface TNSLineLayout()
@property(nonatomic,assign) CGFloat TNItemWH;
@property(nonatomic,assign) CGFloat TNActiveDis;
@end

@implementation TNSLineLayout

-(CGFloat)TNItemWH
{
    if (!_TNItemWH)  _TNItemWH = 50.0/320.0 * screenW;
    return _TNItemWH;
}


-(CGFloat)TNActiveDis
{
    if (!_TNActiveDis)  _TNActiveDis = 150.0/320.0 * screenW;
    return _TNActiveDis;
}


- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // final location when it stopps scrolling
    CGRect lastRect;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    
    //  center x of the screen
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // attributes contains in final rect
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    //  traverse
    CGFloat adjustOffsetX = MAXFLOAT;
    for (UICollectionViewLayoutAttributes *attrs in array)
    {
        if (ABS(attrs.center.x - centerX) < ABS(adjustOffsetX))
        {
            adjustOffsetX = attrs.center.x - centerX;
        }
    }
    
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}


- (void)prepareLayout
{
    [super prepareLayout];
    
    
    self.itemSize = CGSizeMake(self.TNItemWH, self.TNItemWH);
    CGFloat inset = (self.collectionView.frame.size.width - self.TNItemWH) * 0.5;
 
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
    
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = self.TNItemWH * 0.7;
    
   
}


//static CGFloat const TNActiveDis= 150/320*screenW;

static CGFloat const TNScaleFac = 0.8;

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // visible rect
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
  
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width * 0.5;
    
    // traverse
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // skip when not in visible rect
        if (!CGRectIntersectsRect(visiableRect, attrs.frame)) continue;
        
        // item's center x
        CGFloat itemCenterX = attrs.center.x;
       
        //scaling
        CGFloat scale = 1 + TNScaleFac  * (1 - (ABS(itemCenterX - centerX) / self.TNActiveDis ));
        attrs.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return array;
}




@end
