//
//  TNSReadingPageVC.h
//  TNSWord
//
//  Created by mac on 15/7/28.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNSReadingPageVC : UIViewController
@property(nonatomic,strong)NSMutableArray *chapters;
@property(nonatomic,assign)CGPoint offsetForTextView;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (strong, nonatomic)NSString *wordToSearch;
@property (assign, nonatomic)NSRange wordToSearchRange;

@end
