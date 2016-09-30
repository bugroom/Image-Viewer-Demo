//
//  TitleViewCell.m
//  Image viewer
//
//  Created by ZC on 2016/9/26.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "TitleViewCell.h"

@implementation TitleViewCell


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    self.titleLabel.layer.cornerRadius = self.frame.size.height/2;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.clipsToBounds = YES;
    self.titleLabel.backgroundColor = [UIColor colorWithRed:arc4random()%256/255.0 green:arc4random()%256/255.0 blue:arc4random()%256/255.0 alpha:1];
}

@end
