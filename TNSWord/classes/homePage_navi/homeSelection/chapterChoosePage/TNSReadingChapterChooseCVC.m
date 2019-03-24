//
//  TNSReadingChapterChooseCVC.m
//  TNSWord
//
//  Created by mac on 15/7/26.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSReadingChapterChooseCVC.h"
#import "TNSChapterChooseCollectionCell.h"
#import "TNSCollectionViewFlowLayout.h"
 

#import "TNSReadingPageVC.h"
#import "TNChapter.h"

@interface TNSReadingChapterChooseCVC ()<MBProgressHUDDelegate>
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation TNSReadingChapterChooseCVC

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
    if (!_images)
    {
        self.images = [[NSMutableArray alloc] init];
        
        for (int i = 0; i < [TNDataContainer sharedDataContainer].chapters.count; i++)
        {
            [self.images addObject:[NSString stringWithFormat:@"%d_readC", i]];
        }
    }
    return _images;
}

- (instancetype)init
{
    TNSCollectionViewFlowLayout *layout = [[TNSCollectionViewFlowLayout alloc] init];
 
    self = [super initWithCollectionViewLayout:layout ];
    if (self)
    {
        CGRect rect = CGRectMake(20, 84, screenW - 40, screenH - 104);
        self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
        
        self.collectionView.layer.cornerRadius = self.collectionView.width * 0.1;
        self.collectionView.backgroundColor = TNColor(128,128,128);
 
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"TNSChapterChooseCollectionCell" bundle:nil] forCellWithReuseIdentifier:reuseIdentifier];

    }
    return self;
}


/////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
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

    cell.chapterCellImageView.frame = CGRectInset(cell.bounds, 1 , 1 );
    
    [cell.chapterCellImageView setImage: image];
    
    // curve
    cell.layer.cornerRadius = image.size.height * 0.2;
    
    return cell;
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    [TNDataContainer sharedDataContainer].chapterIndex = indexPath.item;
  
    
    //++++++++show the title of chapter  -- delay 1.5sec++++++++++++++++++++++++++++++++
    NSString *currentChapterTitle = ((TNChapter *)(([TNDataContainer sharedDataContainer].chapters)[indexPath.item])).title;
    UIWindow* mainWindow = ([[UIApplication sharedApplication] delegate]).window;
    MBProgressHUD *hud = [MBProgressHUD showMessage:currentChapterTitle toView:mainWindow];
    hud.delegate = self;
    hud.mode = MBProgressHUDModeText;
    hud.labelColor = [UIColor orangeColor];
    hud.alpha = 0.7;
    [hud hide:YES afterDelay:1];
    //+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    
#pragma mark - TNSReadingPageVC
    TNSReadingPageVC *readingPageVC = [[TNSReadingPageVC alloc] initWithNibName:@"TNSReadingPageVC" bundle:nil];
    
    [self.navigationController pushViewController:readingPageVC animated:YES];
 

#pragma mark - timeManager [data store]
    
    // current time
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    // userDefault
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:readingChapterATPath];
    NSMutableDictionary *dict = array[indexPath.item];
    
    dict[@"startDate"] = startDate;

    [array writeToFile:readingChapterATPath atomically:YES];
    
    
}


- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView cellForItemAtIndexPath:indexPath].alpha = 1;
}

 

@end
