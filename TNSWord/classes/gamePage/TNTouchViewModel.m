//
//  TNTouchViewModel.m
//  TNGameBtnPageDemo
//
//  Created by mac on 15/7/20.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNTouchViewModel.h"

@implementation TNTouchViewModel

// no use temporarily
//-(BOOL)titleIsPunct
//{
//    NSMutableArray *currentPunctSentence = [TNDataContainer sharedDataContainer].currentTitle_PunctOnlyArray;
//    if ([ NSString  isInStringArray:currentPunctSentence testString:self.title]  )  return YES;
//    return NO;
//}


-(id)initWithTitle:(NSString *)title
{
    if (self == [super init])
    {
        self.title = title;
    }
    return self;
}


-(void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.title forKey:@"title"];
 
}


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        self.title = [aDecoder decodeObjectForKey:@"title"];
    }
    return self;
}

@end
