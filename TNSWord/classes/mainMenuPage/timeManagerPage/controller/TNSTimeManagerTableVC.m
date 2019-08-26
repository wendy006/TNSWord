//
//  TNSTimeManagerTableVC.m
//  TNSWord
//
//  Created by mac on 15/7/31.
//  Copyright (c) 2015年 tanorigin. All rights reserved.
//

#import "TNSTimeManagerTableVC.h"
#import "TNSTimeManagerTCell.h"

@interface TNSTimeManagerTableVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TNSTimeManagerTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //separator attr
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.separatorColor = [UIColor whiteColor];
    self.tableView.separatorInset = UIEdgeInsetsMake(10, 10, 10, 10);
 
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [TNDataContainer sharedDataContainer].chapters.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    [TNDataContainer sharedDataContainer].timeManagerTBVChapterIndex = indexPath.row;
    static  NSString * ID = @"timeManagerCell";
    TNSTimeManagerTCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if(cell == nil)
    {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"TNSTimeManagerTCell" owner:nil options:nil] lastObject];
    }
    return cell;
}

 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{}

@end
