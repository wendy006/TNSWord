//
//  TNPageViewTabBarController.m
//  TNSWord
//
//  Created by mac on 15/8/5.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#define TNColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#import "TNPageViewTabBarController.h"
#import "TNHelpInfoVC.h"
#import "TNSNavigationController.h"


@interface TNPageViewTabBarController ()
 

@property(nonatomic,strong)TNHelpInfoVC *readingPageVC ;
@property(nonatomic,strong)TNHelpInfoVC *gamePageVC ;
@property(nonatomic,strong)TNHelpInfoVC *otherPageVC ;

@property(nonatomic,strong)UIViewController *enterMainPageVC;

@property(nonatomic,strong)NSMutableArray *readingImageArray;
@property(nonatomic,strong)NSMutableArray *gameImageArray ;
@property(nonatomic,strong)NSMutableArray *otherImageArray ;


@end

@implementation TNPageViewTabBarController

-(NSMutableArray *)readingImageArray
{
    if (_readingImageArray == nil)
    {
        _readingImageArray = [NSMutableArray array];
        
        for (int i=0; i<4; i++)//current 4
        {
            NSString *imageName = [NSString stringWithFormat:@"readingInfo%d.png" ,i ];
            [_readingImageArray addObject:imageName];
        }
        
    }
    return _readingImageArray;
    
}

-(NSMutableArray *)gameImageArray
{
    if (_gameImageArray == nil)
    {
        _gameImageArray = [NSMutableArray array];
        
        for (int i=0; i<3; i++)//current 3
        {
            NSString *imageName = [NSString stringWithFormat:@"gameInfo%d.png" ,i ];
            [_gameImageArray addObject:imageName];
        }
        
    }
    return _gameImageArray;
    
}


-(NSMutableArray *)otherImageArray
{
    if (_otherImageArray == nil)
    {
        _otherImageArray = [NSMutableArray array];
        
        for (int i=0; i<4; i++)// current 4
        {
            NSString *imageName = [NSString stringWithFormat:@"otherInfo%d.png" ,i];
            [_otherImageArray addObject:imageName];
        }
        
    }
    return _otherImageArray;
    
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad {
    [super viewDidLoad];
    
    _readingPageVC = [[TNHelpInfoVC alloc] initWithImageArray:self.readingImageArray];
    
    _gamePageVC = [[TNHelpInfoVC alloc] initWithImageArray:self.gameImageArray];
    _otherPageVC = [[TNHelpInfoVC alloc] initWithImageArray:self.otherImageArray];
    
    _enterMainPageVC = [[UIViewController alloc]init];
    _enterMainPageVC.view.frame = CGRectMake(0, 0, screenW, screenH - 48);//量出来的tabBar栏大概就是48像素
    _enterMainPageVC.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"turnToMainPage.png"]];
    
#pragma mark -  last page contains an btn as an entrance to mainPage
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(45, 205.0/480.0*screenH, 100.0/320.0*screenW, 50.0/320.0*screenH)];
    [btn setImage:[UIImage imageNamed:@"buttonImage.png"] forState:UIControlStateNormal];
    btn.layer.cornerRadius = btn.height *0.2;
    
    [btn addTarget:self action:@selector(turnToMainPage) forControlEvents:UIControlEventTouchUpInside];//按钮点击事件
    [_enterMainPageVC.view addSubview:btn];
 
    
    [self addChildVC:self.readingPageVC title:@"阅读" tabImage:@"readingSwitch.png"  ];
    [self addChildVC:self.gamePageVC title:@"游戏" tabImage:@"gameSwitch.png"  ];
    [self addChildVC:self.otherPageVC title:@"其他" tabImage:@"openMainMenu.png"   ];
    [self addChildVC:self.enterMainPageVC title:@"进入主页" tabImage:@"Home.png"  ];
    
    
}



#pragma mark - addChildControllers
-(void)addChildVC:(UIViewController *)childVC title:(NSString *)title tabImage:(NSString *)image
{
    childVC.title = title;
 
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = TNColor(123, 123, 123);
    [childVC.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    

    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] = [UIColor orangeColor];
    [childVC.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    
    childVC.tabBarItem.image = [UIImage imageNamed:image];
 
 
    [self addChildViewController:childVC];
 }
 

-(void)turnToMainPage
{
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"] )
    {
        UIStoryboard * MainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        TNSNavigationController *navigationController = [MainStoryboard instantiateInitialViewController];
        [self presentViewController:navigationController animated:YES completion:nil];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    
}

@end
