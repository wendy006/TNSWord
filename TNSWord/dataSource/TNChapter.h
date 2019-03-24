//
//  TNChapter.h
//  TNWord
//
//  Created by mac on 15/6/12.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNChapter : NSObject<NSCoding>

@property(nonatomic,assign)double ID;
@property(nonatomic,strong)NSString *number;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *translation;

@property(nonatomic,strong)NSMutableArray *contentSentences;
@property(nonatomic,strong)NSMutableArray *translationSentences;

@property(nonatomic,strong)NSString *content_for_reading;
@property(nonatomic,strong)NSString *chinese_title;
@end
