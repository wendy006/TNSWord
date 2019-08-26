//
//  TNAccount.h
//  testWithStoryboard
//
//  Created by mac on 15/6/11.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface TNAccount : NSObject <NSCoding>

@property (nonatomic, copy) NSString *access_token;

@property (nonatomic, copy) NSNumber *expires_in;
 
@property (nonatomic, copy) NSString *refresh_token;
@property (nonatomic, copy) NSString *scope;
@property (nonatomic, copy) NSString *token_type;


+ (instancetype)accountWithDict:(NSDictionary *)dict;
@end

