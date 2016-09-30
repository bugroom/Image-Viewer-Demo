//
//  UIView+ZCFrame
//
//  Created by ZC on 16-8-27.
//  Copyright (c) 2016年 . All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZCFrame)

//不用再蛋疼的写某view.frame=CGRectMake(x,y,z,o)了。
- (CGFloat)zcLeft;
- (CGFloat)zcRight;
- (CGSize)zcSize;
- (CGFloat)zcTop;
- (CGFloat)zcBottom;
- (CGFloat)zcWidth;
- (CGFloat)zcHeight;
- (CGFloat)zcCenterX;
- (CGFloat)zcCenterY;
- (CGFloat)zcMaxX;
- (CGFloat)zcMaxY;
- (void)setZcLeft:(CGFloat)left;
- (void)setZcRight:(CGFloat)right;
- (void)setZcSize:(CGSize)size;
- (void)setZcTop:(CGFloat)top;
- (void)setZcBottom:(CGFloat)bottom;
- (void)setZcWidth:(CGFloat)width;
- (void)setZcHeight:(CGFloat)height;
- (void)setZcCenterX:(CGFloat)centerX;
- (void)setZcCenterY:(CGFloat)centerY;
- (void)setZcOrigin:(CGPoint)point;
- (void)setZcAddTop:(CGFloat)top;
- (void)setZcAddLeft:(CGFloat)left;

@end
