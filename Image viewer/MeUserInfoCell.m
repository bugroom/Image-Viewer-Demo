//
//  MeUserInfoCell.m
//  Image Viewer Demo
//
//  Created by ZC on 2016/9/28.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "MeUserInfoCell.h"
#import "UserInfoController.h"
@implementation MeUserInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.myHeaderImageView.layer.cornerRadius = 40;
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    self.backgroundView = [[UIVisualEffectView alloc]initWithEffect:blurEffect];
    self.backgroundColor = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)userHeaderClick:(UITapGestureRecognizer *)sender {
    UserInfoController *userinfoController = [[UserInfoController alloc]initWithNibName:@"UserInfoController" bundle:nil];
    [self.cotroller.navigationController pushViewController:userinfoController animated:YES];
    
}

@end
