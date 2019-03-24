//
//  TNSMainMenuVC.m
//  TNSWord
//
//  Created by mac on 15/7/25.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSMainMenuVC.h"
#import "TNSHomeVC.h"
#import "TNOAuthViewController.h"
#import "TNSTimeManagerTableVC.h"
#import "TNSMenuSearchWordView.h"
#import "TNAccount.h"
#import "TNSSettingVC.h"
#import "TNPageViewTabBarController.h"



#import "TNSGameSentenceChooseCVC.h"
#import "TNSGameChapterChooseCVC.h"
#import "TNSReadingChapterChooseCVC.h"



#import "TNShanbayViewController.h"

@interface TNSMainMenuVC ()<UISearchBarDelegate,UIAlertViewDelegate,TNSMenuSearchWordViewDelegate>


//Gesture
@property (strong, nonatomic) IBOutlet UITapGestureRecognizer *timeManagerTap;

//UI
@property (weak, nonatomic) IBOutlet UISearchBar *menuSearchBar;
@property (weak, nonatomic) IBOutlet UIView *menuBaseView;
@property (weak, nonatomic) IBOutlet UIView *homePageView;
@property (weak, nonatomic) IBOutlet UIView *timeManagerPageView;
@property (weak, nonatomic) IBOutlet UIView *settingPageView;
@property (weak, nonatomic) IBOutlet UIView *helpPageView;
@property (strong,nonatomic) TNSMenuSearchWordView *menuSearchWordView;


//autoLayout

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHomeViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuLoadViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuTimeManagerViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuSettingViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuHelpViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBaseViewTopY;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuBaseViewBottomY;

//VC
@property(nonatomic,strong)TNSSettingVC *settingVC;
@property(nonatomic,strong)TNPageViewTabBarController *helpInfoPageTabController;
@end



@implementation TNSMainMenuVC

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self =   [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}


-(TNPageViewTabBarController *)helpInfoPageTabController
{
    if (_helpInfoPageTabController == nil)
    {
        _helpInfoPageTabController = [[TNPageViewTabBarController alloc] init];
    }
    return _helpInfoPageTabController;
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view. backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroud.jpg"]];

//layout
    NSInteger height = 75.0/480.0 * screenH;
    self.menuHomeViewHeight .constant = height;
    self.menuLoadViewHeight .constant = height;
    self.menuTimeManagerViewHeight .constant = height;
    self.menuSettingViewHeight .constant = height;
    self.menuHelpViewHeight .constant = height;
    
//gesture
    [self addGestures];
    self.menuSearchBar.delegate = self;

}

// for keyboard
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    
    if((self.menuSearchWordView!=nil) && (self.menuSearchWordView.y != screenH ) && [self.menuSearchWordView isDescendantOfView:self.view])
    {
        return;
    }
    
    if ( ![[touch view] isKindOfClass:[UISearchBar class]])
    {
        [self.menuSearchBar resignFirstResponder];
//        self.menuBaseView.y = 64+10;
        
//        [self.menuBaseView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.topMargin.equalTo([NSNumber numberWithFloat:64 + 10 ]);
//        }];
        
        [self.menuBaseView mas_updateConstraints:^(MASConstraintMaker *make) {
            self.menuBaseViewTopY.constant = 64 + 10;
            self.menuBaseViewBottomY.constant = 3;
        }];
        
        [self.menuSearchWordView removeFromSuperview];
        
    }
}


#pragma mark -   <UISearchBarDelegate>

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [self.menuBaseView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.menuBaseViewTopY.constant =  screenH;
        self.menuBaseViewBottomY.constant = 3 + (screenH - 64 -10);
    }];
    
 }


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    // remove keyboard
    [self.menuSearchBar resignFirstResponder];
    
    [TNDataContainer sharedDataContainer].wordToSearch = self.menuSearchBar.text;
    
    if (_menuSearchWordView == nil)
    {
         _menuSearchWordView = [[[NSBundle mainBundle] loadNibNamed:@"TNSMenuSearchWordView" owner:nil options:nil] lastObject];
    }
   
    // set UI
    [_menuSearchWordView PostToGetDataWithWord:[TNDataContainer sharedDataContainer].wordToSearch];
    
    [self.view addSubview:self.menuSearchWordView ];
    
    [self.menuSearchWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(self.view).insets(UIEdgeInsetsMake(74, 20, 3, 20));
    }];
    
    
    
    [self.menuBaseView mas_updateConstraints:^(MASConstraintMaker *make) {
        self.menuBaseViewTopY.constant =  screenH;
        self.menuBaseViewBottomY.constant = 3 + (screenH - 64 -10);
    }];

    
    self.menuSearchWordView.delegate = self;
    self.menuSearchWordView.backgroundColor = [UIColor clearColor];
 
   
 
}


#pragma mark -  openHomePage
- (void)openHomePage:(UIGestureRecognizer *)sender
{
    // enable userinteraction
    
    [[(TNSHomeVC *)(self.parentViewController)  gameSentenceChooseCVC] collectionView].userInteractionEnabled = YES;
    [[(TNSHomeVC *)(self.parentViewController)  gameChapterChooseCVC] collectionView].userInteractionEnabled = YES;
    [[(TNSHomeVC *)(self.parentViewController)  readingChapterChooseCVC] collectionView].userInteractionEnabled = YES;
 
    [self removeMenuView];
}


#pragma mark - open shanbay OAuth Page
- (void)openloadShanbayPage:(UITapGestureRecognizer*)sender
{
    
    if([self.loadShanbayPageView_loadTitleLabel.text isEqualToString:@"退出登录"]  )
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"退出登录" message:@"您确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
      
    }
    else
    {
        [self removeMenuView];
        TNOAuthViewController *oauthVC = [[TNOAuthViewController alloc] init ];
        [self.parentViewController presentViewController:oauthVC animated:YES completion:nil];

    }
}


#pragma mark -  alertView
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    switch (buttonIndex)
    {
        case 0:
        {
            NSLog(@"Cancel Button Pressed");
            break;
        }
            
        case 1:
        {
           
            TNAccount *account = [[TNAccount alloc] init ];
            [NSKeyedArchiver archiveRootObject:account toFile:TNAccountPath];
            
            //1.remove Values
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"username"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userPhotoUrl"];
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"tokenCreateDate"];
            
            
            //2.refresh UI
            self. loadShanbayPageView_loadTitleLabel.text = @"登录";
            self. loadShanbayPageView_usernameLabel.text = @"Welcome" ;
            
            UIImageView *imageView = self.loadShanbayPageView_imageView;
            [imageView setImage:[UIImage imageNamed:@"loadShanbay.png"]];
 
            
            break;
        }

        default:
            break;
    }
    
}

#pragma mark - timeManager page
- (IBAction)openTimeManagerTableVC:(UITapGestureRecognizer *)sender
{
    [self removeMenuView];
    TNSTimeManagerTableVC *timeManagerTableVC = [[TNSTimeManagerTableVC alloc] init];

    [self.parentViewController.navigationController pushViewController:timeManagerTableVC animated:YES];
    
    //left 64 for naviBar
    [timeManagerTableVC.tableView setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    timeManagerTableVC.navigationItem.title = @"学习记录";
    
}


#pragma mark - setting page
- (void)opensettingPage:(id)sender
{
    [self removeMenuView];
    
    if (_settingVC == nil)
    {
        _settingVC = [[TNSSettingVC alloc] initWithNibName:@"TNSSettingVC" bundle:nil];
    }
    
    [self.parentViewController.navigationController pushViewController:_settingVC animated:YES];
 
    self.settingVC.navigationItem.title = @"设置";
    
    
}


#pragma mark - user help page
- (void)openhelpPage:(id)sender
{
    [self presentViewController:self.helpInfoPageTabController animated:YES completion:nil];
    [self removeMenuView];
}



-(void)removeMenuView
{
    [self.view removeFromSuperview];
    
    ( (TNSHomeVC *) self.parentViewController).navigationController.navigationBar.frame = CGRectMake(0, 20, screenW, 44);
    
    ( (TNSHomeVC *) self.parentViewController).baseView.frame = CGRectMake(0, 0, screenW, screenH);
}


/**
 *   gestures from xib
 */
-(void)addGestures
{
 
    UITapGestureRecognizer *tap0 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openHomePage:)];
    [self.homePageView addGestureRecognizer:tap0];
 
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openloadShanbayPage:)];
    [self.loadShanbayPageView addGestureRecognizer:tap1];
 
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(opensettingPage:)];
    [self.settingPageView addGestureRecognizer:tap3];
 
    UITapGestureRecognizer *tap4 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openhelpPage:)];
    [self.helpPageView addGestureRecognizer:tap4];
}

-(void)quitSearchViewPage
{
    [self.menuSearchWordView removeFromSuperview ];
 
    
    
    
    [self.menuBaseView mas_updateConstraints:^(MASConstraintMaker *make) {
    
        self.menuBaseViewTopY.constant = 64 + 10;
        self.menuBaseViewBottomY.constant = 3;
    }];
    
    
}

//rewrite modal - control userinteration
-(void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion
{
    
         TNSHomeVC *homeVC = (TNSHomeVC *)self.parentViewController;
        if (homeVC.gameChapterChooseCVC.collectionView.userInteractionEnabled == NO)
        {
            homeVC.gameChapterChooseCVC.collectionView.userInteractionEnabled =  YES;
        }
        if (homeVC.gameSentenceChooseCVC.collectionView.userInteractionEnabled == NO)
        {
            homeVC.gameSentenceChooseCVC.collectionView.userInteractionEnabled =  YES;
        }
        if (homeVC.readingChapterChooseCVC.collectionView.userInteractionEnabled == NO)
        {
            homeVC.readingChapterChooseCVC.collectionView.userInteractionEnabled =  YES;
        }
     [super presentViewController:viewControllerToPresent animated:flag completion:completion];
    
}
 

@end
