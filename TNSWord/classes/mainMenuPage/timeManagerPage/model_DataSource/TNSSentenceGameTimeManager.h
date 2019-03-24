//
//  TNSSentenceGameTimeManager.h
//  TNSWord
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNSSentenceGameTimeManager : NSObject

@property(nonatomic,strong)NSString *lastSuccessDate;



+(TNSSentenceGameTimeManager *)createSentenceTimeManagerWithChapterIndex:(NSInteger)ChapterIndex AndSentenceIndex:(NSInteger)sentenceIndex;

@end
