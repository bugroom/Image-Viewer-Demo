//
//  UserInfoController.h
//  Image viewer
//
//  Created by ZC on 2016/9/27.
//  Copyright © 2016年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *headerImageButton;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;

@property (weak, nonatomic) IBOutlet UILabel *morenLabel;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *descHeight;

@end
