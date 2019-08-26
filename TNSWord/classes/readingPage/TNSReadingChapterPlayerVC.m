//
//  TNSReadingChapterPlayerVC.m
//  TNSWord
//
//  Created by mac on 15/7/30.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSReadingChapterPlayerVC.h"

#import "TNSMusicTool.h"
#import "TNDataContainer.h"
#import <AVFoundation/AVFoundation.h>

@interface TNSReadingChapterPlayerVC ()<AVAudioPlayerDelegate>
@property (strong,nonatomic) AVAudioPlayer *player;
@property (strong,nonatomic) NSTimer *progressTimer;
@property (strong,nonatomic) NSMutableArray *musicArray;
@property (strong,nonatomic) NSString * currentMusicName;

@property (weak, nonatomic) IBOutlet UIButton *currentTimeView;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UIView *progressDurationBar;
@property (weak, nonatomic) IBOutlet UIButton *slider;
@property (weak, nonatomic) IBOutlet UIView *progressView;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *sliderSpaceToLeft;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *progressViewWidth;


- (void)addProgressTimer;
- (void)removeProgressTimer;
- (IBAction)onProgressBgTap:(id)sender;
- (IBAction)onPanSlider:(UIPanGestureRecognizer *)sender;
- (IBAction)playOrPause;

@end

@implementation TNSReadingChapterPlayerVC


-(NSString *)currentMusicName
{
    if (_currentMusicName == nil)
    {
        NSInteger currentChapterIndex = [TNDataContainer sharedDataContainer].chapterIndex;
        if (currentChapterIndex < [TNDataContainer sharedDataContainer].chapters.count)
        {
            _currentMusicName = [[NSString alloc] initWithString:[NSString stringWithFormat:@"W%ld.mp3",(long)currentChapterIndex  ]];
        }
        else
        {
            NSLog(@"数组越界 ");
        }
    }
    
    return _currentMusicName;
}


////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.currentTimeView.layer.cornerRadius = 8;
    self.progressDurationBar.userInteractionEnabled = NO;
    self.slider.userInteractionEnabled = NO;
    
 
    
}


- (void)startPlayingMusic
{
    self.player = [TNSMusicTool playMusicWithFilename:self.currentMusicName];
    self.player.delegate = self;
    self.playOrPauseButton.selected = YES;
 
    self.durationLabel.text = [self strWithTimeInterval:self.player.duration];
    [self addProgressTimer];
}



- (void)addProgressTimer
{
    if(self.player.playing == NO) return;
    [self updateCurrentProgress];
    self.progressTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target:self selector:@selector(updateCurrentProgress) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
}


- (NSString *)strWithTimeInterval:(NSTimeInterval)interval
{
    int m = interval / 60;
    int s = (int)interval % 60;
    return [NSString stringWithFormat:@"%02d:%02d", m , s];
}

- (void)removeProgressTimer
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}


- (void)updateCurrentProgress
{
    double progress = self.player.currentTime / self.player.duration;
    double sliderMaxX = self.view.width - self.slider.width;
    
    self.slider.x = sliderMaxX * progress;
    self.progressView.width = self.slider.center.x ;
    
    self.sliderSpaceToLeft.constant = sliderMaxX * progress;
    self.progressViewWidth.constant = self.slider.center.x;
    
    [self.slider setTitle:[self strWithTimeInterval:self.player.currentTime] forState:UIControlStateNormal] ;
    
}

///////////////////////////////////////// userInteration //////////////////////////////////////

// tap event on progress
- (IBAction)onProgressBgTap:(UIGestureRecognizer *)sender
{
#warning  there is a case : user may drag the progress btn when the audio has never been played before -- this action will trigger a crash since the layer has not been created yet -- so here we set a constraint that user should tap the "play btn" at least once, otherwise they could not be able to drag or tap the progress bar
    
    CGPoint point =  [sender locationInView:sender.view];
    self.slider.x = point.x;
    double progress = point.x / sender.view.width;
    self.player.currentTime = progress * self.player.duration;
    
    [self updateCurrentProgress];
   
}


//pan event
- (IBAction)onPanSlider:(UIPanGestureRecognizer *)sender
{
    
    CGPoint point =  [sender translationInView:sender.view];
    
    [sender setTranslation:CGPointZero inView:sender.view];
    self.slider.x += point.x;
    self.sliderSpaceToLeft.constant += point.x;
    CGFloat sliderMaxX = self.view.width - self.slider.width;
    
    if (self.slider.x < 0)
    {
        self.slider.x = 0;
        self.sliderSpaceToLeft.constant = 0;
    }
    else if (self.slider.x > sliderMaxX)
    {
        self.slider.x = sliderMaxX;
        self.sliderSpaceToLeft.constant = sliderMaxX;
    }
    
    self.progressView.width = self.slider.center.x;
    self.progressViewWidth.constant = self.slider.center.x;
    
    double progress = self.slider.x / sliderMaxX;
    NSTimeInterval time = progress * self.player.duration;
   
    [self.slider setTitle:[self strWithTimeInterval:time] forState:UIControlStateNormal];
    [self.currentTimeView setTitle:[self strWithTimeInterval:time] forState:UIControlStateNormal];
    self.currentTimeView.x = self.slider.x;
    self.currentTimeView.y = self.slider.y - 30;
    
    if (sender.state == UIGestureRecognizerStateBegan)
    {
        self.currentTimeView.hidden = NO;
        [self removeProgressTimer];
    }
    
    else if (sender.state == UIGestureRecognizerStateEnded)
    {
        self.currentTimeView.hidden = YES;
        self.player.currentTime  = time;
        if (self.player.playing)
        {
            [self addProgressTimer];
        }
    }
    
}



- (IBAction)playOrPause
{
    
    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOpenAudioEffect"] boolValue])
    {
        MBProgressHUD * hud = [MBProgressHUD showMessage:@"音效已关闭"];
        hud.mode = MBProgressHUDModeText;
        [hud hide:YES afterDelay:1];
        self.playOrPauseButton.selected = NO;
        return;
    }
    
    
    if (self.playOrPauseButton.selected)
    {
        self.playOrPauseButton.selected = NO;
        [TNSMusicTool pauseMusicWithFilename:self.currentMusicName];
    }
    
    else
    {
        
        self.playOrPauseButton.selected = YES;
        
        if((!self.progressDurationBar.userInteractionEnabled) || (!self.slider.userInteractionEnabled))
        {
            self.progressDurationBar.userInteractionEnabled = YES;//总的背景进度长条
            self.slider.userInteractionEnabled = YES;//滑块
        }
       
        
        [self startPlayingMusic];
    }
}


/////////////////////////////////////////  AVAudioPlayerDelegate ////////////////////////////////////////


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
 
    [TNSMusicTool pauseMusicWithFilename:self.currentMusicName];
 
    self.playOrPauseButton.selected = NO;
    [self removeProgressTimer];
}


- (void)audioPlayerBeginInterruption:(AVAudioPlayer *)player
{
    if (self.player.playing)
    {
        [TNSMusicTool pauseMusicWithFilename:self.currentMusicName];
    }
}

- (void)audioPlayerEndInterruption:(AVAudioPlayer *)player
{
    if (!self.player.playing)
    {
        [self startPlayingMusic];
    }
}

 
-(void)viewWillDisappear:(BOOL)animated
{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
    [TNSMusicTool stopMusicWithFilename:_currentMusicName ];
}

@end
