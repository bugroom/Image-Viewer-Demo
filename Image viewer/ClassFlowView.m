//
//  PictureFlowView.m
//  Image viewer
//
//  Created by ZC on 16/9/25.
//  Copyright © 2016年 zc. All rights reserved.
//

#import "ClassFlowView.h"
#import "UIImageView+WebCache.h"
#import "Config.h"
#import "CHTCollectionViewWaterfallLayout.h"
#import "PictureModel.h"
#import "ClassFlowCell.h"
#import "AFNetworking.h"
#include "MJRefresh.h"
#import "ClassViewController.h"
#define kUrlString @"http://service.picasso.adesk.com/v1/wallpaper/category/%@/wallpaper?limit=30&adult=false&first=1&order=new"

@interface ClassFlowView ()<UICollectionViewDelegate,UICollectionViewDataSource,CHTCollectionViewDelegateWaterfallLayout,UIScrollViewDelegate>

{
    NSInteger _currentPage;
    NSString *_urlString;
    ViewController *_controller;
}

@property (nonatomic,strong) NSMutableArray *dataSource;
@property (nonatomic,weak)UICollectionView *collectionView;


@end
@implementation ClassFlowView

-(instancetype)initWithFrame:(CGRect)frame andUrlString:(NSString *)urlString andController:(ViewController *)controller
{
    self = [super initWithFrame:frame];
    if (self) {
        _currentPage = 0;
        _urlString = urlString;
        _controller = controller;
        [self requestDataFromeNetorking:_urlString];
    }
    return self;
}


- (void)requestDataFromeNetorking:(NSString *)urlStr
{
    [[AFHTTPSessionManager manager] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleDataObjectWithReponseObject:responseObject];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络错误" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"刷新", nil] show];
    }];
    
}

- (void)handleDataObjectWithReponseObject:(id)responseObject
{
    if (_currentPage == 0) {
        [self.dataSource removeAllObjects];
    }
    
    for (NSDictionary *dict in responseObject[@"res"][@"category"]) {
        PictureModel *model = [[PictureModel alloc]init];
        [model setModelWithClassDictionary:dict];
        [self.dataSource addObject:model];
    }
    [self.collectionView reloadData];
}

-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        CHTCollectionViewWaterfallLayout *layout = [[CHTCollectionViewWaterfallLayout alloc]init];
        layout.columnCount = 2;
        layout.minimumColumnSpacing = 5;
        layout.minimumInteritemSpacing = 5;
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.bounds collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.contentInset = UIEdgeInsetsMake(35 + 64, 0, 0, 0);
        [collectionView registerNib:[UINib nibWithNibName:@"ClassFlowCell" bundle:nil] forCellWithReuseIdentifier:@"ClassFlowCell"];
        collectionView.backgroundColor = [UIColor whiteColor];
        [self addSubview:collectionView];
        _collectionView = collectionView;
        
        
    }
    return _collectionView;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath;
{
    
    ClassFlowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ClassFlowCell" forIndexPath:indexPath];
    [cell setCellWithModel:self.dataSource[indexPath.item]];
    
    return cell;
    
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    return CGSizeMake(16, 9);
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //[_controller.searchBar resignFirstResponder];
    PictureModel *model = _dataSource[indexPath.item];
    NSString *urlString = [NSString stringWithFormat:@"http://service.picasso.adesk.com/v1/wallpaper/category/%@/wallpaper?limit=30&adult=false&first=1&order=new",model.cid];
    ClassViewController *vc = [[ClassViewController alloc]initWithFrame:self.bounds andName:model.name andUrlString:urlString];
    [_controller.navigationController pushViewController:vc animated:YES];
    
    
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //[_controller.searchBar resignFirstResponder];
    UIPanGestureRecognizer *pan = scrollView.panGestureRecognizer;
    CGFloat velicity = [pan velocityInView:_collectionView].y;
    if (scrollView.contentOffset.y > 64 + 35) {
        if (velicity > 5) {
            
            [_controller.navigationController setNavigationBarHidden:NO animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                _controller.zcScrollView.topTitlebackgroundView.hidden = NO;
            });
        }
        else if (velicity < -5)
        {
            [_controller.navigationController setNavigationBarHidden:YES animated:YES];
            _controller.zcScrollView.topTitlebackgroundView.hidden = YES;
        }
    }
    else{
        [_controller.navigationController setNavigationBarHidden:NO animated:YES];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            _controller.zcScrollView.topTitlebackgroundView.hidden = NO;
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
            
            break;
        case 1:
            [self requestDataFromeNetorking:_urlString];
            break;
        default:
            break;
    }
}
@end
