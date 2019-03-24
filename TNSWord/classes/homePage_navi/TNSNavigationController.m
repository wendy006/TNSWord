//
//  TNSNavigationController.m
//  TNSWord
//
//  Created by mac on 15/8/3.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSNavigationController.h"
 
#import "TNSGameChapterChooseCVC.h"
#import "TNSGameSentenceChooseCVC.h"
#import "TNSReadingChapterChooseCVC.h"

#import "TNSHomeVC.h"

@interface TNSNavigationController ()

@end

@implementation TNSNavigationController



+(void)initialize
{
    // bar 's appearance overall
    UINavigationBar *naviBar = [UINavigationBar appearance];
    naviBar.tintColor =  [UIColor grayColor];
}


#pragma mark - open userInteration when pop to homeVC
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    
    NSInteger  indexOfHomeVC = [self indexOfKindOfController:[TNSHomeVC class]];

    
    if (NSNotFound != indexOfHomeVC)
    {
      
        TNSHomeVC *homeVC = self.viewControllers[indexOfHomeVC];
        if (homeVC.gameChapterChooseCVC.collectionView.userInteractionEnabled == NO)
        {
            homeVC.gameChapterChooseCVC.collectionView.userInteractionEnabled =  YES;
        }
        if (homeVC.gameSentenceChooseCVC.collectionView.userInteractionEnabled == NO)
        {
            homeVC.gameSentenceChooseCVC.collectionView.userInteractionEnabled =  YES;
        }
        if (homeVC.readingChapterChooseCVC.collectionView.userInteractionEnabled == NO)
        {
            homeVC.readingChapterChooseCVC.collectionView.userInteractionEnabled =  YES;
        }
        
    }
    
     [super pushViewController:viewController animated:YES];
}


/**
 *  found the specific VC/CVC class[or even customized VC/CVC class],then return the first index
 */
-(NSInteger)indexOfKindOfController:(Class )class
{
    
    for (int i =0;i <self.childViewControllers.count ; i++ )
    {
        if ([self.childViewControllers[i] isKindOfClass:[class class] ])
        {
            return i;
        }
    
    }
    return NSNotFound;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}
 

@end
