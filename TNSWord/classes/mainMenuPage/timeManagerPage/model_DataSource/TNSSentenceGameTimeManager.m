//
//  TNSSentenceGameTimeManager.m
//  TNSWord
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSSentenceGameTimeManager.h"
//#import "TNStringTool.h"

@implementation TNSSentenceGameTimeManager


#pragma mark - initiate[ decode from local plist ]
+(TNSSentenceGameTimeManager *)createSentenceTimeManagerWithChapterIndex:(NSInteger)ChapterIndex AndSentenceIndex:(NSInteger)sentenceIndex
{
    
    
    NSMutableArray * arrayChapter = [NSMutableArray arrayWithContentsOfFile:gameChapterATPath];
    
    NSMutableArray * arraySentence = [arrayChapter objectAtIndex: ChapterIndex ];
 
    NSMutableDictionary *currentSentenceDict = [arraySentence objectAtIndex: sentenceIndex ];

    TNSSentenceGameTimeManager *manager = [[TNSSentenceGameTimeManager alloc] init];
    
    //should actually have played
    if ([currentSentenceDict[@"didSuccess"] boolValue])
    {
        //date to string
        NSString *lastSuccessDate =  [NSString stringFromDate:currentSentenceDict[@"lastSuccessDate"]]  ;
        manager.lastSuccessDate = lastSuccessDate;
    }
    else
    {
        manager.lastSuccessDate = @"";
    }
    
    return manager;
}


@end
