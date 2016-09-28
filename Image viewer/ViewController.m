//
//  ViewController.m
//  Image viewer
//
//  Created by ZC on 2016/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "ViewController.h"
#import "PictureFlowView.h"
#import "ClassFlowView.h"
#import "Config.h"
#import "MeViewController.h"
#import "SearchViewController.h"
#import "MBProgressHUD.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
@interface ViewController () <ZCScrollViewDelegate,UISearchBarDelegate,MBProgressHUDDelegate>

@property (nonatomic, strong) NSMutableArray *searchResultArray;

@end

@implementation ViewController

-(void)loadView
{
    [super loadView];
//    self.navigationController.fd_fullscreenPopGestureRecognizer.enabled = NO;
//    self.fd_interactivePopDisabled = YES;
    self.fd_prefersNavigationBarHidden = NO;
    
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hub.label.text = @"正在加载";
    hub.delegate = self;
    [hub hideAnimated:YES afterDelay:10];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hub removeFromSuperview];
    });
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    //[self searchBar];
    //[self searchBarController];
    [self creatBarButtonItem];
    [self zcScrollView];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (void)creatBarButtonItem
{

    UIBarButtonItem *lelfButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"search_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(leftButtonItemClick)];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"user_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonItemClick)];
    
    self.navigationItem.leftBarButtonItem = lelfButtonItem;
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)leftButtonItemClick
{

    //SearchViewController *searchViewController = [[SearchViewController alloc]initWithSearchText:[[NSUserDefaults standardUserDefaults] valueForKey:@"HotTitle"]];
    SearchViewController *searchViewController = [[SearchViewController alloc]init];
    searchViewController.title = @"搜索";
    [self.navigationController pushViewController:searchViewController animated:YES];

}

- (void)rightButtonItemClick
{
    MeViewController *meVC = [[MeViewController alloc]init];
    meVC.title = @"我的";
    [self.navigationController pushViewController:meVC animated:YES];
}

-(ZCScrollView *)zcScrollView
{
    if (!_zcScrollView) {
        ZCScrollView *zcScrollView = [ZCScrollView topTitleViewWithFrame:self.view.bounds andDelegate:self];
        zcScrollView.currentPage = 1;
        [self.view addSubview:zcScrollView];
        _zcScrollView = zcScrollView;
    }
    return _zcScrollView;
}

- (UIView *)zcScrollView:(ZCScrollView *)zcScrollView viewForPage:(NSInteger)page
{
    switch (page) {
        case 0:
            return [[ClassFlowView alloc]initWithFrame:self.view.bounds andUrlString:kClassUrlString andController:self];
            break;
        case 1:
            return [[PictureFlowView alloc]initWithFrame:self.view.bounds andUrlString:kMainPageUrlString andController:self];
            break;
        case 2:
            return [[PictureFlowView alloc]initWithFrame:self.view.bounds andUrlString:kHotUrlString andController:self];
            break;
        default:
            break;
    }
    return nil;
}



- (NSArray *)topTitlesInZCScrollView:(ZCScrollView *)zcScrollView
{
    return @[@"分类",@"最新",@"热门"];
}



-(void)zcScrollViewDidScroll:(ZCScrollView *)zcScrollView
{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

-(void)dealloc
{
    NSLog(@"ViewController dealloc");
}

@end
