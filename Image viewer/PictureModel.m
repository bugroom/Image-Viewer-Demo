//
//  PictureModel.m
//  Image viewer
//
//  Created by ZC on 2016/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "PictureModel.h"

@implementation PictureModel

-(void)setModelWithDictionary:(NSDictionary *)dict

{
    self.preview = dict[@"preview"];
    self.img = dict[@"img"];
}
-(void)setModelWithClassDictionary:(NSDictionary *)dict
{
    self.cid = dict[@"id"];
    self.cover = dict[@"cover"];
    self.name = dict[@"name"];
}
@end
