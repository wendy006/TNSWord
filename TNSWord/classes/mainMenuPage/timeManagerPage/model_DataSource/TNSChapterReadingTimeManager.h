//
//  TNSChapterReadingTimeManager.h
//  TNSWord
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNSChapterReadingTimeManager : NSObject

@property(nonatomic,strong)NSString *lastReadingDate;
@property(nonatomic,strong)NSString *totalReadingTime;


/**
 *  initiate[ decode from local plist ]
 */
+(TNSChapterReadingTimeManager *)createReadingTimeManagerWithChapterIndex:(NSInteger)chapterIndex;


@end
