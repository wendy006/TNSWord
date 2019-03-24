//
//  TNSUserAccountTool.m
//  TNSWord
//
//  Created by mac on 15/8/1.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSUserAccountTool.h"
#import "TNAccount.h"
// 账号的存储路径
#define TNAccountPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"account.archive"]



@implementation TNSUserAccountTool
 

/**
 *  encode
 */
+ (void)saveAccount:(TNAccount *)account
{
    [NSKeyedArchiver archiveRootObject:account toFile:TNAccountPath];
}


/**
 *  decode
 */
+ (TNAccount *)account
{
    TNAccount *account = [NSKeyedUnarchiver unarchiveObjectWithFile:TNAccountPath];
 
    if(account.access_token == nil)
    {
        return nil;
    }
    
    // account outdate  
 
    long long expires_in = [account.expires_in longLongValue];
    NSDate *tokenCreateDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"tokenCreateDate" ];
    
    if (tokenCreateDate == nil)//nil == not once successfully oauthed
    {
        return nil;
    }
    NSDate *expiresTime = [tokenCreateDate dateByAddingTimeInterval:expires_in];
 
    NSDate *now = [NSDate date];
    NSComparisonResult result = [expiresTime compare:now];
    if (result != NSOrderedDescending)
    {
        return nil;
    }
    
    return account;
}
@end


