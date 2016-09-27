//
//  SearchPreviewController.h
//  Image viewer
//
//  Created by ZC on 2016/9/27.
//  Copyright © 2016年 zc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultController.h"
typedef void (^BackToLastController)(SearchResultController *);
@interface SearchPreviewController : UIViewController
@property (nonatomic, strong) NSArray *searchResultArray;
@property (nonatomic, copy) BackToLastController backToLastController;
@end
