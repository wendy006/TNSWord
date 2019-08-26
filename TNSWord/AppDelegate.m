//
//  AppDelegate.m
//  TNSWord
//
//  Created by mac on 15/7/23.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "AppDelegate.h"
#import "TNSHomeVC.h"
#import "TNPageViewTabBarController.h"
#import "TNSNavigationController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if(NULL == [[NSUserDefaults standardUserDefaults] objectForKey:@"firstLaunch"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstLaunch"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:12] forKey:@"textSize"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:YES] forKey:@"hasOpenAudioEffect"];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"firstLaunch"];
    }
    
        self.window = [[UIWindow alloc] init ];
        self.window.frame = [UIScreen mainScreen].bounds ;
   
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"]  )
    {
        TNPageViewTabBarController *helpInfoTabController = [[TNPageViewTabBarController alloc] init];
        self.window.rootViewController = helpInfoTabController;
    } 
    else
    {
        UIStoryboard * MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TNSNavigationController *navigationController = [MainStoryboard instantiateInitialViewController];
        self.window.rootViewController = navigationController;

    }
        [self.window makeKeyAndVisible];
        return YES;
}










- (void)applicationWillResignActive:(UIApplication *)application {
    
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
   
}

- (void)applicationWillTerminate:(UIApplication *)application {
  }

@end
