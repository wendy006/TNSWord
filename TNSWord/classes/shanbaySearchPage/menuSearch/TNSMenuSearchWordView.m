//
//  TNSMenuSearchWordView.m
//  TNSWord
//
//  Created by mac on 15/8/1.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSMenuSearchWordView.h"
#import "AFNetworking.h"
#import <AVFoundation/AVFoundation.h>
#import "TNWordInfo.h"
#import "FMDB.h"

#import "TNAccount.h"
#import "TNSUserAccountTool.h"

@interface TNSMenuSearchWordView()

//UI
@property (weak, nonatomic) IBOutlet UIButton *quitSearchViewPageBtn;
@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *pronunciationLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnTranslationLabel;
@property (weak, nonatomic) IBOutlet UILabel *enTranslationLabel;
@property (weak, nonatomic) IBOutlet UIButton *playWordAudioBtn;
@property (weak, nonatomic) IBOutlet UIButton *addToWordbookBtn;

//tool
@property(nonatomic,strong)AVAudioPlayer * musicPlayer;
 

//data
@property(strong, nonatomic) NSString *audioUrl;
@property(strong, nonatomic) NSString *localAudioUrl;
@property(strong,nonatomic) NSString *pronunciation;
@property(nonatomic,strong) NSString *wordID;

@property(nonatomic,strong) FMDatabase *db;
@end

@implementation TNSMenuSearchWordView



-(void)PostToGetDataWithWord:(NSString *)wordToSearch
{
    AFHTTPRequestOperationManager *mgr2 = [AFHTTPRequestOperationManager manager];
    NSMutableDictionary *params1 = [NSMutableDictionary dictionary];
 
    [mgr2.requestSerializer willChangeValueForKey:@"timeoutInterval"];
    mgr2.requestSerializer.timeoutInterval = 3.f;
    [mgr2.requestSerializer didChangeValueForKey:@"timeoutInterval"];
    
    
    params1[@"word"] = wordToSearch;
    
    [MBProgressHUD showMessage:@"请求中"];
    [mgr2 GET :@"https://api.shanbay.com/bdc/search/" parameters:params1 success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
     {
         [MBProgressHUD hideHUD];
   
         if(self.y == screenH)
         {
             self.y = 64 + 10;
         }
             
         NSDictionary *dataDict = [responseObject objectForKey:@"data"];
 
         self.wordLabel.hidden = NO;
         self.pronunciationLabel.hidden = NO;
         self.enTranslationLabel.hidden = NO;
         self.cnTranslationLabel.hidden = NO;
         
         
         NSString *word = (NSString *)[dataDict objectForKey:@"content" ];
         NSString *enTranslation = [[dataDict objectForKey:@"en_definition"] objectForKey:@"defn"] ;

         self.audioUrl = [dataDict objectForKey:@"audio"];
         self.pronunciation = [NSString stringWithFormat:@"%@",[dataDict objectForKey:@"pron"]];
         self.wordID  = [dataDict objectForKey:@"content_id"];
     
         if(word == nil || [word isEqualToString:@""] )
         {
             self.y = screenH;
             [MBProgressHUD showError:@"无该词信息" ];
             return;
         }
         
         if(self.pronunciation == nil || [self.pronunciation isEqualToString:@""] || [NSString hasOneOrMoreIntInString:self.pronunciation])
         {
             self.pronunciationLabel.hidden = YES;
         }
         
         if( enTranslation == nil || [enTranslation isEqualToString:@""])
         {
             self.enTranslationLabel.hidden = YES;
         }
         
         
         self.wordLabel.text = (NSString *)[dataDict objectForKey:@"content" ];
         self.pronunciationLabel.text = [NSString stringWithFormat:@"[ %@ ]",[dataDict objectForKey:@"pron"]];
         self.enTranslationLabel.text =  [[dataDict objectForKey:@"en_definition"] objectForKey:@"defn"] ;
         self.cnTranslationLabel.text = [dataDict objectForKey:@"definition"];
 
         self.localAudioUrl = [NSString stringWithFormat:@"%@.mp3",self.wordLabel.text];
 
     } failure:^(AFHTTPRequestOperation *operation, NSError *error)
     {
        [MBProgressHUD hideHUD];
         self.y = screenH;
         NSLog(@"请求失败-%@", error);
        
     }];
}





- (IBAction)playWordAudio:(id)sender
{
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOpenAudioEffect"] boolValue]) return;
    
    NSError *err;
    if (self.musicPlayer != nil)
    {
        self.musicPlayer =nil;//清空播放器
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




- (IBAction)addToWordbook:(id)sender
{
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"wordInfo.sqlite"];
    
    _db = [FMDatabase databaseWithPath:fileName];
//    [_db open];
    if([_db open])
    {
        NSString *sql = @"CREATE TABLE IF NOT EXISTS word_shop (id integer PRIMARY KEY,word text ,pronunciation text,cnDefinition text ,enDefinition text ,localAudionUrl text , isEasyWord text );";
        [_db executeUpdate:sql];
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
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
            
            NSLog(@"语音下载成功！");
        }];
        [downloadTask resume];
        
 
        NSString *sql = [NSString stringWithFormat:@"INSERT INTO word_shop(word , pronunciation, cnDefinition ,enDefinition,localAudionUrl, isEasyWord) VALUES('%@' ,'%@' ,'%@','%@','%@','%@');",self.wordLabel.text,  [ NSString clipStringForSqliteInsert:self.pronunciation], [NSString clipStringForSqliteInsert:self.cnTranslationLabel.text] ,[NSString clipStringForSqliteInsert:self.enTranslationLabel.text], self.localAudioUrl,  @"Y" ];
 
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
            NSLog(@"无此单词！注意核查");
            return;
        }
        params1[@"id"] = self.wordID;
        
        
        [mgr2 POST:@"https://api.shanbay.com/bdc/learning/" parameters:params1 success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject) {
           
            NSLog(@"请求chenggong222"); 
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"请求失败-%@", error);
        }];

    }
    
}



#pragma mark - quit [delegate method]
- (IBAction)quitSearchViewPage:(id)sender
{
    [self.delegate quitSearchViewPage];
}
@end
