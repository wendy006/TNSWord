//
//  TNSCollectionViewFlowLayout.m
//  TNSWord
//
//  Created by mac on 15/7/27.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSCollectionViewFlowLayout.h"

//static const CGFloat TNItemWH = 100;
@interface TNSCollectionViewFlowLayout()

@property(nonatomic,assign) CGFloat TNItemWH;

@end

@implementation TNSCollectionViewFlowLayout

-(CGFloat)TNItemWH
{
    if (!_TNItemWH)  _TNItemWH = 100.0/320.0 * screenW;
    return _TNItemWH;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
 - (void)prepareLayout
{
    [super prepareLayout];
    
    // cell's size
    self.itemSize = CGSizeMake(self.TNItemWH, self.TNItemWH);
 
    
    CGFloat inset =  20;
    self.sectionInset = UIEdgeInsetsMake(0, inset, 0, inset);
    
    self.minimumLineSpacing = self.TNItemWH * 0.4;
    self.minimumInteritemSpacing = 20;
}


- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    
    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;
    
    
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
     return array;
}



@end
