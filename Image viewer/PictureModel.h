//
//  PictureModel.h
//  Image viewer
//
//  Created by ZC on 2016/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PictureModel : NSObject

@property (nonatomic,copy) NSString *preview;
@property (nonatomic,copy) NSString *img;

@property (nonatomic,copy) NSString *cid;
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *name;

-(void)setModelWithDictionary:(NSDictionary *)dict;
-(void)setModelWithClassDictionary:(NSDictionary *)dict;
@end
