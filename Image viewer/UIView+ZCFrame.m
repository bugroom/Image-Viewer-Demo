//
//  UIView+ZCFrame
//
//  Created by ZC on 16-8-27.
//  Copyright (c) 2016年 . All rights reserved.
//

#import "UIView+ZCFrame.h"

@implementation UIView (ZCFrame)

- (CGFloat)zcLeft
{
    return self.frame.origin.x;
}

- (CGFloat)zcRight
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)zcTop
{
    return self.frame.origin.y;
}

- (CGFloat)zcBottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGSize)zcSize{
    return self.frame.size;
}

- (CGFloat)zcWidth
{
    return self.frame.size.width;
}

- (CGFloat)zcHeight
{
    return self.frame.size.height;
}

- (CGFloat)zcCenterX
{
    return self.center.x;
}

- (CGFloat)zcCenterY
{
    return self.center.y;
}

- (CGFloat)zcMaxX
{
    return CGRectGetMaxX(self.frame);
}

- (CGFloat)zcMaxY
{
    return CGRectGetMaxY(self.frame);
}

- (void)setZcLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x = left;
    self.frame = frame;
}

- (void)setZcRight:(CGFloat)right;
{
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (void)setZcBottom:(CGFloat)bottom
{
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (void)setZcSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setZcTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y = top;
    self.frame = frame;
}

- (void)setZcWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setZcHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setZcOrigin:(CGPoint)point
{
    CGRect frame = self.frame;
    frame.origin = point;
    self.frame = frame;
}

- (void)setZcCenterX:(CGFloat)centerX
{
    self.center = CGPointMake(centerX, self.center.y);
}

- (void)setZcCenterY:(CGFloat)centerY
{
    self.center = CGPointMake(self.center.x, centerY);
}

- (void)setZcAddTop:(CGFloat)top
{
    CGRect frame = self.frame;
    frame.origin.y += top;
    self.frame = frame;
}

- (void)setZcAddLeft:(CGFloat)left
{
    CGRect frame = self.frame;
    frame.origin.x += left;
    self.frame = frame;
}

@end
