//
//  PictureFlowView.h
//  Image viewer
//
//  Created by ZC on 16/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "ClassViewController.h"
typedef void (^BackToController)(void);
@interface PictureFlowView : UIView

@property (nonatomic,weak)UICollectionView *collectionView;
@property (nonatomic,copy)BackToController backToController;
-(instancetype)initWithFrame:(CGRect)frame andUrlString:(NSString *)urlString;
-(instancetype)initWithFrame:(CGRect)frame andUrlString:(NSString *)urlString andController:(ViewController *)controller;
-(instancetype)initWithFrame:(CGRect)frame andUrlString:(NSString *)urlString andClassController:(ClassViewController *)controller;
//-(instancetype)initWithFrame:(CGRect)frame andUrlString:(NSString *)urlString andSearchResultController:(SearchResultController *)controller;
@end
