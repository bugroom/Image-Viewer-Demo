//
//  PictureFlowCell.h
//  Image viewer
//
//  Created by ZC on 2016/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureModel.h"
@interface PictureFlowCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

- (void)setCellWithModel:(PictureModel *)model;

@end
