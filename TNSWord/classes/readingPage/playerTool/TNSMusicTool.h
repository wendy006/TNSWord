//
//  TNSMusicTool.h
//  TNSWord
//
//  Created by mac on 15/7/29.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "Singleton.h"

@interface TNSMusicTool : NSObject
SingletonH(MusicTool)

+ (void)playAudioWithFilename:(NSString  *)filename;
+ (AVAudioPlayer *)playMusicWithFilename:(NSString  *)filename;
+ (void)pauseMusicWithFilename:(NSString  *)filename;
+ (void)stopMusicWithFilename:(NSString  *)filename;

//for wordbook
+ (void)playShortAudioInWordBookWithFilename:(NSString *)word;




@end
