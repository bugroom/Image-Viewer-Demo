//
//  MeUserInfoCell.h
//  Image Viewer Demo
//
//  Created by ZC on 2016/9/28.
//  Copyright © 2016年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MeViewController.h"
@interface MeUserInfoCell : UITableViewCell

@property (nonatomic,weak) MeViewController *cotroller;

@property (weak, nonatomic) IBOutlet UIImageView *myHeaderImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;


@end
