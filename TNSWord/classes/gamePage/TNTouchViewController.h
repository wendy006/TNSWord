//
//  TNTouchViewController.h
//  TNGameBtnPageDemo
//
//  Created by mac on 15/7/20.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNTouchViewController : UIViewController

//data
@property(nonatomic,strong)NSMutableArray *modelArray1;
@property(nonatomic,strong)NSMutableArray *modelArray2;

@property(nonatomic,strong)NSMutableArray *viewArray1;
@property(nonatomic,strong)NSMutableArray *viewArray2;

@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *disorderArray;

//UI
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UILabel *titleLabel2;
@property(nonatomic,strong)UIButton *backButton;
@property(nonatomic,strong)UILabel *scoreLabel;


@end
