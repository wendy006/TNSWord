//
//  TNSTimeManagerTCell.m
//  TNSWord
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSTimeManagerTCell.h"
#import "TNSChapterReadingTimeManager.h"
#import "TNSSentenceGameTimeManager.h"
 

@interface  TNSTimeManagerTCell()<UIPickerViewDataSource, UIPickerViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *timeCellImageView;

@property (weak, nonatomic) IBOutlet UILabel *timeCellReadingLabel;

@property (weak, nonatomic) IBOutlet UIPickerView *timeCellSentenceGamePickerView;

@property(nonatomic,strong) TNSChapterReadingTimeManager *ChapterReadingTimeManager;

@property(nonatomic,strong) NSMutableArray *sentenceGameTimeManagerArray;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pickerViewSpaceToLeft;

@end



@implementation TNSTimeManagerTCell

//lazyload dataSource
-(TNSChapterReadingTimeManager *)ChapterReadingTimeManager
{
    if (_ChapterReadingTimeManager == nil)
    {
        
        NSInteger chapterIndex = [TNDataContainer sharedDataContainer].timeManagerTBVChapterIndex;
        _ChapterReadingTimeManager = [TNSChapterReadingTimeManager createReadingTimeManagerWithChapterIndex:chapterIndex];
    }
    return _ChapterReadingTimeManager;
}


-(NSMutableArray *)sentenceGameTimeManagerArray
{
    if (_sentenceGameTimeManagerArray == nil)
    {
        _sentenceGameTimeManagerArray = [NSMutableArray array];
 
        NSInteger chapterIndex = [TNDataContainer sharedDataContainer].timeManagerTBVChapterIndex;
        NSInteger sentenceCount = [[TNDataContainer sharedDataContainer] enSentenceArrayInChapterWithIndex:chapterIndex].count;
        
        for (int i = 0; i < sentenceCount; i++)
        {
            TNSSentenceGameTimeManager * manager = [TNSSentenceGameTimeManager createSentenceTimeManagerWithChapterIndex:chapterIndex AndSentenceIndex:i];
            [_sentenceGameTimeManagerArray addObject:manager];
        }
        
        
    }
    
    return _sentenceGameTimeManagerArray;
}

/**
 *  initiate
 */
- (void)awakeFromNib
{
    //0.color and layout
    self.timeCellSentenceGamePickerView .backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroud.jpg"]];
    
    self.timeCellReadingLabel.backgroundColor =  [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroud.jpg"]];
    
    self.pickerViewSpaceToLeft.constant = self.timeCellImageView.width / 320.0 * screenW - 10;
    
    //1.pickerView delegate
    self.timeCellSentenceGamePickerView.delegate = self;
 
    //2.could be polished
    NSInteger chapterIndex = [TNDataContainer sharedDataContainer].timeManagerTBVChapterIndex;
    
    //image
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld_gameC.png",(long)chapterIndex]  ] ;
    image  = [UIImage circleImageWithImage:image borderWidth:1 borderColor:[UIColor grayColor]];
    [self.timeCellImageView setImage:image];
 
    //3. initiate readingChapterLabel
    if ([self.ChapterReadingTimeManager.lastReadingDate isEqualToString:@""])
    {
        self.timeCellReadingLabel.text = @"reading - 暂无记录";
    }
    else
    {
        self.timeCellReadingLabel.text = [NSString stringWithFormat:@"reading - 最近:%@; 总时长:%@",self.ChapterReadingTimeManager.lastReadingDate, self.ChapterReadingTimeManager.totalReadingTime ];
    }
    self.timeCellReadingLabel.textAlignment = NSTextAlignmentCenter;
    [self.timeCellReadingLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10.0]];//加粗
    self.timeCellReadingLabel.adjustsFontSizeToFitWidth = YES;
    
 
    self.backgroundColor = [UIColor clearColor];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    
 
#pragma mark - default selection is the middle row
    int defaultSelectedRow = (int) ((self.sentenceGameTimeManagerArray.count - 1)/2);
    [self.timeCellSentenceGamePickerView selectRow:defaultSelectedRow inComponent:0 animated:YES];
    
    //manually call once when first turn to timeManage page
    [self pickerView:self.timeCellSentenceGamePickerView didSelectRow:defaultSelectedRow inComponent:0];
   
    
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////




#pragma  - mark pickerView

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}


- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.sentenceGameTimeManagerArray.count;
}


-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *label = [[UILabel alloc]init] ;
    
    if (view != nil)
    {
        label = (UILabel *) view;
        //设置bounds
        label.bounds = CGRectMake(0, 0, 200, 20);
    }
    else
    {
        label = [[UILabel alloc] init];
    }
    
    
    if ([[self.sentenceGameTimeManagerArray[row] lastSuccessDate] isEqualToString:@""])
    {
        
        label.text = [NSString stringWithFormat:@"第 %d 句--暂无记录",row + 1  ];
    }
    else
    {
        NSString *lastSuccessDate = [self.sentenceGameTimeManagerArray[row] lastSuccessDate];
        label.text = [NSString stringWithFormat:@"第 %d 句--%@",row + 1,lastSuccessDate];
        
        
    }
    
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont fontWithName:@"Helvetica-Bold" size:10.0]];
    label.adjustsFontSizeToFitWidth = YES;
    
    return label;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    UIView * currentSelectedView = [self.timeCellSentenceGamePickerView viewForRow:row forComponent:0];
    currentSelectedView .userInteractionEnabled = NO;
    
    if (![[self.sentenceGameTimeManagerArray[row] lastSuccessDate] isEqualToString:@""])
    {
        //change color if had passed once
        [self.timeCellSentenceGamePickerView viewForRow:row forComponent:0].backgroundColor = [UIColor orangeColor];
    }
    
 
}



-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
        return 100;
}


-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 20;
}
 

@end
