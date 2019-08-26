//
//  TNSMusicTool.m
//  TNSWord
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSMusicTool.h"

@implementation TNSMusicTool
SingletonM(MusicTool)


+ (void)initialize
{
    AVAudioSession *session = [[AVAudioSession alloc] init];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
}


static NSMutableDictionary *_soundIDs;
static NSMutableDictionary *_players;

+ (NSMutableDictionary *)soundIDs
{
    if (!_soundIDs) {
        _soundIDs = [NSMutableDictionary dictionary];
    }
    return _soundIDs;
}
+ (NSMutableDictionary *)players
{
    if (!_players) {
        _players = [NSMutableDictionary dictionary];
    }
    return _players;
}




///////////////////////////////////////////////////////////////////////////////////////////////

+ (void)playShortAudioInWordBookWithFilename:(NSString *)word
{
//    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOpenAudioEffect"] boolValue]) return;
    if (word == nil)  return;
    
    SystemSoundID soundID = [[self soundIDs][word] unsignedIntValue];
 
    if (!soundID)
    {
        NSURL *url = [[[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp3",word]];
        
        if (!url)  return;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
        [self soundIDs][word] = @(soundID);
    }
    
    AudioServicesPlaySystemSound(soundID);
}



+ (void)playAudioWithFilename:(NSString *)filename
{
 
    if (filename == nil)   return;
    
    SystemSoundID soundID = [[self soundIDs][filename] unsignedIntValue];
    if (!soundID)
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
 
        if (!url)  return;
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)(url), &soundID);
       [self soundIDs][filename] = @(soundID);
    }
 
    AudioServicesPlaySystemSound(soundID);
}



+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename
{
    if (filename == nil)  return nil;
    
    AVAudioPlayer *player = [self players][filename];
 
    if (!player)
    {
        NSURL *url = [[NSBundle mainBundle] URLForResource:filename withExtension:nil];
      
        if (!url)  return nil;
        player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
        
        if(![player prepareToPlay]) return nil;
        
        [self players][filename] = player;
        
    }
    
    if (!player.playing)
    {
        [player play];
    }
    
    return player;
}


+ (void)pauseMusicWithFilename:(NSString  *)filename
{
    if (filename == nil) return;
    AVAudioPlayer *player = [self players][filename];
    
    if(player)
    {
        if (player.playing)
        {
            [player pause];
        }
    }
    
}


+ (void)stopMusicWithFilename:(NSString  *)filename
{
    if (filename == nil) return;
    AVAudioPlayer *player = [self players][filename];
 
    if (player)
    {
        [player stop];
        [[self players] removeObjectForKey:filename];
    }
}
 
@end
