//
//  TNTouchView.m
//  TNGameBtnPageDemo
//
//  Created by mac on 15/7/20.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNTouchView.h"
#import "TNTouchViewModel.h"

@interface TNTouchView ()

@property(nonatomic,assign) NSInteger  rightWordCount;
@property(nonatomic,assign) NSInteger  lastRightWordCount;

@end


@implementation TNTouchView


-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.multipleTouchEnabled = YES;
        self.userInteractionEnabled = YES;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        _titleArray =  [NSMutableArray arrayWithArray:[TNDataContainer sharedDataContainer].currentTitleArray];
        self.label = label;
        _sign = 0;
   }
    return self;
}



//label's frame
 
-(void)layoutSubviews
{
    [self.label setFrame:CGRectMake(1, 1, KButtonWidth -2   , KButtonHeight-2 )];
    self.label.clipsToBounds = YES;
    [self.label setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];

    [self addSubview:self.label];
}




////////////////////////////////////////// touch event ////////////////////////////////////////////////////////

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    _point = [touch locationInView:self];
    _point2 = [touch locationInView:self.superview];
    
    [self.superview exchangeSubviewAtIndex:[self.superview.subviews indexOfObject:self] withSubviewAtIndex: [self.superview subviews].count - 1];
    
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.label setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];
    
    [self setImage:nil];
    
   
    if((_sign == 0) && (self.label.tag != touchViewTagBase))
    {
        
        if (_array == _viewArray11)
        {
            [_viewArray11 removeObject:self];
            [_viewArray22 insertObject:self atIndex:_viewArray22.count];
            _array = _viewArray22;
        }
        else if(_array == _viewArray22)
        {
            [_viewArray22 removeObject:self];
            [_viewArray11 insertObject:self atIndex:_viewArray11.count];
            _array = _viewArray11;
        }
        
    }
    
    [self animationAction];
    
    _sign = 0;
    [self feedbackAndCheckAnswer];
    
}





-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
 
    _sign = 1;
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self.superview];
   
    if ( self.label.tag != touchViewTagBase )
    {
        
        [self.label setBackgroundColor:[UIColor clearColor]];
        [self setImage:[UIImage imageNamed:@"order_drag_move_bg.png"]];
 
        [self setFrame:CGRectMake(point.x - _point.x, point.y - _point.y, self.frame.size.width, self.frame.size.height)];
    
        CGFloat newX = point.x - _point.x + KButtonWidth/2;
        CGFloat newY = point.y - _point.y + KButtonHeight/2;
    
        if (!CGRectContainsPoint( ((TNTouchView *)[_viewArray11 objectAtIndex:0]).frame, CGPointMake(newX, newY)))
        {
            
            if (_array == _viewArray22)
            {
                if ([self buttonInArrayArea1:_viewArray11 Point:point])
                {
                    
                    int index = ((int)newX - KTableStartPointY)/KButtonWidth +(grid_per_Row *(((int)newY - KTableStartPointY)/KButtonHeight));
                    
                    
                     [_array removeObject:self];
                     [_viewArray11 insertObject:self atIndex:index];
                     _array = _viewArray11;
                  
                    [self animationAction1];
                    [self animationAction2];
                }
                
                else if (newY < KTableStartPointY + [self array2StartY] * KButtonHeight+ KDeltaHeight    &&![self buttonInArrayArea1:_viewArray11 Point:point])
                {
                    
                    [ _array removeObject:self];
                    [_viewArray11 insertObject:self atIndex:_viewArray11.count];
                    _array = _viewArray11;
                    [self animationAction2];
                    
                }
                
                else if([self buttonInArrayArea2:_viewArray22 Point:point])
                {
                    unsigned long index = ((unsigned long )(newX) - KTableStartPointX)/KButtonWidth + (grid_per_Row * (((int)(newY) - [self array2StartY] * KButtonHeight - KTableStartPointY - KDeltaHeight)/KButtonHeight));
                    [ _array removeObject:self];
                    [_viewArray22 insertObject:self atIndex:index];
  
                    [self animationAction2a ];
                    
                }
                
                else if(newY > KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight   &&![self buttonInArrayArea2:_viewArray22 Point:point])
                {
                    [ _array removeObject:self];
                    [_viewArray22 insertObject:self atIndex:_viewArray22.count];
                    [self animationAction2a];
                    
                }
            }
            else if ( _array == _viewArray11)
            {
                
                if ([self buttonInArrayArea1:_viewArray11 Point:point])
                {
                    int index = ((int)newX - KTableStartPointX)/KButtonWidth + (grid_per_Row * (((int)(newY) - KTableStartPointY)/KButtonHeight));
                    [ _array removeObject:self];
                    [_viewArray11 insertObject:self atIndex:index];
                    _array = _viewArray11;
                    
                    [self animationAction1a];
                    [self animationAction2];
                }
               

                else if (newY < KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight  &&![self buttonInArrayArea1:_viewArray11 Point:point]){
                    [ _array removeObject:self];
                    [_viewArray11 insertObject:self atIndex: _array.count];
                    [self animationAction1a];
                    [self animationAction2];
                }
                

                else if([self buttonInArrayArea2:_viewArray22 Point:point]){
                    unsigned long index = ((unsigned long)(newX) - KTableStartPointX)/KButtonWidth + (grid_per_Row * (((int)(newY) - [self array2StartY] * KButtonHeight - KDeltaHeight - KTableStartPointY)/KButtonHeight));
                    [ _array removeObject:self];
                    [_viewArray22 insertObject:self atIndex:index];
                    _array = _viewArray22;
                    [self animationAction2a];
                }
                
                else if(newY > KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight  &&![self buttonInArrayArea2:_viewArray22 Point:point]){
                    [ _array removeObject:self];
                    [_viewArray22 insertObject:self atIndex:_viewArray22.count];
                    _array = _viewArray22;
                    [self animationAction2a];
                    
                }
            }
        }
    }
    
}

////////////////////////////////////////// ///////// ////////////////////////////////////////////////////////

////////////////////////////////////////// animation ////////////////////////////////////////////////////////


- (void)animationAction1
{
    for (int i = 0; i < _viewArray11.count; i++)
    {
 
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            [[_viewArray11 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%grid_per_Row) * KButtonWidth, KTableStartPointY + (i/grid_per_Row)* KButtonHeight, KButtonWidth, KButtonHeight)];
        } completion:^(BOOL finished){
            
        }];
    }
}

- (void)animationAction1a
{
    for (int i = 0; i < _viewArray11.count; i++)
    {
 
        if ([_viewArray11 objectAtIndex:i] != self)
        {
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                [[_viewArray11 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%grid_per_Row) * KButtonWidth, KTableStartPointY + (i/grid_per_Row)* KButtonHeight, KButtonWidth, KButtonHeight)];
            } completion:^(BOOL finished){
                
            }];
        }
    }
    
}

- (void)animationAction2
{
    for (int i = 0; i < _viewArray22.count; i++)
    {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            [[_viewArray22 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%grid_per_Row) * KButtonWidth, KTableStartPointY + [self array2StartY] * KButtonHeight + KDeltaHeight + (i/grid_per_Row)* KButtonHeight, KButtonWidth, KButtonHeight)];
            
        } completion:^(BOOL finished){
            
        }];
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self.moreChannelsLabel setFrame:CGRectMake(self.moreChannelsLabel.frame.origin.x, KTableStartPointY + KButtonHeight * ([self array2StartY] - 1) + KMoreChannelDeltaHeight, self.moreChannelsLabel.frame.size.width, self.moreChannelsLabel.frame.size.height)];
        
    } completion:^(BOOL finished){
        
    }];
}

- (void)animationAction2a
{
    for (int i = 0; i < _viewArray22.count; i++)
    {
        if ([_viewArray22 objectAtIndex:i] != self)
        {
            
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                
                
                [[_viewArray22 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%grid_per_Row) * KButtonWidth, KTableStartPointY + [self array2StartY] * KButtonHeight + KDeltaHeight  + (i/grid_per_Row)* KButtonHeight, KButtonWidth, KButtonHeight)];
                
            } completion:^(BOOL finished){
            }];
        }
        
    }
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self.moreChannelsLabel setFrame:CGRectMake(self.moreChannelsLabel.frame.origin.x, KTableStartPointY + KButtonHeight * ([self array2StartY] - 1) + KMoreChannelDeltaHeight, self.moreChannelsLabel.frame.size.width, self.moreChannelsLabel.frame.size.height)];
        
    } completion:^(BOOL finished){
        
    }];
}


- (void)animationAction
{
    
    for (int i = 0; i < _viewArray11.count; i++)
    {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            [[_viewArray11 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%grid_per_Row) * KButtonWidth, KTableStartPointY + (i/grid_per_Row)* KButtonHeight, KButtonWidth, KButtonHeight)];
        } completion:^(BOOL finished){
            
        }];
    }
   
    for (int i = 0; i < _viewArray22.count; i++)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
            
            [[_viewArray22 objectAtIndex:i] setFrame:CGRectMake(KTableStartPointX + (i%grid_per_Row) * KButtonWidth, KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight   + (i/grid_per_Row)* KButtonHeight, KButtonWidth, KButtonHeight)];
            
        } completion:^(BOOL finished){
            
        }];
    }
    
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        
        [self.moreChannelsLabel setFrame:CGRectMake(self.moreChannelsLabel.frame.origin.x, KTableStartPointY + KButtonHeight * ([self array2StartY] - 1) + KMoreChannelDeltaHeight, self.moreChannelsLabel.frame.size.width, self.moreChannelsLabel.frame.size.height)];
        
    } completion:^(BOOL finished){
        
    }];
    
}

////////////////////////////////////////// ///////// ////////////////////////////////////////////////////////

#pragma mark -  feedback && checkAnswer  【called when touch End】
-(void)feedbackAndCheckAnswer

{
    if ([TNDataContainer sharedDataContainer].rightWordCount == 0) {[TNDataContainer sharedDataContainer].rightWordCount = 1;};
    if ([TNDataContainer sharedDataContainer].lastRightWordCount== 0) {[TNDataContainer sharedDataContainer].lastRightWordCount = 1;}
    [TNDataContainer sharedDataContainer].rightWordCount = 1 ;
    
    NSMutableArray *userTitleArray= [NSMutableArray array ];
    for (int i = 0; i < _viewArray11.count; i++)
        
    {
        TNTouchView *view = _viewArray11[i];
        if(i)
        {
            if( [view.label.text isEqualToString:_titleArray[i]])
                
            {
                view.label.backgroundColor = [UIColor orangeColor];
                
                [TNDataContainer sharedDataContainer].rightWordCount++;
                
            }
            else
            {
                [view.label setBackgroundColor:[UIColor colorWithRed:239/255.0 green:239/255.0 blue:239/255.0 alpha:1.0]];
            }
        }
        
        [userTitleArray addObject:view.label.text];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"scoreDidChange" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInteger:[TNDataContainer sharedDataContainer].rightWordCount],@"newScore", nil]];
    
    if([userTitleArray isEqualToArray:_titleArray])
        
    {
        
        [MBProgressHUD showSuccess:@"非常棒! 成功咯~" toView:self.superview];
        [TNSMusicTool playAudioWithFilename:@"bomb.mp3"];
        
        
        NSMutableArray * arrayChapter = [NSMutableArray arrayWithContentsOfFile:gameChapterATPath];
        NSMutableArray * arraySentence = [arrayChapter objectAtIndex:[TNDataContainer sharedDataContainer].chapterIndex];
        NSMutableDictionary *currentSentenceDict = [arraySentence objectAtIndex:[TNDataContainer sharedDataContainer].sentenceIndex];
        
        
        NSDate * date = [NSDate date];
        NSTimeInterval sec = [date timeIntervalSinceNow];
        NSDate * lastSuccessDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
        
        currentSentenceDict[@"lastSuccessDate"] = lastSuccessDate;
        
        NSNumber *didSuccess = [NSNumber numberWithBool:YES];
        currentSentenceDict[@"didSuccess"] = didSuccess;
        
        [arrayChapter writeToFile:gameChapterATPath atomically:YES];
        
    }
    
    if([TNDataContainer sharedDataContainer].rightWordCount > [TNDataContainer sharedDataContainer].lastRightWordCount)
    {
        if([userTitleArray isEqualToArray:_titleArray])
        {
            return;
        }
        [TNSMusicTool playAudioWithFilename:@"crrect_answer3.mp3"];
    }
    else
    {
        if([userTitleArray isEqualToArray:_titleArray])
        {
            return;
        }
        [TNSMusicTool playAudioWithFilename:@"gameMoveError.mp3"];
    }
    [TNDataContainer sharedDataContainer].lastRightWordCount = [TNDataContainer sharedDataContainer].rightWordCount;
    
}



-(BOOL)buttonInArrayArea1:(NSMutableArray *)arr Point:(CGPoint)point
{
    CGFloat newX = point.x - _point.x + KButtonWidth/2;
    CGFloat newY = point.y - _point.y + KButtonHeight/2;
    
    int a = arr.count % grid_per_Row;
    unsigned long b = arr.count/grid_per_Row;
    
    if (
        
        (newX > KTableStartPointX && newX < KTableStartPointX + grid_per_Row * KButtonWidth && newY > KTableStartPointY && newY < KTableStartPointY + b * KButtonHeight) ||
        
        (newX > KTableStartPointX && newX < KTableStartPointX + a * KButtonWidth && newY > KTableStartPointY + b * KButtonHeight && newY < KTableStartPointY + (b+1) * KButtonHeight) )
    {
        return YES;
    }
    return NO;
    
}


- (BOOL)buttonInArrayArea2:(NSMutableArray *)arr Point:(CGPoint)point
{
    CGFloat newX = point.x - _point.x + KButtonWidth/2;
    CGFloat newY = point.y - _point.y + KButtonHeight/2;
    int a =  arr.count%grid_per_Row;
    unsigned long b =  arr.count/grid_per_Row;
    if (
        (newX > KTableStartPointX && newX < KTableStartPointX + grid_per_Row * KButtonWidth && newY > KTableStartPointY + KDeltaHeight + [self array2StartY] * KButtonHeight   && newY < KTableStartPointY + KDeltaHeight + (b + [self array2StartY]) * KButtonHeight ) ||
        
        (newX > KTableStartPointX && newX < KTableStartPointX + a * KButtonWidth && newY > KTableStartPointY + KDeltaHeight + (b + [self array2StartY]) * KButtonHeight && newY < KTableStartPointY  +KDeltaHeight + (b+1 +[self array2StartY]) * KButtonHeight) )
    {
        return YES;
    }
    return NO;
}


- (unsigned long)array2StartY
{
    unsigned long y = 0;
 
    
    unsigned long totalColsOfArea1;
    
    if(_viewArray11.count%grid_per_Row != 0)
    {
          totalColsOfArea1 = _viewArray11.count/grid_per_Row + 1;// _viewArray11.count/5  有余数，得多加一行才是真正行数
    }
    
    else
    {
        totalColsOfArea1 = _viewArray11.count/grid_per_Row;
    }
     y = totalColsOfArea1;
    return y;
}

@end
