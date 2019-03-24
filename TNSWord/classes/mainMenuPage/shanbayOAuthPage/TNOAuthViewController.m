//
//  TNOAuthViewController.m
//  testWithStoryboard
//
//  Created by mac on 15/6/11.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNOAuthViewController.h"
#import "TNSUserAccountTool.h"
#import "AFNetworking.h"

#import "TNAccount.h"

#define client_id        @"14bff01013c8cecec8e1"
#define client_secret    @"81fb64f8f148d8d852baa24f6fc9f863f3cb7a31"
#define redirect_uri     @"http://www.baidu.com/"


@interface TNOAuthViewController ()<UIWebViewDelegate>
@property (nonatomic,strong) UIWebView *webView;

//avoid when tap "cancel oauth", user can no longer turn back to last page [via present]
@property(nonatomic,strong)UIButton *button;
@end

@implementation TNOAuthViewController


-(UIWebView *)webView
{
    if (_webView == nil)
    {
        _webView = [[UIWebView alloc]init];
        _webView.frame = CGRectMake(0,  self.button.height, screenW, screenH - self.button.height);
        _webView.backgroundColor = [UIColor clearColor];
        _webView.delegate = self;
    }
    return _webView;
}


///////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroud.jpg"]]];
    
#pragma mark - initiate backBtn
    
    _button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, screenW, 30)];
    [_button addTarget:self action:@selector(dismissOAuthVC) forControlEvents:UIControlEventTouchUpInside];//点击按钮关闭该界面
    [_button setImage:[UIImage imageNamed:@"webViewQuite.jpg"] forState:UIControlStateNormal];
    [_button setImageEdgeInsets:UIEdgeInsetsMake(1, 1, 1, 1)];

    [self.view addSubview:_button];

#pragma mark - add webView and load url [create webView via lazyload]
    [self.view addSubview:self.webView];
    
    // 0.remove cookies
    for(NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies])
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
        
    }
 
    // 1.load login page
    
    NSURL *url = [NSURL URLWithString:@"https://api.shanbay.com/oauth2/authorize/?client_id=14bff01013c8cecec8e1&response_type=code&state=1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_webView loadRequest:request];
   
}

///////////////////////////////////////////////////////////////////////////////////////////////

///////////////////////////////////// request states //////////////////////////////////////////


- (void)webViewDidStartLoad:(UIWebView *)webView
{
 
    [MBProgressHUD showMessage:@"loading..." toView:self.webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideHUDForView:self.webView];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.webView];
}

//////////////////////////////////////////////////////////////////////////////////////////////////




/////////////////////////////////////////// getting  accessToken /////////////////////////////////

#pragma mark - exchange for accessToken [via code]
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *url = request.URL.absoluteString;
  
    NSRange range = [url rangeOfString:@"code="];
    if (range.length != 0)
    {
        
        long fromIndex = range.location + range.length;
        NSString *code = [url substringFromIndex:fromIndex];
        
        [self accessTokenWithCode:code];
        return NO;
    }
    
    return YES;
}



-(void)accessTokenWithCode:(NSString *)code
{
    _didLoad = NO;
    
    //1.requestManager
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    [mgr.requestSerializer willChangeValueForKey:@"timeoutInterval"];
     mgr.requestSerializer.timeoutInterval = 3.f;
    [mgr.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    

    
    //2.params
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"client_id"] = client_id;
    params[@"client_secret"] = client_secret;
    params[@"grant_type"] = @"authorization_code";
    params[@"code"] = code;
    params[@"redirect_uri"] = redirect_uri;
    
    //3.oauth
    [mgr POST:@"https://api.shanbay.com/oauth2/token/" parameters:params success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
        
        _didLoad = YES;
        NSDate * date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate * tokenCreateDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        [[NSUserDefaults standardUserDefaults] setObject:tokenCreateDate forKey:@"tokenCreateDate"];
        
        
        [MBProgressHUD hideHUDForView:self.webView];
        [MBProgressHUD showSuccess:@"授权成功啦~" toView:self.webView];
   
    
        TNAccount *account = [TNAccount accountWithDict:responseObject];
        
        //1. account modal save to sandbox
       
        [TNSUserAccountTool saveAccount:account];
        
#pragma mark - get user's shanbay info
        
//       AFHTTPRequestOperationManager *mgr2 = [AFHTTPRequestOperationManager manager];
         NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
         NSString *access_token =   responseObject[@"access_token"];
         params1[@"access_token"]= access_token;
        
         [mgr GET :@"https://api.shanbay.com/account/" parameters:params1 success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
           [MBProgressHUD hideHUD];
 
            // 2. PhotoUrl
            NSString *userPhotoUrl = [responseObject objectForKey:@"avatar"];
            [[NSUserDefaults standardUserDefaults] setObject:userPhotoUrl forKey:@"userPhotoUrl"];
            
            // 3. username
            NSString *username = [responseObject objectForKey:@"username"];
            [[NSUserDefaults standardUserDefaults] setObject:username forKey:@"username"];
            
            
             
 
            } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
                TNLog(@"请求失败-%@", error);
            }];
 
 //   remove VC  -- 2 seconds delay [ delay for hud ]
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [_webView removeFromSuperview];
 
            [self dismissViewControllerAnimated:YES completion:nil];
        });
       
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error)
    {
        TNLog(@"请求失败-%@", error);
        [_webView removeFromSuperview];
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    
}

//////////////////////////////////////////////////////////////////////////////////////////////////


#pragma mark - quit OAuthVC
-(void)dismissOAuthVC
{
    [_webView removeFromSuperview];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

 @end
