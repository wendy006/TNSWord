//
//  TNWordInfo.h
//  TNWord
//
//  Created by mac on 15/6/23.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNWordInfo : NSObject

 
@property(nonatomic,strong)NSString *word;

@property(nonatomic,strong)NSString *pronunciation;

@property(nonatomic,strong)NSString *cnDefinition;

@property(nonatomic,strong)NSString *enDefinition;

@property(nonatomic,strong)NSString *localAudionUrl;

@property(nonatomic,strong)NSString * isEasyWord;


@end
