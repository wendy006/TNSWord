//
//  TNSSettingVC.m
//  TNSWord
//
//  Created by mac on 15/8/3.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSSettingVC.h"
@interface TNSSettingVC ()<UITextFieldDelegate>

//audio effect
@property (weak, nonatomic) IBOutlet UISwitch *openAudioEffectSwitch;

//font size
@property (weak, nonatomic) IBOutlet UITextField *textSizeField;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fontLabelVerticalSpaceToTop;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fontLabelHorizontalSpaceToLeft;

@end

@implementation TNSSettingVC



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.fontLabelVerticalSpaceToTop.constant = 94.0/480.0 * screenH;
    self.fontLabelHorizontalSpaceToLeft.constant = 100.0/480.0 * screenW;
    
    self.textSizeField.delegate = self;
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backGroud.jpg"]];
    
    
    //audio effect switch
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"hasOpenAudioEffect"] boolValue])
    {
        self.openAudioEffectSwitch.on = YES;
    }
    
    else
    {
        self.openAudioEffectSwitch.on = NO;
    }
    
}


// save data when shutdown current page
- (IBAction)didChangeValueAndShutPage:(id)sender
{
    // 1.font size
    
    NSString *textSize = self.textSizeField.text;
    int size = textSize.intValue;
    
    if(size >= 8 && size<= 15)
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:size] forKey:@"textSize"];
    }
    // default value
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithDouble:12] forKey:@"textSize"];
    }
    
    // 2.audio effect
    
    BOOL hasOpenAudioEffect = self.openAudioEffectSwitch.on;
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:hasOpenAudioEffect] forKey:@"hasOpenAudioEffect"];
    [self.navigationController popViewControllerAnimated:YES];
    
}


// keyboard 1 for input
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
    [self.textSizeField resignFirstResponder];
    
    return YES;
}

// keyboard 2 for input
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    if (![touch.view isKindOfClass:[UITextField class]])
    {
        [self.textSizeField resignFirstResponder];
    }
    
}

- (IBAction)audioEffectValueDidChanged:(id)sender
{}


- (IBAction)textSizeDidChanged:(id)sender
{}
@end
