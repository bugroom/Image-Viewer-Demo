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
@property (weak, nonatomic) IBOutlet UITextField *signatureTextField;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end
