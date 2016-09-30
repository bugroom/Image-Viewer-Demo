//
//  ClassViewController.m
//  Image viewer
//
//  Created by ZC on 16/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "ClassViewController.h"
#import "PictureFlowView.h"
#import "Config.h"
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

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    _pictureFlowView = nil;
    [_pictureFlowView removeFromSuperview];
    _pictureFlowView = nil;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [super viewWillDisappear:animated];
    _pictureFlowView = nil;
    [_pictureFlowView removeFromSuperview];
    _pictureFlowView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(PictureFlowView *)pictureFlowView
{
    if (!_pictureFlowView) {
        PictureFlowView *pictureFlowView = [[PictureFlowView alloc]initWithFrame:self.view.bounds andUrlString:kMainPageUrlString andClassController:self];
        __weak ClassViewController *weakSelf = self;
        pictureFlowView.backToController = ^{
            [weakSelf.navigationController dismissViewControllerAnimated:YES completion:nil];
        };
        [self.view addSubview:pictureFlowView];
        _pictureFlowView = pictureFlowView;
    }
    return _pictureFlowView;
}

-(void)dealloc
{
    NSLog(@"ClassViewController dealloc");
}


@end
