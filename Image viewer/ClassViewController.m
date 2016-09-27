//
//  ClassViewController.m
//  Image viewer
//
//  Created by ZC on 16/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "ClassViewController.h"
#import "PictureFlowView.h"
@interface ClassViewController ()
{
    NSString *_urlString;
}
@property (nonatomic,weak)PictureFlowView *pictureFlowView;

@end

@implementation ClassViewController

- (instancetype)initWithFrame:(CGRect)frame andName:(NSString *)name andUrlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        self.title = name;
        _urlString = [urlString stringByAppendingString:@"&skip=%ld"];
        self.automaticallyAdjustsScrollViewInsets = NO;
        [self pictureFlowView];
        self.view.backgroundColor = [UIColor whiteColor];
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
        PictureFlowView *pictureFlowView = [[PictureFlowView alloc]initWithFrame:self.view.bounds andUrlString:_urlString andClassController:self];
        pictureFlowView.backToController = ^{
            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        };
        [self.view addSubview:pictureFlowView];
        _pictureFlowView = pictureFlowView;
    }
    return _pictureFlowView;
}

@end
