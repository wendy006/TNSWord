//
//  TNTouchView.h
//  TNGameBtnPageDemo
//
//  Created by mac on 15/7/20.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TNTouchViewModel;
@interface TNTouchView : UIImageView

//data
@property(nonatomic,assign) NSInteger sign;
@property(nonatomic,strong) NSMutableArray *array;
@property(nonatomic,strong) NSMutableArray *viewArray11;
@property(nonatomic,strong) NSMutableArray *viewArray22;
@property(nonatomic,strong) NSMutableArray *titleArray;
@property(nonatomic,strong) TNTouchViewModel *touchViewModel;

//UI
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UILabel *moreChannelsLabel;

//little use
@property(nonatomic,assign) CGPoint point;
@property(nonatomic,assign) CGPoint point2;

@end
