//
//  NSString+TNSTool.m
//  TNSWord
//
//  Created by mac on 15/8/17.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "NSString+TNSTool.h"
#import "TNChapter.h"
#import "RegexKitLite.h"

@implementation NSString (TNSTool)



//////////////////////////////////////////// Regex ////////////////////////////////////////////////

- (BOOL)match:(NSString *)pattern
{
    NSRegularExpression *regex = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    NSArray *results = [regex matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    return results.count > 0;
}


-(BOOL)isPunct
{
    return [self match:@"^[,.;?!+——\"]$"];
}


- (BOOL)isWord
{
    return [self match:@"([$]?((\b\\d{1,3}\b)[,]?)+)|\\w+|(\\w+[-,']\\w+)|([']\\w+|\\w+['])"];
}


/////////////////////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////// divi ////////////////////////////////////////////////



+ (NSMutableDictionary *)diviStringToWords:(NSString *)str

{
    
    NSMutableArray * wordArray = [NSMutableArray array];
    NSMutableArray * wordAndPunctArray = [NSMutableArray array];
    NSMutableArray * punctArray = [NSMutableArray array];
    
    NSString *digitsPattern = @"(?<=\\s)([$]?((\b\\d{1,3}\b)[,]?)+)(?=\\s)";
    NSString *wordPattern   = @"(?<=\\s)\\w+(?=\\s)";
    
    NSString *punctPattern  = @"(?<=\\s)[,.;?!+——\"](?=\\s)";
    
    NSString *specialWordpattern =@"((?<=\\s)\\w+[-,']\\w+(?=\\s)|(?<=\\s)[']\\w+(?=\\s)|(?<=\\s)\\w+['](?=\\s))";
    
    
    NSString *pattern = [NSString stringWithFormat:@"%@|%@|%@|%@",wordPattern,digitsPattern,punctPattern,specialWordpattern];
    
    [str enumerateStringsMatchedByRegex:pattern usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        
        [ wordAndPunctArray addObject:*capturedStrings];
        
        if ([*capturedStrings isPunct])
        {
            [punctArray addObject:*capturedStrings];
        }
        
        else if([*capturedStrings isWord])
        {
            
            [wordArray addObject:*capturedStrings];
        }
        
        else
        {
            NSLog(@"错误");
            return ;
        }
    }];
    
    NSMutableDictionary *wordAndPunctDict = [NSMutableDictionary dictionaryWithObjectsAndKeys:wordArray,@"wordArray",punctArray,@"punctArray",wordAndPunctArray,@"wordAndPunctArray" ,nil];
    
    return wordAndPunctDict;
    
}


+ (NSString *)clipStringForSqliteInsert:(NSString *)string
{
    NSString *temp = @"";
    NSInteger len = [string length];
    for (int i = 0; i<len; i++)
    {
        
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        
        if([s isEqualToString:@"'"])
        {
            temp = [temp stringByAppendingString:@"''"];
        }
        else
        {
            temp = [temp stringByAppendingString:s ];
        }
    }
    return temp;
}


/////////////////////////////////////////////////////////////////////////////////////////////////




//////////////////////////////////////////// time ///////////////////////////////////////////////

+ (NSString *)stringFromDate:(NSDate *)date
{
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"HH:mm MM-dd yyyy"];
    
    NSString *currentDateString = [dateFormatter stringFromDate:date];
    
    return currentDateString;
}



+(NSString *)stringFromTimeInterval:(NSTimeInterval)timeSecond
{
    
    if (timeSecond == 0)
    {
        return @"0";
    }
    
    int rawMinute = timeSecond/60;
    int second = ((int)timeSecond) % 60;
    
    if (rawMinute == 0)
    {
        return [NSString stringWithFormat:@"%ds",second];
    }
    
    int rawHour = rawMinute/60;
    int minite = rawMinute % 60;
    
    if(rawHour == 0)
    {
        return  [NSString stringWithFormat:@"%dm %ds",minite,second];
    }
    
    int rawDay = rawHour/24;
    int hour  = rawHour % 24;
    
    if(rawDay == 0)
    {
        return [NSString stringWithFormat:@"%dh %dm %ds",hour,minite,second];
    }
    
    int rawMonth = rawDay/30;
    int day = rawDay % 30;
    
    if (rawMonth == 0)
    {
        return [NSString stringWithFormat:@"%dd %dh %dm %ds",day,hour,minite,second];
    }
    
    int rawYear = rawMonth / 12;
    int month = rawMonth % 12;
    
    if ( rawYear == 0)
    {
        return [NSString stringWithFormat:@"%dM %dd %dh %dm %ds",month,day,hour,minite,second];
    }
    
    
    if ( rawYear > 0)
    {
        return [NSString stringWithFormat:@"%dY %dM %dd %dh %dm %ds",rawYear,month,day,hour,minite,second];
    }
    
    return @"error,please check!";
}


/////////////////////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////   stringContainer  //////////////////////////////////////////

+ (BOOL)hasOneOrMoreIntInString:(NSString *)string
{
    for(int i = 0; i < [string length]; ++i)
    {
        if (string.UTF8String[i]>=48 && string.UTF8String[i]<=57)
        {
            return YES;
        }
        else
        {
            continue;
        }
    }
    return NO;
}

/////////////////////////////////////////////////////////////////////////////////////////////////

@end
