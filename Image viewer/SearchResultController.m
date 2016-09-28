//
//  SearchResultController.m
//  Image viewer
//
//  Created by ZC on 2016/9/27.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "SearchResultController.h"
#import "PictureFlowView.h"
#import "Config.h"
@interface SearchResultController ()
{
    NSString *_urlString;
}

@property (nonatomic,weak)PictureFlowView *pictureFlowView;
@end


@implementation SearchResultController

- (instancetype)initWithString:(NSString *)string
{
    self = [super init];
    if (self) {
        self.title = @"搜索结果";
        _urlString = [NSString stringWithFormat:kSearchResultUrlString,string];
        _urlString = [_urlString stringByAppendingString:@"&skip=%ld"];
        self.view.backgroundColor = [UIColor whiteColor];
        [self pictureFlowView];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(PictureFlowView *)pictureFlowView
{
    if (!_pictureFlowView) {
        PictureFlowView *pictureFlowView = [[PictureFlowView alloc]initWithFrame:self.view.bounds andUrlString:_urlString];
        [self.view addSubview:pictureFlowView];
        _pictureFlowView = pictureFlowView;
    }
    return _pictureFlowView;
}


-(void)dealloc
{
    NSLog(@"SearchResultController dealloc");
}

@end
