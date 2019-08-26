//
//  TNSHomeVC.h
//  TNSWord
//
//  Created by mac on 15/7/25.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TNSGameSentenceChooseCVC;
@class TNSGameChapterChooseCVC;
@class TNSReadingChapterChooseCVC;

@interface TNSHomeVC : UIViewController

//rootView can not be moved - since menuView is added to rootView,otherwise menuView can not handle event
@property (weak, nonatomic) IBOutlet UIView *baseView;
@property(nonatomic,strong) NSMutableArray *chapters;
@property (weak, nonatomic) IBOutlet UILabel *chapterShowLabel;


 
@property(nonatomic,strong)TNSGameSentenceChooseCVC *gameSentenceChooseCVC;
@property(nonatomic,strong)TNSReadingChapterChooseCVC *readingChapterChooseCVC;
@property(nonatomic,strong)TNSGameChapterChooseCVC *gameChapterChooseCVC;


@end
