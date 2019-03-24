//
//  TNSGameChapterChooseCVC.h
//  TNSWord
//
//  Created by mac on 15/7/26.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNSGameChapterChooseCVC : UICollectionViewController

@property (nonatomic, strong) NSMutableArray *images;
@property(nonatomic,strong)NSMutableArray *chapters;


-(void)defaultSelectFirstChapter;
@end
