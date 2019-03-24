//
//  NSString+TNSTool.h
//  TNSWord
//
//  Created by mac on 15/8/17.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TNSTool)

//@property(nonatomic,strong) NSMutableArray *chapters;
//@property(nonatomic,assign) double sentenceIndex;
//@property(nonatomic,assign) double chapterIndex;
//@property(nonatomic,assign) int currentWordIndex;

//time
+ (NSString *)stringFromTimeInterval:(NSTimeInterval)timeSecond;
+ (NSString *)stringFromDate:(NSDate *)date;

//divi
+ (NSMutableDictionary *)diviStringToWords:(NSString *)str;
+ (NSString *)clipStringForSqliteInsert:(NSString *)string;

//stringContainer
+ (BOOL)hasOneOrMoreIntInString:(NSString *)string;


@end
