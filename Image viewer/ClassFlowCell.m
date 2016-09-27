//
//  ClassFlowCell.m
//  Image viewer
//
//  Created by ZC on 16/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "ClassFlowCell.h"
#import "UIImageView+WebCache.h"
@implementation ClassFlowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setCellWithModel:(PictureModel *)model
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.cover] placeholderImage:[UIImage imageNamed:@"egopv_photo_placeholder"]];
    self.textLabel.text = model.name;
}

@end
