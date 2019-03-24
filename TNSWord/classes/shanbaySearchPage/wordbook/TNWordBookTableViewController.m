//
//  TNWordBookTableViewController.m
//  TNWord
//
//  Created by mac on 15/6/20.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNWordBookTableViewController.h"
#import "TNWordCell.h"
#import "FMDB.h"
#import <AVFoundation/AVFoundation.h>  
#import "TNSMusicTool.h"

@interface TNWordBookTableViewController ()<UISearchBarDelegate>

@property(nonatomic,strong)UISearchBar *searchBar;

@property(nonatomic,strong)UIView *headerView;

@property(nonatomic,strong)FMDatabase *db;

@property(nonatomic,strong)AVAudioPlayer * musicPlayer;
@end

@implementation TNWordBookTableViewController

-(UISearchBar *)searchBar
{
    if (_searchBar == nil)
    {
        _searchBar = [[UISearchBar alloc] init ] ;
        
        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, screenW, 44)];
        _searchBar.placeholder = @"请输入";
        
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, 44)];
        [self.headerView addSubview:self.searchBar];
 
        [self.tableView setTableHeaderView:self.headerView];
     }
    
    return _searchBar;
}

 - (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [self.wordShop removeAllObjects];
    
    
    NSString *sql = [NSString stringWithFormat:@"SELECT word,pronunciation, cnDefinition, enDefinition, localAudionUrl FROM word_shop WHERE word LIKE '%%%@%%' ;", searchText];
    
    FMResultSet *set = [_db executeQuery:sql];
    while(set.next)
    {
        TNWordInfo *word = [[TNWordInfo alloc] init];
        word.word = [set stringForColumn:@"word"];
        
        word.pronunciation = [set stringForColumn:@"pronunciation"];
        word.cnDefinition = [set stringForColumn:@"cnDefinition"];
        word.enDefinition = [set stringForColumn:@"enDefinition"];
        word.localAudionUrl = [set stringForColumn:@"localAudionUrl"];

        [self.wordShop addObject:word];
    }
    
       [self.tableView reloadData];
}



-(NSMutableArray *)wordShop
{
    if (_wordShop  == nil)
    {
        _wordShop = [[NSMutableArray alloc] init ];
     }
    
    return _wordShop;
}

 -(void)viewTapped:(UITapGestureRecognizer*)tapView
    {
        [self.searchBar resignFirstResponder];
    }


- (void)viewDidLoad {
    [super viewDidLoad];
  
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor grayColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(10, 10, 10, 10);
 
    self.searchBar.backgroundColor = [UIColor grayColor];
    self.searchBar.delegate = self;
    
    UITapGestureRecognizer *tapView = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapView.cancelsTouchesInView = NO;
    [self.tableView addGestureRecognizer:tapView];
    
    NSString *fileName = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"wordInfo.sqlite"];
    
    _db = [FMDatabase databaseWithPath:fileName];
    if([_db open])
    {
        NSLog(@"ok~");
    }
    
    NSString *sql = @"SELECT word , pronunciation ,cnDefinition ,enDefinition,localAudionUrl FROM word_shop;";
    FMResultSet *set = [_db executeQuery:sql];
    while(set.next)
    {
            TNWordInfo *word = [[TNWordInfo alloc] init];
            word.word = [set stringForColumn:@"word"];
            word.pronunciation = [set stringForColumn:@"pronunciation"];
            word.cnDefinition = [set stringForColumn:@"cnDefinition"];
            word.enDefinition = [set stringForColumn:@"enDefinition"];
            word.localAudionUrl = [set stringForColumn:@"localAudionUrl"];
        
            [self.wordShop addObject:word];
        
    }
 
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
     return self.wordShop.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static  NSString * ID = @"wordCell";
    TNWordCell *cell = [tableView dequeueReusableCellWithIdentifier:ID ];
 
    if(cell == nil)
    {
       cell = [[[NSBundle mainBundle] loadNibNamed:@"TNWordCell" owner:nil options:nil] lastObject];
    }
    
    TNWordInfo *word = (TNWordInfo *)((self.wordShop)[indexPath.row]);
    
    cell.wordLabel.text = word.word;
    cell.pronunciationLabel.text = [NSString stringWithFormat:@"[%@]",word.pronunciation] ;
    cell.definitionLabel.text = word.cnDefinition;
    cell.enDefinitionLabel.text = word.enDefinition;
    cell.localAudioUrl = word.localAudionUrl;
    
    cell.audioBtn.tag = tagBase2 + indexPath.row;
    [cell.audioBtn addTarget:self action:@selector(playAudioOfCurrentWord:) forControlEvents:UIControlEventTouchUpInside];
    
    
    cell.addToOkBtn.tag = tagBase3 + indexPath.row;
    [cell.addToOkBtn addTarget:self action:@selector(deleteCellOfCurrentWord:) forControlEvents:UIControlEventTouchUpInside];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
  
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell.frame.size.height;
}



-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    if ( ![[touch view] isKindOfClass:[UISearchBar class]])
    {
        [self.searchBar resignFirstResponder];
    }
}



-(void)playAudioOfCurrentWord:(UIButton *)button
{
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOpenAudioEffect"] boolValue])  return;
   
    long index = button.tag - tagBase2;
     NSString *word = ((TNWordInfo*)(self.wordShop[index])).word;
    [TNSMusicTool playShortAudioInWordBookWithFilename:word];
    
}


-(void)deleteCellOfCurrentWord:(UIButton *)button
{
    
    long index = button.tag - tagBase3;
    NSString *wordToDelete = ((TNWordInfo*)(self.wordShop[index])).word;
   
    for (int i = 0; i<self.wordShop.count; i++)
    {
      if([ ( (NSString *)(( (TNWordInfo *)(self.wordShop[i]) ).word))  isEqualToString:wordToDelete])
      {
         [self.wordShop removeObjectAtIndex:i];
         [self.tableView reloadData];
       }
    }
 
    NSString *sql_prepare2 = [NSString stringWithFormat:@"delete FROM word_shop WHERE word = '%@' ;", wordToDelete];
    [_db executeUpdate:sql_prepare2];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{ 
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
