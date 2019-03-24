//
//  TNChapter.m
//  TNWord
//
//  Created by mac on 15/6/12.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNChapter.h"
#import "FMDB.h"
@interface TNChapter()
@property(nonatomic,strong)FMDatabase *db;

@end

@implementation TNChapter


-(NSMutableArray *)contentSentences
{
    if (_contentSentences==nil) {
        _contentSentences = [[NSMutableArray alloc] init];
       _contentSentences =  [self seperateParasIntoSentences:self.content by:@"."];
        
    }
    return _contentSentences;
}


-(NSMutableArray *)translationSentences
{
    if (_translationSentences==nil) {
        _translationSentences = [[NSMutableArray alloc] init];
        
       _translationSentences = [self seperateParasIntoSentences:self.translation by:@"。"];
        
    }
    return _translationSentences;
}


-(NSMutableArray *)seperateParasIntoSentences:(NSString *)ObjectToBeSeperated by:(NSString *)seperator
{
    NSMutableArray *sentences = (NSMutableArray *)[ObjectToBeSeperated componentsSeparatedByString:seperator];
    
    NSInteger count = sentences.count;
    for (int i=0; i<count; i++)
    {
        NSString * appendingStr = [NSString stringWithFormat:@"%@ ",seperator];
        [sentences replaceObjectAtIndex:i withObject:[[sentences objectAtIndex:i] stringByAppendingString:appendingStr] ];
    }
    [sentences removeLastObject];
    return sentences;
}



-(void)encodeWithCoder:(NSCoder *)aCoder
{
     [aCoder encodeInt:self.ID forKey:@"ID"];
     [aCoder encodeObject:self.number forKey:@"number"];
     [aCoder encodeObject:self.title forKey:@"title"];
     [aCoder encodeObject:self.translation forKey:@"translation"];
     [aCoder encodeObject:self.translationSentences forKey:@"translationSentences"];
     [aCoder encodeObject:self.content forKey:@"content"];
     [aCoder encodeObject:self.contentSentences forKey:@"contentSentences"];
}

 
-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.ID = [aDecoder decodeIntForKey:@"ID"];
        self.number = [aDecoder decodeObjectForKey:@"number"];
        self.title = [aDecoder decodeObjectForKey:@"title"];
        self.translation = [aDecoder decodeObjectForKey:@"translation"];
        self.translationSentences = [aDecoder decodeObjectForKey:@"translationSentences"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.contentSentences = [aDecoder decodeObjectForKey:@"contentSentences"];

    }
    return self;
}

@end
