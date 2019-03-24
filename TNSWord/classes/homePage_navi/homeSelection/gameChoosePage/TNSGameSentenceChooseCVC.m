//
//  TNSGameSentenceChooseCVC.m
//  TNSWord
//
//  Created by mac on 15/7/26.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSGameSentenceChooseCVC.h"
#import "TNSCircleLayout.h"
#import "TNSChapterChooseCollectionCell.h"

#import "TNTouchViewController.h"
#import "TNTouchView.h"

@interface TNSGameSentenceChooseCVC ()

@property(nonatomic,strong)NSMutableArray *gameSentenceArray;
@property(nonatomic,strong)NSMutableArray *images;


// for data delivery
@property(nonatomic,strong)TNTouchViewController *touchVC;

@end

@implementation TNSGameSentenceChooseCVC

static NSString * const reuseIdentifier = @"readingChapterCell";


-(NSMutableArray *)gameSentenceArray
{
  return [[TNDataContainer sharedDataContainer] enSentenceArrayInChapterWithIndex:[TNDataContainer sharedDataContainer].chapterIndex];
}

- (NSMutableArray *)images
{
    if (!_images) {
        self.images = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < self.gameSentenceArray.count; i++)
        {
            [self.images addObject:[NSString stringWithFormat:@"%d_gameS", i]];
        }
    }
    return _images;
}


- (instancetype)init
{
    TNSCircleLayout *layout = [[TNSCircleLayout alloc] init];
 
    self = [super initWithCollectionViewLayout:layout ];
    if (self)
    {
        CGRect rect = CGRectMake(20, 99, screenW - 40, screenH - 104-10-100-5);
        self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        [self.collectionView setBackgroundColor:[UIColor grayColor] ];
        
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"TNSChapterChooseCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newChapterIndex:) name:@"gameChapterIndexDidChanged" object:nil];
        
    }
    return self;
}


////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.gameSentenceArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
 
    TNSChapterChooseCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
 
    UIImage *image = [UIImage imageNamed:self.images[indexPath.item]];
   
    // cell image
    cell.chapterCellImageView.frame = CGRectInset(cell.bounds, 1 , 1 );
    [cell.chapterCellImageView setImage: image];
 
    return cell;
}

#pragma mark <UICollectionViewDelegate>


// didSelectItem
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [TNDataContainer sharedDataContainer].sentenceIndex = indexPath.item;
    [collectionView cellForItemAtIndexPath:indexPath].alpha = 0.5;
    
#pragma  mark - touchViewVC
    _touchVC = [[TNTouchViewController alloc] init];
   
#pragma mark - original data source
    _touchVC.titleArray = [TNDataContainer sharedDataContainer].currentTitleArray;
    
#pragma mark - disorderArray
    NSMutableArray * temp = [TNDataContainer createDisorderArray:_touchVC.titleArray];
    _touchVC.disorderArray = [NSMutableArray arrayWithArray:temp];

    _touchVC.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroud.jpg"]];
 
// backBtn and action -- adding operation writen in touchVc
    [_touchVC.backButton addTarget:self action:@selector(backToDoorPage) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.navigationController pushViewController:_touchVC animated:YES];
    _touchVC.navigationController.navigationBarHidden = YES;
   
}


-(void)backToDoorPage
{
        [_touchVC.navigationController popViewControllerAnimated:YES];
    _touchVC.navigationController.topViewController.navigationController.navigationBarHidden = NO;
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
 
    [collectionView cellForItemAtIndexPath:indexPath].alpha = 1;
}


//-(void)newChapterIndex:(NSNotification *)notification
//{
//    NSDictionary *dict = [notification userInfo];
//    int newChapterIndex = ((NSNumber *)[dict objectForKey:@"indexPath.item"]).intValue;
//}

-(void)dealloc
{
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
