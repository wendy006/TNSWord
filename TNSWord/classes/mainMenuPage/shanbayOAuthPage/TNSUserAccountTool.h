//
//  TNSUserAccountTool.h
//  TNSWord
//
//  Created by mac on 15/8/1.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TNAccount;
@interface TNSUserAccountTool : NSObject

/**
 *  encode
 */
+ (void)saveAccount:(TNAccount *)account;

/**
 *  decode
 */
+ (TNAccount *)account;



@end
