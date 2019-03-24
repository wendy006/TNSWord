//
//  TNSMenuSearchWordView.h
//  TNSWord
//
//  Created by mac on 15/8/1.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TNSMenuSearchWordViewDelegate <NSObject>
@required

 -(void)quitSearchViewPage;

@end



@interface TNSMenuSearchWordView : UIView
@property(nonatomic,weak)id <TNSMenuSearchWordViewDelegate>delegate;

-(void)PostToGetDataWithWord:(NSString *)wordToSearch;
@end
