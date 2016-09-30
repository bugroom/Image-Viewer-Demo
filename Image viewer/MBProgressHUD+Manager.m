
//
//  MBProgressHUD+Manager.m
//  Image viewer
//
//  Created by ZC on 2016/9/27.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "MBProgressHUD+Manager.h"

@implementation MBProgressHUD (Manager)

+ (void)showHUDAddedTo:(UIView *)view animated:(BOOL)animated title:(NSString *)title mode:(MBProgressHUDMode)model andTimeInterval:(NSTimeInterval )time{
    MBProgressHUD *hud = [self showHUDAddedTo:view animated:YES];
    hud.label.text = title;
    hud.mode = model;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:time];
}

+ (instancetype)showHUDAddedTo:(UIView *)view animated:(BOOL)animated title:(NSString *)title mode:(MBProgressHUDMode)model{
    MBProgressHUD *hud = [[self alloc] initWithView:view];
    hud.label.text = title;
    hud.removeFromSuperViewOnHide = YES;
    [view addSubview:hud];
    [hud showAnimated:animated];
    return hud;
}


@end
