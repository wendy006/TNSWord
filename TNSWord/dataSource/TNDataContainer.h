//
//  TNDataContainer.h(单例类）
//  TNDrawing
//
//  Created by mac on 15/7/18.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"
@class TNChapter;

@interface TNDataContainer : NSObject


SingletonH(DataContainer)


@property(nonatomic,strong)NSMutableArray * chapters;
@property(nonatomic,assign)NSInteger chapterIndex;
@property(nonatomic,assign)NSInteger sentenceIndex;

@property(nonatomic,assign)NSInteger totalChapterCount;
@property(nonatomic,assign)NSInteger totalSentenceCount;

@property(nonatomic,strong)NSMutableArray *currentTitleArray ;
@property(nonatomic,strong)NSMutableArray *currentTitle_PunctOnlyArray;// little use
@property(nonatomic,strong)NSMutableArray *currentTitle_WordOnlyArray;

//for game
@property(nonatomic,strong)NSMutableArray *disorderArray;
@property(nonatomic,assign)NSInteger rightWordCount;//scoreLabel
@property(nonatomic,assign)NSInteger lastRightWordCount;//scoreLabel

//timeManager
@property(nonatomic,assign) NSInteger timeManagerTBVChapterIndex;

//shanbay
@property(nonatomic,strong)NSString *wordToSearch;
@property(nonatomic,assign)BOOL didOAuthorized;




+(NSMutableArray *)createDisorderArray:(NSMutableArray *)originArray;

-(TNChapter *)chapterWithChapterIndex:(NSInteger)chapterIndex;

-(NSMutableArray *)enSentenceArrayInChapterWithIndex:(NSInteger)chapterIndex;
-(NSMutableArray *)cnSentenceArrayInChapterWithIndex:(NSInteger)chapterIndex;

-(NSString *)enCurrentSentenceWithIndex:(NSInteger)sentenceIndex AndChapterIndex:(NSInteger)chapterIndex;
-(NSString *)cnCurrentSentenceWithIndex:(NSInteger)sentenceIndex AndChapterIndex:(NSInteger)chapterIndex;


@end
