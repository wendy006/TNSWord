//
//  TNTouchViewController.m
//  TNGameBtnPageDemo
//
//  Created by mac on 15/7/20.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNTouchViewController.h"
#import "TNTouchViewModel.h"
#import "TNTouchView.h"
#import <AVFoundation/AVFoundation.h>

@interface TNTouchViewController ()

@property(nonatomic,strong)UIButton *playSentenceAudioBtn;
@property(nonatomic,strong)UIButton *showSentenceTranslationBtn;

@property(nonatomic,assign)NSInteger playCurrentAudioCount;

@end

@implementation TNTouchViewController


////////////////////////////////////////// scoreLabel ////////////////////////////////////////////////////////


-(instancetype)init
{
    self = [super init];
    if (self)
    {
        _scoreLabel = [[UILabel alloc]init];
        //noti
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notiScoreDidChange:) name:@"scoreDidChange" object:nil];
        
        [self setScoreLabelAttrText:1];
        
    }
    return self;
}


-(void)notiScoreDidChange:(NSNotification *)notification
{
    NSNumber *score = [[notification userInfo] objectForKey:@"newScore"];
    
    [self setScoreLabelAttrText:score.intValue];
}


-(void)setScoreLabelAttrText:(int)score
{
 
    NSString *scoreShow =  [NSString stringWithFormat:@" %d / %lu ", score,(unsigned long)[TNDataContainer sharedDataContainer].currentTitleArray.count];
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc]initWithString:scoreShow ];
    
    [attrStr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1,2)];
    
    self.scoreLabel.attributedText = attrStr;
    self.scoreLabel.textAlignment = NSTextAlignmentCenter;
    [_scoreLabel setFrame:CGRectMake(230.0/320*screenW,20, 60, 40)];
 
}


///////////////////////////////////////////////////////////////////////////////////////////////////////////////


- (void)viewDidLoad
{
   
    [super viewDidLoad];
    
    NSMutableArray * touchViewModelArray = [NSMutableArray array];
    for (int i = 0; i < [self.disorderArray count]; i++)
    {
        NSString * title = [self.disorderArray objectAtIndex:i];

        TNTouchViewModel * touchViewModel = [[TNTouchViewModel alloc] initWithTitle:title ];
        [touchViewModelArray  addObject:touchViewModel];
     
        if (i == KDefaultCountOfUpsideList - 1)
        {
            _modelArray1 = [NSMutableArray arrayWithArray:touchViewModelArray] ;
            [touchViewModelArray  removeAllObjects];
        }
        else if(i == [self.disorderArray count] - 1)
        {
            _modelArray2 = [NSMutableArray arrayWithArray:touchViewModelArray] ;
        }
        
    }

 
    _viewArray1 = [[NSMutableArray alloc] init];
    _viewArray2 = [[NSMutableArray alloc] init];
    
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(110.0/320*screenW, 25, 100, 40)];
    _titleLabel.text = @"答案区";
    [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel setTextColor:[UIColor colorWithRed:187/255.0 green:1/255.0 blue:1/255.0 alpha:1.0]];
    [self.view  addSubview:_titleLabel];
 
    
    _titleLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(110.0/320*screenW, KTableStartPointY + KButtonHeight * ([self array2StartY] -2) + KMoreChannelDeltaHeight, 100, titleLabel2Height)];
    _titleLabel2.text = @"备选区";
    [_titleLabel2 setFont:[UIFont systemFontOfSize:12]];
    [_titleLabel2 setTextAlignment:NSTextAlignmentCenter];
    [_titleLabel2 setTextColor:[UIColor grayColor]];
    [self.view  addSubview:_titleLabel2];
    
    
#pragma mark - location
    for (int i = 0; i < _modelArray1.count; i++)
    {
//TouchView
 
        TNTouchView * touchView = [[TNTouchView alloc] initWithFrame:CGRectMake(KTableStartPointX + KButtonWidth * (i%grid_per_Row), KTableStartPointY + KButtonHeight * (i/grid_per_Row), KButtonWidth, KButtonHeight)];
        [touchView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]];
        [_viewArray1 addObject:touchView];
        
        touchView.array = _viewArray1;
        if (i == 0)
        {
            [touchView.label setTextColor:[UIColor colorWithRed:187/255.0 green:1/255.0 blue:1/255.0 alpha:1.0]];
            touchView.label.tag = touchViewTagBase;
            touchView.label.userInteractionEnabled = NO;
        }
        else
        {
            [touchView.label setTextColor:[UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1.0]];
        }
 
        touchView.label.text = ((TNTouchViewModel *)[_modelArray1 objectAtIndex:i]).title;
        touchView.viewArray11 = _viewArray1;
        touchView.viewArray22 = _viewArray2;
        [touchView setTouchViewModel:[_modelArray1 objectAtIndex:i]];
        
        [self setFontSizeForLongTextInLabel:touchView.label];
        [self.view  addSubview:touchView];
    }
    
 
    for (int i = 0; i < _modelArray2.count; i++)
    {
        TNTouchView * touchView = [[TNTouchView alloc] initWithFrame:CGRectMake(KTableStartPointX + KButtonWidth * (i%grid_per_Row), KTableStartPointY + KDeltaHeight + ([self array2StartY] - 1) * KButtonHeight  + KButtonHeight * (i/grid_per_Row)  , KButtonWidth, KButtonHeight)];
        
        [touchView setBackgroundColor:[UIColor colorWithRed:210/255.0 green:210/255.0 blue:210/255.0 alpha:1.0]];
        [_viewArray2 addObject:touchView];
        touchView.array = _viewArray2;
      
        [touchView.label setTextColor:[UIColor colorWithRed:99/255.0 green:99/255.0 blue:99/255.0 alpha:1.0]];
        touchView.label.text = [[_modelArray2 objectAtIndex:i] title];
       
        [self setFontSizeForLongTextInLabel:touchView.label];
        [touchView setMoreChannelsLabel:_titleLabel2];
        touchView.viewArray11 = _viewArray1;
        touchView.viewArray22 = _viewArray2;
        
        
        [touchView setTouchViewModel:[_modelArray2 objectAtIndex:i]];
        [self.view addSubview:touchView];
       
        
    }

#pragma mark - backBtn
     self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.backButton setFrame:CGRectMake(5,20, 30, 25)];
    [self.backButton setImage:[UIImage imageNamed:@"backToLastPage.png"] forState:UIControlStateNormal];
    self.backButton.userInteractionEnabled = YES;
    [self.view  addSubview:self.backButton];
  
    
    _scoreLabel.backgroundColor = [UIColor clearColor];
    [self.view  addSubview:_scoreLabel];
  
#pragma mark - SentenceAudioBtn
   
    CGFloat btnWidth = 40;
    CGFloat btnHeight = 30;
    
    _playSentenceAudioBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW/4-btnWidth/2, screenH - btnHeight, btnWidth , btnHeight)];
    [_playSentenceAudioBtn setImage:[UIImage imageNamed:@"playAudio.png"] forState:UIControlStateNormal];
    [_playSentenceAudioBtn addTarget:self action:@selector(playSentenceAudio:) forControlEvents:UIControlEventTouchUpInside];
  
#pragma mark - TranslationBtn
    _showSentenceTranslationBtn = [[UIButton alloc] initWithFrame:CGRectMake(screenW/4*3 - btnWidth/2, screenH - btnHeight, btnWidth , btnHeight)];
    [_showSentenceTranslationBtn setImage:[UIImage imageNamed:@"help.png"] forState:UIControlStateNormal];
    [_showSentenceTranslationBtn addTarget:self action:@selector(showSentenceTranslation) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view  addSubview:_playSentenceAudioBtn];
    [self.view  addSubview:_showSentenceTranslationBtn];
}


-(void)playSentenceAudio:(UIButton *)sender
{
 
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOpenAudioEffect"] boolValue])
    {
        MBProgressHUD * hud = [MBProgressHUD showMessage:@"音效已关闭"];
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1];
       
        return;
    }
    
    if(self.playCurrentAudioCount >1)
    {
        [MBProgressHUD show:@"一个句子最多读俩次哦~" icon:@"搜索框" view:self.view afterDelay:1.0];
        return;
    }
    
    else
    {
        self.playCurrentAudioCount ++;
        sender.userInteractionEnabled = NO;
        NSInteger currentChapterIndex = [TNDataContainer sharedDataContainer].chapterIndex;
        NSInteger currentSentenceIndex = [TNDataContainer sharedDataContainer].sentenceIndex;
        
        AVAudioPlayer *player =[TNSMusicTool playMusicWithFilename:[NSString stringWithFormat:@"%ld-%ld.mp3",(long)currentChapterIndex,(long)currentSentenceIndex]];
           dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(player.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            sender.userInteractionEnabled = YES;
        });
    }
}


-(void)showSentenceTranslation
{
    UITextView *translationView = [[UITextView alloc] init];
    translationView.editable = NO;
    translationView.selectable = NO;
    
    translationView.size = CGSizeMake(200, 100);
    translationView.layer.cornerRadius = translationView.size.height * 0.2;
    translationView .center = CGPointMake(screenW/2, screenH/2);
    translationView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"readingTextViewBG.png"]];
    
    
    self.view.alpha = 0.7;
    self.view.userInteractionEnabled = NO;
    [[UIApplication sharedApplication].keyWindow  addSubview: translationView];
    
 
    NSInteger currentChapterIndex = [TNDataContainer sharedDataContainer].chapterIndex;
    NSInteger currentSentenceIndex = [TNDataContainer sharedDataContainer].sentenceIndex;
    
    NSString *currentSentenceTranslation = [[TNDataContainer sharedDataContainer] cnCurrentSentenceWithIndex:currentSentenceIndex AndChapterIndex:currentChapterIndex];
    
    translationView.text = currentSentenceTranslation;

#pragma mark - tapGesture
    UITapGestureRecognizer *tranViewTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showTranlationView:)];
    [translationView addGestureRecognizer:tranViewTap];
  
}

// tapGesture - remove translationView 
-(void)showTranlationView:(UITapGestureRecognizer *)tranViewTap
{
    [tranViewTap.view removeFromSuperview];
    self.view.alpha = 1.0;
    self.view.userInteractionEnabled = YES;
}

//label font
-(void)setFontSizeForLongTextInLabel :(UILabel *)label
{
     [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10.0]];//加粗
     label.adjustsFontSizeToFitWidth = YES;
     [ label setTextAlignment:NSTextAlignmentCenter];
}

//location
- (unsigned long )array2StartY
{
    unsigned long y = 0;
    
    y = _modelArray1.count/grid_per_Row + 2;
    if (_modelArray1.count%grid_per_Row == 0) {
        y -= 1;
    }
    return y;
}



-(void)dealloc
{ 
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end