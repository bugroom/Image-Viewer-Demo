//
//  PictureFlowCell.m
//  Image viewer
//
//  Created by ZC on 2016/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "PictureFlowCell.h"
#import "UIImageView+WebCache.h"
@implementation PictureFlowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setCellWithModel:(PictureModel *)model
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.preview] placeholderImage:[UIImage imageNamed:@"egopv_photo_placeholder"]];
    
}
@end
