//
//  PictureFlowView.m
//  Image viewer//
//  Created by ZC on 16/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "PictureFlowView.h"
#import "SDPhotoBrowser/SDPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "Config.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PictureModel.h"
#import "PictureFlowCell.h"
#import "AFNetworking.h"
#include "MJRefresh.h"
//#import "MBProgressHUD+Manager.h"
#import "SVProgressHUD.h"

@interface PictureFlowView ()<UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout,SDPhotoBrowserDelegate,UIScrollViewDelegate>

{
    NSInteger _currentPage;
    NSString *_urlString;
    ViewController *_controller;
    ClassViewController *_classController;
    

    CGFloat _systemVersion;
}

@property (nonatomic,strong) NSMutableArray *dataSource;

//@property (nonatomic,weak)MBProgressHUD *hud;

@end
@implementation PictureFlowView


-(instancetype)initWithFrame:(CGRect)frame andUrlString:(NSString *)urlString andController:(ViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        _systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
        
        _currentPage = 0;
        
        _controller = controller;
        
        _urlString = urlString;
        
        [self requestDataFromeNetorking:[NSString stringWithFormat:_urlString,_currentPage * 30]];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame andUrlString:(NSString *)urlString andClassController:(ClassViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        _systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
        _currentPage = 0;
        _urlString = urlString;
        _classController = controller;
        [self requestDataFromeNetorking:[NSString stringWithFormat:_urlString,_currentPage * 30]];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andUrlString:(NSString *)urlString
{
    self = [super initWithFrame:frame];
    if (self) {
        _systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
        _currentPage = 0;
        _urlString = urlString;
        [self requestDataFromeNetorking:[NSString stringWithFormat:urlString,_currentPage * 30]];
    }
    return self;
}

- (NSString *)stringEncoding:(NSString *)string
{
    if (_systemVersion < 9.0) {
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    else
    {
        string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    }
    return string;
}

- (void)requestDataFromeNetorking:(NSString *)urlStr
{
    urlStr = [self stringEncoding:urlStr];

    if (!_currentPage) {
        
        [SVProgressHUD showWithStatus:@"正在刷新"];
    }
    
    [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [_collectionView.mj_header endRefreshing];
        [_collectionView.mj_footer endRefreshing];
        
        [SVProgressHUD dismiss];
        [self handleDataObjectWithReponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"刷新", nil] show];
    }];
    
}

- (void)handleDataObjectWithReponseObject:(id)responseObject
{
    if ([responseObject[@"res"][@"wallpaper"] count] < 1) {
        
        [SVProgressHUD setMinimumDismissTimeInterval:1];

        [SVProgressHUD showInfoWithStatus:@"到底啦"];
       
    }
    
    if (_currentPage == 0) {
        [self.dataSource removeAllObjects];
    }
    
    for (NSDictionary *dict in responseObject[@"res"][@"wallpaper"]) {
        PictureModel *model = [[PictureModel alloc]init];
        [model setModelWithDictionary:dict];
        [self.dataSource addObject:model];
    }
    [self.collectionView reloadData];
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc]init];
        layout.columnCount = 3;
        layout.minimumColumnSpacing = 1;
        layout.minimumInteritemSpacing = 1;
        layout.sectionInset = UIEdgeInsetsMake(1, 1, 1, 1);
    
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        if (_controller) {
            collectionView.contentInset = UIEdgeInsetsMake(64 + 35, 0, 0, 0);
        }else
        {
            collectionView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
            
        }
        
        
        collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            _currentPage = 0;
            [self requestDataFromeNetorking:[NSString stringWithFormat:_urlString,_currentPage * 30]];
        }];
        collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            _currentPage += 30;
            [self requestDataFromeNetorking:[NSString stringWithFormat:_urlString,_currentPage * 30]];
        }];
        [collectionView registerNib:[UINib nibWithNibName:@"PictureFlowCell" bundle:nil] forCellWithReuseIdentifier:@"PictureFlowCell"];
        collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:collectionView];
        _collectionView = collectionView;
        
        
    }
    return _collectionView;
}


-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{

    return 1;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout heightForHeaderInSection:(NSInteger)section
{

    return 0;
}





- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    
    PictureFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PictureFlowCell" forIndexPath:indexPath];
    [cell setCellWithModel:self.dataSource[indexPath.item]];
    
    return cell;
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(1, 1);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.sourceImagesContainerView = _collectionView; // 原图的父控件
    browser.imageCount = self.dataSource.count;
    browser.currentImageIndex = indexPath.item;
    browser.delegate = self;
    [browser show];
    
}

- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    
    PictureFlowCell *cell = (PictureFlowCell *)[_collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    
    return cell.imageView.image;
}


// 返回高质量图片的url
- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    
    NSString *urlStr = [self.dataSource[index] img];
    return [NSURL URLWithString:urlStr];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    CGFloat velicity = [pan velocityInView:_collectionView].y;
    if (scrollView.contentOffset.y > 64 + 35) {
        if (_controller) {
            _controller.zcScrollView.topTitlebackgroundView.hidden = YES;
        }
        if (velicity > 5) {
            
            [_controller.navigationController setNavigationBarHidden:NO animated:YES];
            [_classController.navigationController setNavigationBarHidden:NO animated:YES];
            
        }
        else if (velicity < -5)
        {
            [_controller.navigationController setNavigationBarHidden:YES animated:YES];
            [_classController.navigationController setNavigationBarHidden:YES animated:YES];
            
        }
    }
    else{
        [_controller.navigationController setNavigationBarHidden:NO animated:YES];
        [_classController.navigationController setNavigationBarHidden:NO animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (_controller) {
                _controller.zcScrollView.topTitlebackgroundView.hidden = NO;
            }
        });
    }
    
    
}

-(NSMutableArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            [_collectionView.mj_header endRefreshing];
            [_collectionView.mj_footer endRefreshing];
            if (self.backToController) {
                _backToController();
            }
            break;
        case 1:
            [self requestDataFromeNetorking:[NSString stringWithFormat:_urlString,_currentPage * 30]];
            break;
        default:
            break;
    }
}

@end
