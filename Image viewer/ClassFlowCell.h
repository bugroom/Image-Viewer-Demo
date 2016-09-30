//
//  ClassFlowCell.h
//  Image viewer
//
//  Created by ZC on 16/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PictureModel.h"
@interface ClassFlowCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (void)setCellWithModel:(PictureModel *)model;
@end
