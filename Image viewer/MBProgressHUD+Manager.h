//
//  MBProgressHUD+Manager.h
//  Image viewer
//
//  Created by ZC on 2016/9/27.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Manager)
+ (void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated title:(NSString *)title mode:(MBProgressHUDMode)model andTimeInterval:(NSTimeInterval )time;

+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated title:(NSString *)title mode:(MBProgressHUDMode)model;


@end
