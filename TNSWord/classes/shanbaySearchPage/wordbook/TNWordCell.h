//
//  TNWordCell.h
//  TNWord
//
//  Created by mac on 15/6/22.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TNWordCell : UITableViewCell

@property (strong, nonatomic) NSString * localAudioUrl;

@property (weak, nonatomic) IBOutlet UILabel *wordLabel;
@property (weak, nonatomic) IBOutlet UILabel *pronunciationLabel;
@property (weak, nonatomic) IBOutlet UILabel *definitionLabel;
@property (weak, nonatomic) IBOutlet UILabel *enDefinitionLabel;
@property (weak, nonatomic) IBOutlet UIButton *audioBtn;
@property (weak, nonatomic) IBOutlet UIButton *addToOkBtn;



@end
