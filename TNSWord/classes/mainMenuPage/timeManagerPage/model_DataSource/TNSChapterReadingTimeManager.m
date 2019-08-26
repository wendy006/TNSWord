//
//  TNSChapterReadingTimeManager.m
//  TNSWord
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSChapterReadingTimeManager.h"
//#import "TNStringTool.h"

@implementation TNSChapterReadingTimeManager

#pragma mark - initiate[ decode from local plist ]
+(TNSChapterReadingTimeManager *)createReadingTimeManagerWithChapterIndex:(NSInteger)chapterIndex
{
    
    NSMutableArray *array =  [NSMutableArray arrayWithContentsOfFile:readingChapterATPath];
    NSMutableDictionary *dict = array[chapterIndex];
    
    TNSChapterReadingTimeManager *manager = [[TNSChapterReadingTimeManager alloc] init];
    
    // lastReadingDate to string
    // should actually have read
    if ([dict[@"didReadChapter"] boolValue])
    {
        NSDate *lastReadingDate = dict[@"endDate"];
        manager.lastReadingDate = [NSString stringFromDate:lastReadingDate];
        
        NSTimeInterval totalTime = [dict[@"totalTime"] doubleValue];
        manager.totalReadingTime = [NSString stringFromTimeInterval:totalTime];
        
    }
    
    else
    {
        manager.lastReadingDate = @"";
        manager.totalReadingTime= @"";
    }
    
    return manager;
}


@end
