//
//  TNSGameChapterChooseCVC.m
//  TNSWord
//
//  Created by mac on 15/7/26.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSGameChapterChooseCVC.h"
#import "TNSChapterChooseCollectionCell.h"
#import "TNSLineLayout.h"

#import "TNSHomeVC.h"
#import "TNSGameSentenceChooseCVC.h"
 

@interface TNSGameChapterChooseCVC ()
@end

@implementation TNSGameChapterChooseCVC

static NSString * const reuseIdentifier = @"readingChapterCell";

-(NSMutableArray *)chapters
{
    if (!_chapters)
    {
        _chapters = [[TNDataContainer sharedDataContainer].chapters mutableCopy];
    }
    return _chapters;
}

- (NSMutableArray *)images
{
    if (!_images) {
        self.images = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [TNDataContainer sharedDataContainer].chapters.count; i++) {
            [self.images addObject:[NSString stringWithFormat:@"%d_gameC", i]];
        }
    }
    return _images;
}

- (instancetype)init
{
    TNSLineLayout *layout = [[TNSLineLayout alloc] init];
 
    self = [super initWithCollectionViewLayout:layout ];
    if (self) {
        CGRect rect = CGRectMake(20, 84, screenW - 40, screenH - 104);
      
        self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];        
        [self.collectionView setBackgroundColor:[UIColor grayColor] ];
 
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"TNSChapterChooseCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        
//         [self performSelector:@selector(test) withObject:nil afterDelay:2];
        
    }
    return self;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
  
}

/**
 *  default selection(when first turn into this page) is the first chapter
 */
-(void)defaultSelectFirstChapter
{
    NSIndexPath *iconIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:iconIndexPath];
    cell.selected = YES;
 
    [self.collectionView selectItemAtIndexPath:iconIndexPath animated:YES scrollPosition:UICollectionViewScrollPositionBottom];
    
    [self collectionView:self.collectionView didSelectItemAtIndexPath:iconIndexPath];

}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.images.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TNSChapterChooseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    UIImage *image = [UIImage imageNamed:self.images[indexPath.item]];
   
    //cutting into circle
    image  = [UIImage circleImageWithImage:image borderWidth:1 borderColor:[UIColor grayColor]];

    //image setting
    cell.chapterCellImageView.frame = CGRectInset(cell.bounds, 1, 1);
    [cell.chapterCellImageView setImage: image];
 
    return cell;
}




- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    [TNDataContainer sharedDataContainer].chapterIndex = indexPath.item;
    [collectionView cellForItemAtIndexPath:indexPath].alpha = 0.5;

 
    ((TNSHomeVC *)(self.parentViewController)).chapterShowLabel.text = [NSString stringWithFormat:@"第 %d 课",indexPath.item +1];
    ((TNSHomeVC *)(self.parentViewController)).chapterShowLabel.textColor = [UIColor grayColor];
    ((TNSHomeVC *)(self.parentViewController)).chapterShowLabel.font=[UIFont fontWithName:@"Arial Rounded MT Bold" size:15.5];
    ((TNSHomeVC *)(self.parentViewController)).chapterShowLabel.alpha = 0.5;
    
    
    
#pragma mark -  gameSentenceChooseCVC ，could change some of follows, if comes better solution++++++++++++++++++++++
 
    // if the former gameSentenceChooseCVC still alives
    if([((TNSHomeVC *)(self.parentViewController)).gameSentenceChooseCVC.collectionView isDescendantOfView:((TNSHomeVC *)(self.parentViewController)).view])
    {
         [ ((TNSHomeVC *)(self.parentViewController)).gameSentenceChooseCVC.collectionView removeFromSuperview];
        [ ((TNSHomeVC *)(self.parentViewController)).gameSentenceChooseCVC removeFromParentViewController];
 
         ((TNSHomeVC *)(self.parentViewController)).gameSentenceChooseCVC = NULL;
    }

    TNSHomeVC *homeVC = (TNSHomeVC *)(self.parentViewController);// its parentVC == homeVC
  
    CGRect rect2 = CGRectMake(20, 84+100+5, screenW - 40, screenH - 104-10-100-5);
    
    [homeVC.baseView addSubview:homeVC.gameSentenceChooseCVC.collectionView];
    [ homeVC.gameSentenceChooseCVC.collectionView setFrame:rect2 ];
    [ homeVC addChildViewController:((TNSHomeVC *)(self.parentViewController)). gameSentenceChooseCVC ];
    [ homeVC. gameSentenceChooseCVC  didMoveToParentViewController:self ];
 
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"gameChapterIndexDidChanged" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:indexPath.item ] ,@"indexPath.item", nil]];
    
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView cellForItemAtIndexPath:indexPath].alpha = 1;
}



@end
