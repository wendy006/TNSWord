//
//  TNTouchViewModel.h
//  TNGameBtnPageDemo
//
//  Created by mac on 15/7/20.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TNTouchViewModel : NSObject

@property(nonatomic,strong)NSString *title;
//@property(nonatomic,assign)BOOL titleIsPunct;// no use temporarily

//init
-(id)initWithTitle:(NSString *)title ;

@end
