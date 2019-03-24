//
//  TNShanbayViewController.m
//  TNWord
//
//  Created by mac on 15/6/20.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNShanbayViewController.h"
 
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "TNWordInfo.h"
#import "FMDB.h"

#import "TNWordBookTableViewController.h"
#import "TNAccount.h"
#import "TNSUserAccountTool.h"

#import "TNSReadingPageVC.h"

@interface TNShanbayViewController ()

//UI
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *pronunciationLabel;
@property (weak, nonatomic) IBOutlet UILabel *definitionLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UIButton *addToLocalBtn;
@property (weak, nonatomic) IBOutlet UIButton *openLocalWordBookBtn;

//data
@property (strong, nonatomic) FMDatabase *db;
@property (strong, nonatomic) NSString *enDefinition;
@property (strong, nonatomic) NSString *audioUrl;
@property (strong, nonatomic) NSString *localAudioUrl;
@property (strong, nonatomic) NSString *pronunciation;
@property (strong, nonatomic) NSString *wordID;

//tool
@property(nonatomic,strong) AVAudioPlayer *musicPlayer;
//@property(nonatomic,strong) TNStringTool *tool;

//VC
@property(nonatomic,strong) TNWordBookTableViewController *wordBookVC;

@end

@implementation TNShanbayViewController

 


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.wordLabel.textColor = [UIColor blackColor];
    self.pronunciationLabel.textColor = [UIColor blackColor];
    self.definitionLabel.textColor = [UIColor blackColor];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroud.jpg"]];
}



-(void)PostToGetDataWithWord:(NSString *)wordToSearch
{
    
      AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
      NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
  
      [mgr .requestSerializer willChangeValueForKey:@"timeoutInterval"];
       mgr .requestSerializer.timeoutInterval = 2.f;
      [mgr .requestSerializer didChangeValueForKey:@"timeoutInterval"];
 
      params1[@"word"] = wordToSearch;
    
      [mgr  GET :@"https://api.shanbay.com/bdc/search/" parameters:params1 success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
      {
        TNSReadingPageVC *vc = (TNSReadingPageVC *)(self.parentViewController);
         vc.contentTextView.contentOffset = vc.offsetForTextView;
      
        self.view.hidden = NO;
        
         NSDictionary *dataDict = [responseObject objectForKey:@"data"];
        self.wordLabel.hidden = NO;
        self.pronunciationLabel.hidden = NO;
        self.definitionLabel.hidden = NO;
        
        
        NSString *word = (NSString *)[dataDict objectForKey:@"content" ];
        self.audioUrl = [dataDict objectForKey:@"audio"];
        self.pronunciation = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"pron"]];
        self.wordID  = [dataDict objectForKey:@"content_id"];
        self.enDefinition = [[dataDict objectForKey:@"en_definition"] objectForKey:@"defn"] ;

 
        if(word == nil || [word isEqualToString:@""])
        {
            [MBProgressHUD showError:@"无该词信息"];
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
            return;
        }
        
        if(self.pronunciation == nil || [self.pronunciation isEqualToString:@""] || [NSString hasOneOrMoreIntInString:self.pronunciation])
        {
            self.pronunciationLabel.hidden = YES;
        }
          
        self.wordLabel.text = (NSString *)[dataDict objectForKey:@"content" ];
        self.pronunciationLabel.text = [NSString stringWithFormat:@"[ %@ ]",[dataDict objectForKey:@"pron"]];
        self.definitionLabel.text = [dataDict objectForKey:@"definition"];
        self.localAudioUrl = [NSString stringWithFormat:@"%@.mp3",self.wordLabel.text];
          
       } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
           
           NSLog(@"请求失败-%@", error);
           [MBProgressHUD show:@"网络状态不佳" icon:nil view:self.parentViewController.view afterDelay:1];//这个自己会撤退
            
           [self.view removeFromSuperview];
           [self removeFromParentViewController];
         }];
}


- (IBAction)audioBtnDidClicked:(id)sender
{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOpenAudioEffect"] boolValue])  return;
    
    NSError *err;
    if (self.musicPlayer != nil)
    {
        self.musicPlayer =nil ;
    }
    
    NSString *sql_prepare = [NSString stringWithFormat:@"SELECT word FROM word_shop WHERE word = '%@' ;", self.wordLabel.text];
    FMResultSet *set = [_db executeQuery:sql_prepare];
    
    if(set.next)
    {
        [TNSMusicTool playShortAudioInWordBookWithFilename:self.wordLabel.text];
        return;
    }
 
    NSData *audioMp3 = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:self.audioUrl] ];
    self.musicPlayer = [[AVAudioPlayer alloc] initWithData:audioMp3 error:&err];
    self.musicPlayer.volume = 0.7;
    NSTimeInterval duration = self.musicPlayer.duration;
    
    [self.musicPlayer prepareToPlay] ;
    [self.musicPlayer play];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.musicPlayer stop];
    });
}




- (IBAction)addToLocalBtnDidClicked:(id)sender
{
     NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"wordInfo.sqlite"];
    
    _db = [FMDatabase databaseWithPath:fileName];
    //[_db open];
   
    if([_db open])
    {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS word_shop (id integer PRIMARY KEY,word text ,pronunciation text,cnDefinition text ,enDefinition text ,localAudionUrl text , isEasyWord text );";
        [_db executeUpdate:sql];
        NSLog(@"2数据库打开成功");
 
    }
 
     NSString *sql_prepare = [NSString stringWithFormat:@"SELECT word FROM word_shop WHERE word = '%@' ;", self.wordLabel.text];
    
     FMResultSet *set = [_db executeQuery:sql_prepare];
  
    if(!set.next)
    {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:self.audioUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            
          return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
        {
            NSLog(@"语音下载成功！");
        }];
        
        [downloadTask resume];
      
         NSString *sql = [NSString stringWithFormat:@"INSERT INTO word_shop(word , pronunciation, cnDefinition ,enDefinition,localAudionUrl, isEasyWord) VALUES('%@' ,'%@' ,'%@','%@','%@','%@');",self.wordLabel.text,  [NSString clipStringForSqliteInsert:self.pronunciationLabel.text],[NSString clipStringForSqliteInsert:self.definitionLabel.text],[NSString clipStringForSqliteInsert:self.enDefinition], self.localAudioUrl,  @"Y" ];

    //insert data
    [_db executeUpdate:sql];       
 
    }
    
  
    if([TNSUserAccountTool account] )
    {
        
        TNAccount *account = [TNSUserAccountTool account];
        NSString  *access_token = account.access_token;
        
       
        AFHTTPRequestOperationManager *mgr2 = [AFHTTPRequestOperationManager manager];
        NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
        
        params1[@"access_token"]= access_token;
        if(self.wordID == nil)
        {
            TNLog(@"无此单词！注意核查");
            return;
        }
        params1[@"id"] = self.wordID;
        [mgr2 POST:@"https://api.shanbay.com/bdc/learning/" parameters:params1 success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
            
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            TNLog(@"请求失败-%@", error);
        }];
    }
   
}




- (IBAction)openLocalWordBookBtnDidClicked:(id)sender
{
    [self.view removeFromSuperview];
    self.wordBookVC = [[TNWordBookTableViewController alloc] init];
    
    [self.parentViewController.navigationController pushViewController:self.wordBookVC animated:YES];
 
}




- (IBAction)quitShanbayView:(id)sender
{
    [self.view removeFromSuperview];
}
@end
