//
//  TNDataContainer.m
//  TNDrawing
//
//  Created by mac on 15/7/18.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNDataContainer.h"
#import "TNChapter.h"
//#import "TNStringTool.h"


@implementation TNDataContainer
SingletonM(DataContainer)


-(NSInteger)totalChapterCount
{
    if (_totalSentenceCount == 0)
    {
        return self.chapters.count;
    }
    return _totalSentenceCount;
}



-(NSInteger)totalSentenceCount
{
    if (_totalSentenceCount == 0)
    {
        
        _totalSentenceCount = 0;
        for(int i = 0; i < _totalChapterCount;i++)
        {
            _totalSentenceCount += [self enSentenceArrayInChapterWithIndex:i].count;
        }
       
    }
    return _totalSentenceCount;
}


-(NSMutableArray *)currentTitleArray
{
    
    if (_currentTitleArray == nil)
    {
        _currentTitleArray = [NSMutableArray array];
        _currentTitle_PunctOnlyArray = [NSMutableArray array];
        _currentTitle_WordOnlyArray = [NSMutableArray array];
    }
 
        NSString *currentEnSentence = [self enCurrentSentenceWithIndex:self.sentenceIndex AndChapterIndex:self.chapterIndex];
        NSMutableDictionary *dict = [NSString diviStringToWords: currentEnSentence];
            
        _currentTitleArray = [dict objectForKey:@"wordAndPunctArray"];
        _currentTitle_PunctOnlyArray = [dict objectForKey:@"punctArray"];
        _currentTitle_WordOnlyArray = [dict objectForKey:@"wordArray"];
 
        return _currentTitleArray ;
}



+ (NSMutableArray *)createDisorderArray:(NSMutableArray *)originArray
{
    NSMutableArray *randomArray = [NSMutableArray array];
    NSMutableArray *tempArray = [NSMutableArray arrayWithArray:originArray];
    
    [randomArray addObject:tempArray[0]];
    [tempArray removeObjectAtIndex:0];
 
    while(tempArray.count)
    {
        int randomIndex =  arc4random() % (tempArray.count ) ;
        [randomArray addObject:tempArray[randomIndex]];
        [tempArray removeObjectAtIndex:randomIndex];
 
    }
     return randomArray;
}


 -(TNChapter *)chapterWithChapterIndex:(NSInteger)chapterIndex
{
    if (self.chapters.count == 0)
    {
        NSLog(@"chapterWithChapterIndex没有数据");
        return 0;
    }
    return ((TNChapter *)(((self.chapters)[chapterIndex])));
}


-(NSMutableArray *)enSentenceArrayInChapterWithIndex:(NSInteger)chapterIndex
{
   return  [self chapterWithChapterIndex:chapterIndex].contentSentences;
    
}

-(NSMutableArray *)cnSentenceArrayInChapterWithIndex:(NSInteger)chapterIndex
{
    return  [self chapterWithChapterIndex:chapterIndex].translationSentences;
}



-(NSString *)enCurrentSentenceWithIndex:(NSInteger)sentenceIndex AndChapterIndex:(NSInteger)chapterIndex
{
    return [self enSentenceArrayInChapterWithIndex:chapterIndex][sentenceIndex];
}



-(NSString *)cnCurrentSentenceWithIndex:(NSInteger)sentenceIndex AndChapterIndex:(NSInteger)chapterIndex
{
    return [self cnSentenceArrayInChapterWithIndex:chapterIndex][sentenceIndex];
}


@end
