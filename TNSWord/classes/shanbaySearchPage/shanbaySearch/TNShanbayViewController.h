//
//  TNShanbayViewController.h
//  TNWord
//
//  Created by mac on 15/6/20.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TNShanbayVCGetButtonInfoDelegate <NSObject>
-(UIButton *)getCurrentPressedBtn;
@end


@interface TNShanbayViewController : UIViewController

@property(nonatomic,strong) NSString *wordToSearch;
@property(nonatomic,  weak) id<TNShanbayVCGetButtonInfoDelegate>delegate;

-(void)PostToGetDataWithWord:(NSString *)wordToSearch;
@end
