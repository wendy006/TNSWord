//
//  TNAccount.m
//  testWithStoryboard
//
//  Created by mac on 15/6/11.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNAccount.h"

@implementation TNAccount


+ (instancetype)accountWithDict:(NSDictionary *)dict
{
    TNAccount *account = [[self alloc] init];
    account.access_token = dict[@"access_token"];
 
    account.expires_in = dict[@"expires_in"];
    account.refresh_token = dict[@"refresh_token"];
 
#warning  may have potential bug ?
    account.scope = dict[@"scope"];
    account.token_type = dict[@"token_type"];
    
    return account;
}

/**
 *   encode
 */
- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.access_token forKey:@"access_token"];
    [encoder encodeObject:self.expires_in forKey:@"expires_in"];
    [encoder encodeObject:self.refresh_token forKey:@"refresh_token"];
 
    [encoder encodeObject:self.scope forKey:@"scope"];
    [encoder encodeObject:self.token_type forKey:@"token_type"];
 
}

/**
 *   decode
 */
- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.access_token = [decoder decodeObjectForKey:@"access_token"];
        self.expires_in = [decoder decodeObjectForKey:@"expires_in"];
        self.refresh_token = [decoder decodeObjectForKey:@"refresh_token"];
 
        self.scope = [decoder decodeObjectForKey:@"scope"];
        self.token_type = [decoder decodeObjectForKey:@"token_type"];
 
    }
    return self;
}

@end
