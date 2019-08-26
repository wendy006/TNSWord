//
//  TNSHomeVC.m
//  TNSWord
//
//  Created by mac on 15/7/25.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSHomeVC.h"
#import "TNSMainMenuVC.h"
#import "FMDB.h"
#import "TNChapter.h"
#import "TNSReadingChapterChooseCVC.h"

#import "TNSUserAccountTool.h"

#import "TNSGameChapterChooseCVC.h"
#import "TNSGameSentenceChooseCVC.h"
#import "TNWordBookTableViewController.h"
#import "UIImageView+WebCache.h"// SDWebImage
 


@interface TNSHomeVC ()


@property(nonatomic,strong)FMDatabase *db;
@property (weak, nonatomic) IBOutlet UISegmentedControl *readAndGamePageSwitch;
@property(nonatomic,strong) TNSMainMenuVC *mainMenuVC;
@end

@implementation TNSHomeVC

-(TNSReadingChapterChooseCVC *)readingChapterChooseCVC
{
    if (_readingChapterChooseCVC == nil)
    {
        _readingChapterChooseCVC = [[TNSReadingChapterChooseCVC alloc] init ];
    }
    return _readingChapterChooseCVC;
}

-(TNSGameChapterChooseCVC *)gameChapterChooseCVC
{
    if (_gameChapterChooseCVC == nil)
    {
        _gameChapterChooseCVC = [[TNSGameChapterChooseCVC alloc] init ];
    }
    return _gameChapterChooseCVC;
}

-(TNSGameSentenceChooseCVC *)gameSentenceChooseCVC
{
    if (_gameSentenceChooseCVC == nil)
    {
        _gameSentenceChooseCVC = [[TNSGameSentenceChooseCVC alloc] init ];
    }
    return _gameSentenceChooseCVC;
}


-(TNSMainMenuVC *)mainMenuVC
{
    if (_mainMenuVC == nil)
    {
       _mainMenuVC = [[TNSMainMenuVC alloc] initWithNibName:@"TNSMainMenuVC" bundle:nil];
 
    }
    
    return _mainMenuVC;
}

-(NSMutableArray *)chapters
{
    if (!_chapters) {
        _chapters = [[NSMutableArray alloc] init];
    }
    return _chapters;
}


 ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// ///// /////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#pragma mark - setupDatabase - inject data into Singleton and TNChapter class
 
    [self setupDataBase];
    
#pragma mark - initiate timeStore
    [self initiateTimeStore];
    
 
//    [self.mainMenuVC.view addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:nil];

#pragma mark -  game && read switch

    [_readAndGamePageSwitch addTarget:self action:@selector(readAndGamePageSwitch:)  forControlEvents:UIControlEventValueChanged];
    _readAndGamePageSwitch.selectedSegmentIndex = 0;
    
// call manually when first turn to homePage
    [self readAndGamePageSwitch:_readAndGamePageSwitch ];
    self.baseView. backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroud.jpg"]];

    
}



-(void)readAndGamePageSwitch:(UISegmentedControl *)seg
{
    NSInteger segIndex = seg.selectedSegmentIndex;
    switch (segIndex)
    {
        case 0:
        {
          
#pragma mark - chapter selection in reading part
           
            if([self.gameChapterChooseCVC.collectionView isDescendantOfView:self.view])
            {
                [self.gameChapterChooseCVC.collectionView removeFromSuperview];
                [self.gameChapterChooseCVC removeFromParentViewController];
                
                self.gameChapterChooseCVC = NULL;
                
                [self.gameSentenceChooseCVC removeFromParentViewController];
                [self.gameSentenceChooseCVC.collectionView removeFromSuperview];
                self.gameSentenceChooseCVC = NULL;
                
            }
            
            [TNDataContainer sharedDataContainer].chapterIndex = -1;
            
            self.chapterShowLabel.hidden = YES;//先把label给隐藏掉，这个reading界面没用到他
            [self.baseView addSubview:self.readingChapterChooseCVC.collectionView];

            CGRect rect = CGRectMake(20, 84, screenW - 40, screenH - 104);
            [self.readingChapterChooseCVC.collectionView setFrame:rect ];
            self.baseView. backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroud.jpg"]];

            [self addChildViewController:self.readingChapterChooseCVC ];
            [self. readingChapterChooseCVC  didMoveToParentViewController:self ];
            
            break;
        }
            
#pragma mark - chapter && sentence selection in game part
 
        case 1:
        {
             if([self.readingChapterChooseCVC.collectionView isDescendantOfView:self.view])
            {
                //remove the former VC
                [self.readingChapterChooseCVC  removeFromParentViewController];
                [self.readingChapterChooseCVC.collectionView removeFromSuperview];
                self.readingChapterChooseCVC = NULL;
            }
            
            [TNDataContainer sharedDataContainer].chapterIndex = -1;
            
            //show label  in game selection page
            self.chapterShowLabel.hidden = NO;
            [self.baseView addSubview:self. gameChapterChooseCVC.collectionView];
            
            CGRect rect = CGRectMake(20, 84, screenW - 40, 100);
            [self.gameChapterChooseCVC.collectionView setFrame:rect ];
            self.baseView. backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroud.jpg"]];

            [self addChildViewController:self. gameChapterChooseCVC ];
            [self. gameChapterChooseCVC  didMoveToParentViewController:self ];

            
// default selection is the first chapter(game selec page)
            [self.gameChapterChooseCVC defaultSelectFirstChapter];
        
 
            break;
        }
            
        default:
            break;
    }
}

#pragma mark - inject sqlite data into TNChapter class, then write the cn and en sentenceArray into local plist

-(void)setupDataBase
{
    
    NSString *fileName = [[NSBundle mainBundle] pathForResource:@"dataStore" ofType:@"sqlite"];
    _db = [FMDatabase databaseWithPath:fileName];
    
    
    if ([_db open])
    {
        
        NSLog(@"open successfully");
  
        NSString *sql = @"SELECT ID ,number,title,content,translation,content_for_reading,chinese_title FROM t_store;";
        
        // result set
        FMResultSet *set = [_db executeQuery:sql];
        
        // traverse
        NSMutableArray *sentencesArray = [[NSMutableArray alloc] init];
        while(set.next)
        {
            TNChapter *chapter =[[TNChapter alloc] init];
            
            
            chapter.ID = [set stringForColumn:@"ID"].doubleValue;
           
            chapter.number = [set stringForColumn:@"number"];
            
            chapter.title = [set stringForColumn:@"title"];
            
            chapter.content = [set stringForColumn:@"content"];
            
            chapter.translation = [set stringForColumn:@"translation"];
            
            chapter.content_for_reading = [set stringForColumn:@"content_for_reading"];
            
            chapter.chinese_title = [set stringForColumn:@"chinese_title"];
 
            NSMutableDictionary *sentencesDict = [NSMutableDictionary dictionary];
            [sentencesDict setObject:chapter.contentSentences forKey:@"contentSentences"];
            [sentencesDict setObject:chapter.translationSentences forKey:@"translationSentences"];
            
      
            [self.chapters addObject:chapter];
            
            
            //ready to write into local plist [array to plist]
            [sentencesArray addObject:sentencesDict];
        }
        
        //save to Singleton
        [TNDataContainer sharedDataContainer].chapters = self.chapters;
        
#warning NSKeyedArchiver -- useless temporarily
        [NSKeyedArchiver archiveRootObject:self toFile:[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"chapters.archive" ]];
       
//write to file
        
        [sentencesArray writeToFile:sentencesPath atomically:YES];
    }
    
}

/**
 *  initiate timeManager when first launch app
 */
-(void)initiateTimeStore
{
 
    // first launch
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] ) return;
    
 
// 1.for reading
    NSMutableArray * readingChapterAT = [NSMutableArray array];
    for (int chapterIndex = 0 ; chapterIndex < [TNDataContainer sharedDataContainer].chapters.count; chapterIndex++)
    {
  
        NSNumber *didReadChapter = [NSNumber numberWithBool:NO];
        
        
        NSDate * date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate * startDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        
        
        NSDate * date2 = [NSDate date];
        NSTimeInterval sec2 = [date2 timeIntervalSinceNow];
        NSDate * endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec2];
        
        NSNumber *totalTime = [NSNumber numberWithDouble:0.0];
    
        NSMutableDictionary *readingChapterDT = [NSMutableDictionary dictionaryWithObjectsAndKeys:startDate,@"startDate",endDate,@"endDate",totalTime,@"totalTime",didReadChapter,@"didReadChapter", nil];
        
        [readingChapterAT addObject:readingChapterDT];
        
        
    }
    [readingChapterAT writeToFile:readingChapterATPath atomically:YES];
    
 
// 2. for game
    NSMutableArray * gameChapterAT = [NSMutableArray array];
 
    for (int chapterIndex = 0 ; chapterIndex < [TNDataContainer sharedDataContainer].chapters.count; chapterIndex++)
    {
        
        NSMutableArray *gameSentenceAT = [NSMutableArray array];
        
        
        for (int sentenceIndex = 0 ; sentenceIndex < ([[TNDataContainer sharedDataContainer] enSentenceArrayInChapterWithIndex:chapterIndex]).count; sentenceIndex ++ )
        {
            
           
            NSNumber *didSuccess = [NSNumber numberWithBool:NO];
 
            NSDate * date = [NSDate date];
            NSTimeInterval sec = [date timeIntervalSinceNow];
            NSDate * lastSuccessDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
            
            
            NSMutableDictionary *gameSentenceDT = [NSMutableDictionary dictionaryWithObjectsAndKeys:lastSuccessDate,@"lastSuccessDate", didSuccess,@"didSuccess",  nil];
            
            [gameSentenceAT addObject:gameSentenceDT];
        }
        
        [gameChapterAT addObject:gameSentenceAT];
        
    }
 
     [gameChapterAT writeToFile:gameChapterATPath atomically:YES];
    
 

}

#pragma mark  open main menu - come from left

- (IBAction)openMainMenuPage:(id)sender
{
      if( NSNotFound != [self.view.subviews indexOfObject:self.mainMenuVC.view] )
    {
        // enable homeVC's userInteraction
        [self setReadingOrGameChoosingPageInteractionEnabled:YES];
   
        self.mainMenuVC.view.frame = CGRectMake(-menuWidth, 0, menuWidth, screenH);
        [self.mainMenuVC.view removeFromSuperview];
        
        self.navigationController.navigationBar.frame = CGRectMake(0, 20, screenW, 44);
        self.baseView.frame = CGRectMake(0, 0, screenW , screenH);
        
        // not very helpful - can be polished
        [UIView setAnimationsEnabled:YES];
        return;
    }
    
    // shanbay load handling stuff (switch) -- [TNSUserAccountTool account] should not be nil
    
    if([TNSUserAccountTool account])
    {
        self.mainMenuVC.loadShanbayPageView_loadTitleLabel.text = @"退出登录";
        self.mainMenuVC.loadShanbayPageView_usernameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey: @"username"] ;
        NSString *userPhotoUrl = [[NSUserDefaults standardUserDefaults] objectForKey:@"userPhotoUrl"];
        
        
#warning  - change user profile 【 SDWebImage - may have some delay..】
        [ self.mainMenuVC.loadShanbayPageView_imageView  sd_setImageWithURL:[NSURL URLWithString:userPhotoUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
            UIImage *newImage = [UIImage circleImageWithImage:image borderWidth:5 borderColor:TNColor(108, 120, 128) ];
            
            [self.mainMenuVC.loadShanbayPageView_imageView  mas_remakeConstraints:^(MASConstraintMaker *make) {
                
                CGFloat  width = self.mainMenuVC.menuHomeViewHeight.constant;
                make.width.equalTo( [NSNumber numberWithFloat: width/3*2]);
                make.height.equalTo( [NSNumber numberWithFloat: width/3*2]);
            }];
            [self.mainMenuVC.loadShanbayPageView_imageView setImage: newImage];

            
        }];
        
    }
    
    else
    {
        self.mainMenuVC.loadShanbayPageView_loadTitleLabel.text = @"登录";
        self.mainMenuVC.loadShanbayPageView_usernameLabel.text = @"Welcome" ;
         
        [self.mainMenuVC.loadShanbayPageView_imageView setImage:[UIImage imageNamed:@"loadShanbay.png"]];//设置image
        
    }
    
   
    
   // disable homeVC's userInteraction when mainMenu is open
    [self setReadingOrGameChoosingPageInteractionEnabled:NO];

    self.navigationController.navigationBar.frame = CGRectMake(menuWidth, 20, screenW, 44);
    self.baseView.frame = CGRectMake(menuWidth, 0, screenW , screenH);
 
    // can be polished
    self.mainMenuVC.view.frame = CGRectMake(0, 0, menuWidth, screenH);
 
    [self.view addSubview:self.mainMenuVC.view];
    [self addChildViewController:self.mainMenuVC ];
    [self.mainMenuVC  didMoveToParentViewController:self ];
 
    [UIView setAnimationsEnabled:YES];
    
   
    
}





/**
 *  control userInteraction when menuVC appear or disappear
 */
-(void)setReadingOrGameChoosingPageInteractionEnabled:(BOOL)enabled
{
 
    if (NSNotFound != [self.childViewControllers indexOfObject:_gameChapterChooseCVC])
    {
        _gameChapterChooseCVC.collectionView.userInteractionEnabled = enabled;
        _gameSentenceChooseCVC.collectionView.userInteractionEnabled = enabled;
    }
     if (NSNotFound != [self.childViewControllers indexOfObject:_readingChapterChooseCVC])
    {
        _readingChapterChooseCVC.collectionView.userInteractionEnabled = enabled;
    }
}



- (IBAction)openWordBook:(id)sender
{
    TNWordBookTableViewController *wordBookTableVC = [[TNWordBookTableViewController alloc] init];
    [self.navigationController pushViewController:wordBookTableVC animated:YES];
    
    wordBookTableVC.navigationItem.title = @"单词本";
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
//    [self.mainMenuVC.view removeObserver:self forKeyPath:@"frame"];
}

//-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
//{
//    CGPoint point = [[change objectForKey:@"new"] CGRectValue].origin;
//}

@end
