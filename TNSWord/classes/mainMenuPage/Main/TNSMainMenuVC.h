//
//  TNSMainMenuVC.h
//  TNSWord
//
//  Created by mac on 15/7/25.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNSMainMenuVC : UIViewController
 
@property (weak, nonatomic) IBOutlet UIView *loadShanbayPageView;

@property (weak, nonatomic) IBOutlet UIImageView *loadShanbayPageView_imageView;

@property (weak, nonatomic) IBOutlet UILabel *loadShanbayPageView_loadTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *loadShanbayPageView_usernameLabel; 


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHomeViewHeight;

@end
