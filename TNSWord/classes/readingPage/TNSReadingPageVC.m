//
//  TNSReadingPageVC.m
//  TNSWord
//
//  Created by mac on 15/7/28.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSReadingPageVC.h"
#import "TNChapter.h"
#import "AFNetworking.h"
#import "TNShanbayViewController.h"
#import "TNSReadingChapterPlayerVC.h"

@interface TNSReadingPageVC ()<UIAppearanceContainer>

//VC
@property(nonatomic,strong) TNSReadingChapterPlayerVC *readingChapterPlayerVC ;
@property(nonatomic,strong) TNShanbayViewController *shanbayVC;

//UI
@property(nonatomic,strong) UIBarButtonItem *jumpToTranslationTextBarBtn;
@property(nonatomic,strong) UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewSpaceToBottom;


//dataSource
@property(nonatomic,strong) TNChapter *currentChapter;
@property(nonatomic,assign) NSInteger currentChapterIndex;


// useless temporarily
@property(nonatomic,assign) CGPoint translationContentOffset;
@property(nonatomic,assign) CGPoint englishContentOffset;

@end




@implementation TNSReadingPageVC

//for jumpToTranslationText
static bool didSwitchLanguage = NO;

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self )
    {
        self.contentTextView.contentOffset = _offsetForTextView;
    }
    
    return self;
}

-(TNShanbayViewController *)shanbayVC
{
    if (_shanbayVC == nil)
    {
        _shanbayVC = [[TNShanbayViewController alloc] initWithNibName:@"TNShanbayViewController" bundle:nil];
    }
    return _shanbayVC;
}

-(NSMutableArray *)chapters
{
    if (!_chapters)
    {
        _chapters = [[TNDataContainer sharedDataContainer].chapters mutableCopy];
    }
    return _chapters;
}

-(TNChapter *)currentChapter
{
    if (_currentChapter == nil)
    {
        _currentChapter = [[TNChapter alloc] init];
    }
    
    _currentChapter = [self.chapters objectAtIndex:[TNDataContainer sharedDataContainer].chapterIndex] ;
     return _currentChapter;
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentTextViewSpaceToBottom.constant = 45.0/480.0 * screenH;
    
    
    self.contentTextView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"readingTextViewBG.png"]];
    
    self.contentTextView.showsVerticalScrollIndicator = NO;

#pragma mark -  playerVC
    
    _readingChapterPlayerVC = [[TNSReadingChapterPlayerVC alloc] initWithNibName:@"TNSReadingChapterPlayerVC" bundle:nil];
 
    
    [self.view addSubview: _readingChapterPlayerVC.view];
    [self addChildViewController:_readingChapterPlayerVC];
    [_readingChapterPlayerVC didMoveToParentViewController:self];
    
    _readingChapterPlayerVC.view.y = screenH - self.contentTextViewSpaceToBottom.constant;
    [ _readingChapterPlayerVC.view setHeight:45.0/480 * screenH ];

#warning without these codes,setHeight for playerVC can not work 【autoLayout】
    [_readingChapterPlayerVC.view mas_makeConstraints:^(MASConstraintMaker *make)
    {
        make.left.equalTo(self.view).with.offset(0);
        make.right.equalTo(self.view).with.offset(0);
        make.bottom.equalTo(self.view).with.offset(0);
        make.height.mas_equalTo(@(45.0/480 * screenH));
    }];
  
    
    self.contentTextView.editable = NO;
    self.contentTextView.selectable = NO;
    
//textView
    
    [self setTextWithFontname:@"AmericanTypewriter-Bold" textContent:self.currentChapter.content_for_reading];

//readingVC's  naviBar
    
    _titleLabel = [[UILabel alloc] init];
    _currentChapterIndex = [TNDataContainer sharedDataContainer].chapterIndex;
    _titleLabel.text = [NSString stringWithFormat:@"%d.%@",_currentChapterIndex + 1 ,self.currentChapter.title ];
    [self setTitleLabelFormat];
    self.navigationItem.titleView = _titleLabel;
    
    
    UIBarButtonItem *rightBarBtnItem = [[UIBarButtonItem alloc ]initWithImage: [UIImage imageNamed:@"showTranslation.png"] style:UIBarButtonItemStylePlain target:self action:@selector(jumpToTranslationText:)];
    self.navigationItem.rightBarButtonItem = rightBarBtnItem;
    
//handle textView and longTag effect
    
    [self searchShanbayForEnglishText];
    
}


- (void)searchShanbayForEnglishText
{
   
    _wordToSearch = [[NSString alloc]init];
 
    self.contentTextView.userInteractionEnabled = YES;
    UILongPressGestureRecognizer *longGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.contentTextView addGestureRecognizer:longGr];
    
}

#pragma mark - longPress event - hightlight word and get ready for shanbay api

-(void)longPress:(UILongPressGestureRecognizer *)longPress
{
    // not handle cn page
    if (longPress.state == UIGestureRecognizerStateBegan  && didSwitchLanguage == NO)
    {
        CGPoint location = [longPress locationInView:self.contentTextView];
        location.x -= self.contentTextView.textContainerInset.left;
        location.y -= self.contentTextView.textContainerInset.top;
 
 
        NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.contentTextView.attributedText];
        NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
        [textStorage addLayoutManager:layoutManager];
        
        CGSize size = self.contentTextView.contentSize;
        NSTextContainer *textContainer = [[NSTextContainer alloc] initWithSize: size];
        [layoutManager addTextContainer:textContainer];
        
        
        NSUInteger characterIndex = [layoutManager characterIndexForPoint:location
                                                          inTextContainer:textContainer
                                 fractionOfDistanceBetweenInsertionPoints:NULL];
        if (characterIndex < textStorage.length)
        {
            [self.contentTextView.text enumerateSubstringsInRange:NSMakeRange(0, textStorage.length) options:NSStringEnumerationByWords usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
             {
                 if (NSLocationInRange(characterIndex, enclosingRange))
                 {
                      _wordToSearch =  substring;
                     _wordToSearchRange = substringRange;
#pragma mark - shanbay API
                      CGPoint rawLocation = [longPress locationInView:self.contentTextView];
                     [self showShabyVCAndReadyToPost:substring inLocation:rawLocation];
                     *stop = YES;
                  }
            }];
         }
    }
}


#pragma mark - shanbaySearchVC [ location ]
-(void)showShabyVCAndReadyToPost:(NSString *)wordToSearch inLocation:(CGPoint )location
{
    if([self.shanbayVC.view isDescendantOfView:self.view])
    {
        [self.shanbayVC.view removeFromSuperview];
        self.shanbayVC = NULL;
    }
    
    _offsetForTextView = self.contentTextView.contentOffset;
   
     [self addChildViewController:self.shanbayVC];
    
    [self.view addSubview:self.shanbayVC.view];

    [self.shanbayVC didMoveToParentViewController:self];
    
// show when connected
    self.shanbayVC.view.hidden =  YES;


// location
 
    int charW = 8;
    int charH = 15;
    int charX = location.x;
    int charY = location.y;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(charX, charY, charW, charH)];
 
    BOOL topY = (button.center.x == screenW/2 && (button.center.y - self.contentTextView.contentOffset.y) <= screenH/2);
    BOOL bottomY = (button.center.x == screenW/2 && (button.center.y - self.contentTextView.contentOffset.y) > screenH/2);
    BOOL leftX = (button.center.x <= screenW/2 && (button.center.y - self.contentTextView.contentOffset.y) == screenH/2);
    BOOL rightX = (button.center.x > screenW/2 && (button.center.y - self.contentTextView.contentOffset.y) == screenH/2);
    
    
    
    if (button.center.x > screenW/2 && (button.center.y - self.contentTextView.contentOffset.y)>=screenH/2)
    {
        self.shanbayVC.view.origin = CGPointMake(button.frame.origin.x - self.shanbayVC.view.bounds.size.width, button.frame.origin.y - self.contentTextView.contentOffset.y - self.shanbayVC.view.bounds.size.height);
        
    }
    
    else if( (button.center.x <= screenW/2 && (button.center.y - self.contentTextView.contentOffset.y) >=screenH/2) || bottomY )
    {
        self.shanbayVC.view.origin = CGPointMake(CGRectGetMaxX(button.frame), button.frame.origin.y - self.contentTextView.contentOffset.y - self.shanbayVC.view.frame.size.height);
        
    }
    
   
    if ((button.center.x > screenW/2 && (button.center.y - self.contentTextView.contentOffset.y) < screenH/2) || rightX)
    {
        self.shanbayVC.view.origin = CGPointMake(button.frame.origin.x - self.shanbayVC.view.frame.size.width, CGRectGetMaxY(button.frame) - self.contentTextView.contentOffset.y);
    }
    
   
    if ((button.center.x <= screenW/2 && (button.center.y - self.contentTextView.contentOffset.y) <screenH/2) || topY || leftX)
    {
        self.shanbayVC.view.origin = CGPointMake(CGRectGetMaxX(button.frame), CGRectGetMaxY(button.frame)- self.contentTextView.contentOffset.y);
        
    }
    
#pragma mark -  handle json
    [self.shanbayVC  PostToGetDataWithWord:wordToSearch];
    
}




#pragma mark - textView
-(void)setTextWithFontname:(NSString *)font  textContent:(NSString *)content
{
    
 
    double textSize = [[[NSUserDefaults standardUserDefaults] objectForKey:@"textSize"] doubleValue];
 
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 6;
    
    NSDictionary *attrs = @{
                            NSFontAttributeName:[UIFont fontWithName:font size:textSize],
                            NSParagraphStyleAttributeName:paragraphStyle
                            };
    self.contentTextView.attributedText = [[NSAttributedString alloc] initWithString:content attributes:attrs];
    
}


#pragma mark - set titleLabel for en && cn
-(void)setTitleLabelFormat
{
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"readingTitleViewImage.jpg"]];
    [_titleLabel sizeToFit];
    [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:12.0]];//加粗
    _titleLabel.adjustsFontSizeToFitWidth = YES;
}


#pragma mark -  jumpToTranslationText
-(void)jumpToTranslationText:(UIBarButtonItem *)rightBarBtnItem
{
    if (didSwitchLanguage == NO)
    {
        [self setTextWithFontname:@"Arial-BoldMT" textContent:self.currentChapter.translation];
        
        _titleLabel.text = [NSString stringWithFormat:@"%d.%@",_currentChapterIndex +1 ,self.currentChapter.chinese_title ];
  
        rightBarBtnItem.image = [UIImage imageNamed:@"showEnglishReading.png"];
               didSwitchLanguage = YES;
        return;
    }
 
    else
    {
        [self setTextWithFontname:@"AmericanTypewriter-Bold" textContent:self.currentChapter.content_for_reading];
        
        _titleLabel.text = [NSString stringWithFormat:@"%d.%@",_currentChapterIndex +1 ,self.currentChapter.title ];
 
        rightBarBtnItem.image = [UIImage imageNamed:@"showTranslation.png"];
        
        didSwitchLanguage = NO;
        return;
    }

    
}


#pragma mark - timeManager
-(void)viewWillDisappear:(BOOL)animated
{
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    
    
    NSMutableArray *array =  [NSMutableArray arrayWithContentsOfFile:readingChapterATPath];
    NSMutableDictionary *dict = array[[TNDataContainer sharedDataContainer].chapterIndex];
    
    dict[@"endDate"] = endDate;
    NSTimeInterval thisTotalTime =  [endDate timeIntervalSinceDate:dict[@"startDate"]];
    NSTimeInterval totalTime = [dict[@"totalTime"] doubleValue] + thisTotalTime ;
    dict[@"totalTime"] = [NSNumber numberWithDouble:totalTime];
    
    NSNumber *didReadChapter = [NSNumber numberWithBool:YES];
    dict[@"didReadChapter"] = didReadChapter;
    
    [array writeToFile:readingChapterATPath atomically:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
