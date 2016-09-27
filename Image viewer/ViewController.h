//
//  ViewController.h
//  Image viewer
//
//  Created by ZC on 2016/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZCScrollView.h"
@interface ViewController : UIViewController

@property (nonatomic,weak) ZCScrollView *zcScrollView;
@property (nonatomic,strong) UISearchController *searchBarController;

@end

