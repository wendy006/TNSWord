//
//  TNWordCell.m
//  TNWord
//
//  Created by mac on 15/6/22.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNWordCell.h"
#import <AVFoundation/AVFoundation.h>
#import "FMDB.h"

@interface TNWordCell()

@property(nonatomic,strong)FMDatabase *db;
@property(nonatomic,strong)AVAudioPlayer * musicPlayer;
@property (weak, nonatomic) IBOutlet UIView *baseView;

@end

@implementation TNWordCell


- (void)awakeFromNib
{
      self.baseView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroud.jpg"]];
}



- (IBAction)audioBtnDidPressed:(id)sender
{ }


- (IBAction)addToOkBtnDidPressed:(id)sender
{ }

@end
